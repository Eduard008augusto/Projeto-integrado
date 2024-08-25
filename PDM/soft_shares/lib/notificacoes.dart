// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import './database/var.dart' as globals;

class Notificoes extends StatefulWidget {
  const Notificoes({super.key});

  @override
  State<Notificoes> createState() => _NotificoesState();
}

class _NotificoesState extends State<Notificoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          IconButton(onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: const Icon(Icons.delete),
                  title: const Text('Deseja eliminar todas as notificações?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await deleteNotificacoes(globals.idCentro, globals.idUtilizador);
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/notificacoes');
                        } catch (error) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: const Icon(Icons.error),
                                title: const Text('ERRO'),
                                content: Text('$error'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                );
              },
            );
          }, icon: const Icon(Icons.delete)),
          const SizedBox(width: 10,),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getNotificacoes(globals.idCentro, globals.idUtilizador),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('Sem notificações :)', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else {
            final List<Map<String, dynamic>> notificacoes = snapshot.data!;
            
            return ListView.builder(
              itemCount: notificacoes.length,
              itemBuilder: (context, index) {
                 final notificacao = notificacoes[index];
                 return Column(
                  children: [
                    Image.network(
                      'https://pintbackend-w8pt.onrender.com/images/${notificacao['IMAGEM']}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    ListTile(
                      title: Text(notificacao['TEXTO']),
                    ),
                  ],
                );
              }
            );
          }
        },
      )
    );
  }
}