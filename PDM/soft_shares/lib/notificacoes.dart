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
                  Image.network(
                      'https://pintbackend-w8pt.onrender.com/images/${notificacao['IMAGEM']}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                  children: [
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