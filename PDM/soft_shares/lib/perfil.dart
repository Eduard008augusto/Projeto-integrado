// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import 'drawer.dart';
import './database/server.dart';
import './database/var.dart' as globals;

void main(){
  runApp(const Perfil());
}

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: const [
          Icon(Icons.edit),
          SizedBox(width: 20.0,),
        ],
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUtilizador(globals.idUtilizador),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'),);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ID DE UTILIZADOR INVÁLIDO'),);
          } else {
            final Map<String, dynamic> user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage('https://pintbackend-w8pt.onrender.com/images/${user['IMAGEMPERFIL']}'),
                      ),
                      const SizedBox(width: 30.0,),
                      Text(
                        user['NOME'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  const Text('Descrição', style: TextStyle( fontSize: 16),),
                  Text(user['DESCRICAO']),
                  const Divider(
                    height: 70,
                    thickness: 1,
                    color: Color.fromARGB(255, 41, 40, 40),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
  future: fetchPublicacaoUser(globals.idUtilizador),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(),);
    } else if (snapshot.hasError) {
      return Center(child: Text('Erro: ${snapshot.error}'),);
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('Nenhuma publicação encontrada'),);
    } else {
      final List<Map<String, dynamic>> publicacoes = snapshot.data!;
      return Expanded(
        child: ListView.builder(
          itemCount: publicacoes.length,
          itemBuilder: (context, index) {
            final publicacao = publicacoes[index];
            var rating = publicacao['mediaAvaliacoesGerais'] ?? 0; 
            var priceRating = publicacao['mediaAvaliacoesPreco'] ?? 0; 

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  globals.idPublicacao = publicacao['ID_CONTEUDO'];
                  Navigator.pushNamed(context, '/conteudo');
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
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 12), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          publicacao['NOMECONTEUDO'],
                          style: const TextStyle(fontSize: 20.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Text(
                              '(${publicacao['totalAvaliacoes']})',
                              style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                            ),
                            const SizedBox(width: 5), 
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (rating) {
                                return Icon(
                                  5 < rating ? Icons.star : Icons.star_border,
                                  color: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (priceRating) {
                            return Icon(
                              Icons.euro,
                              color: 3 < priceRating
                                  ? Colors.black
                                  : Colors.black.withOpacity(0.3),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 6), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 17.0, color: Color.fromARGB(255, 69, 79, 100)),
                            const SizedBox(width: 3), 
                            Expanded(
                              child: Text(
                                publicacao['MORADA'],
                                style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6), 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 17.0, color: Color.fromARGB(255, 69, 79, 100)),
                            const SizedBox(width: 3), 
                            Text(
                              publicacao['TELEFONE'],
                              style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12), 
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  },
)

                ],
              ),
            );
          }
        },
      ),
    );
  }
}