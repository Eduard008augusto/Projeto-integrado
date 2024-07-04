import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';

import './database/var.dart' as globals;

void main() {
  runApp(const MaterialApp(
    home: Feed(),
  ));
}

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOME AREA'),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 20,),
          Icon(Icons.calendar_month),
          SizedBox(width: 20,),
          Icon(Icons.filter_alt_outlined),
        ],
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPublicacoes(globals.idCentro, globals.idArea, globals.idSubArea),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'),);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma publicação encontrada'),);
          } else {
            final List<Map<String, dynamic>> publicacoes = snapshot.data!;
            return ListView.builder(
              itemCount: publicacoes.length,
              itemBuilder: (context, index) {
                final publicacao = publicacoes[index];
                return SizedBox(
                  height: 300,
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: Image.network(
                              'https://pintbackend-w8pt.onrender.com/images/${publicacao['IMAGEMCONTEUDO']}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          Text(publicacao['NOMECONTEUDO'], style: const TextStyle(fontSize: 20.0),),
                          Text(publicacao['MORADA']),
                          Text(publicacao['TELEFONE']),
                        ],
                      ),
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
