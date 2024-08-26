import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import './database/var.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;

class Notificoes extends StatefulWidget {
  const Notificoes({super.key});

  @override
  State<Notificoes> createState() => _NotificoesState();
}

class _NotificoesState extends State<Notificoes> {
  Future<Map<String, dynamic>> deleteNotificacoes(var centro, var user) async {
    final response = await http.get(
        Uri.parse('https://seu_base_url/notificacao/delete/$centro/$user'));
    var data = jsonDecode(response.body);
    if (data['success']) {
      print(data['message']);
      Map<String, dynamic> res = Map<String, dynamic>.from(data);
      return res;
    } else {
      throw Exception('Falha ao apagar notificações: ${data['error']}');
    }
  }

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro: ${snapshot.error}',
                    overflow: TextOverflow.ellipsis, maxLines: 2));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Sem notificações :)',
                    overflow: TextOverflow.ellipsis, maxLines: 2));
          } else {
            List<Map<String, dynamic>> notificacoes = snapshot.data!;

            return ListView.builder(
              itemCount: notificacoes.length,
              itemBuilder: (context, index) {
                final notificacao = notificacoes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    color: Colors.grey[200], 
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                              'https://pintbackend-w8pt.onrender.com/images/${notificacao['IMAGEM']}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            notificacao['TEXTO'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            try {
                              await deleteNotificacoes(
                                  globals.idCentro, globals.idUtilizador);
                              setState(() {
                                notificacoes.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Notificação excluída'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erro ao excluir notificação: ${e.toString()}'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
