// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'drawer.dart';
import 'drawer_mapa.dart';
import 'package:soft_shares/edit_perfil.dart';
import './database/server.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const Perfil());
}

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          if(globals.idCentro > 0)
            IconButton(onPressed: (){
              Navigator.pushNamed(context, '/pendente');
            }, icon: const Icon(Icons.pending_actions),),

          const SizedBox(width: 10,),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditarPerfil()),
              );
            },
          ),
          const SizedBox(width: 10.0,),
        ],
      ),
      drawer: globals.idCentro == 0 ? const MenuDrawerMapa() : const MenuDrawer(),
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
                        backgroundImage: NetworkImage(user['IMAGEMPERFIL'] == null ? 'https://cdn.discordapp.com/attachments/1154170394400542730/1260333904976679064/01.png?ex=668ef0ea&is=668d9f6a&hm=b909016ee5266e728eb2421b043a637a5d32156b3f0f4e9c59c4575af5208667&' : 'https://pintbackend-w8pt.onrender.com/images/${user['IMAGEMPERFIL']}'),
                      ),
                      const SizedBox(width: 30.0,),
                      Expanded(
                        child: Text(
                          user['NOME'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  const Text('Descrição', style: TextStyle(fontSize: 16),),
                  Text(user['DESCRICAO'] == null ? '' : user['DESCRICAO']!),
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
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                              RatingBarIndicator(
                                                rating: rating.toDouble(),
                                                itemBuilder: (context, index) => const Icon(
                                                  Icons.star,
                                                  color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6), 
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                          child: RatingBarIndicator(
                                            rating: priceRating.toDouble(),
                                            itemBuilder: (context, index) => const Icon(
                                              Icons.euro,
                                              color: Colors.black,
                                            ),
                                            itemCount: 3,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
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
