// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import './database/var.dart' as globals;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

bool avaliado = false;

int estrela = 0;
int preco = 0;

int estrelaBD = 0;
int precoBD = 0;

class ConteudoToEdit extends StatelessWidget {
  const ConteudoToEdit({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> check() async {
      try {
        var data = await checkAvaliacao(globals.idUtilizador, globals.idPublicacao);
        if (data['Avaliou']) {
          avaliado = true;
          Map<String, dynamic> res = Map<String, dynamic>.from(data['avaliacao']);
          estrela = res['AVALIACAOGERAL']!;
          print(estrela);
          preco = res['AVALIACAOPRECO'];
        } else {
          avaliado = false;
        }
      } catch (e) {
        print('Erro ao verificar avaliação: $e');
      }
    }

    check();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          globals.nomArea ,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPublicacao(globals.idPublicacao),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma publicação encontrada', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else {
            final Map<String, dynamic> publicacao = snapshot.data!;
            if (publicacao.isEmpty) {
              return const Center(child: Text('Nenhuma publicação encontrada', overflow: TextOverflow.ellipsis, maxLines: 2));
            }
            var mediaAvaliacoesGerais = publicacao['mediaAvaliacoesGerais'];
            var ratingEstrela = mediaAvaliacoesGerais.toInt();
            var ratingPreco = publicacao['mediaAvaliacoesPreco'];
            var totalAvaliacoes = int.tryParse(publicacao['totalAvaliacoes']);
            globals.idSubAreaFAV = publicacao['ID_SUBAREA'];

            globals.idConteudoEdit = publicacao['ID_CONTEUDO'];

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: publicacao['IMAGEMCONTEUDO'] != null 
                                  ? Image.network(
                                      'https://pintbackend-w8pt.onrender.com/images/${publicacao['IMAGEMCONTEUDO']}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : const Placeholder(),
                              ),
                              Positioned(
                                top: 10.0,
                                left: 10.0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    publicacao['NOMECONTEUDO'] ?? 'Nome não disponível',
                                    style: const TextStyle(fontSize: 20.0),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '($totalAvaliacoes)',
                                      style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(width: 5),
                                    RatingBarIndicator(
                                      rating: ratingEstrela.toDouble(),
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
                              ],
                            ),
                            const SizedBox(height: 10),
                            RatingBarIndicator(
                              rating: ratingPreco.toDouble(),
                              itemBuilder: (context, index) => const Icon(
                                Icons.euro,
                                color: Colors.black,
                              ),
                              itemCount: 3,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color.fromARGB(136, 41, 40, 40),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3), 
                                Expanded(
                                  child: Text(
                                    publicacao['MORADA'] ?? 'Morada não disponível',
                                    style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color.fromARGB(136, 41, 40, 40),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3), 
                                Expanded(
                                  child: Text(
                                    publicacao['HORARIO'] ?? 'Horário não disponível',
                                    style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color.fromARGB(136, 41, 40, 40),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3), 
                                Expanded(
                                  child: Text(
                                    publicacao['TELEFONE'] ?? 'Telefone não disponível',
                                    style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color.fromARGB(136, 41, 40, 40),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.web, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3), 
                                Expanded(
                                  child: Text(
                                    publicacao['WEBSITE'] ?? 'Website não disponível',
                                    style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color.fromARGB(136, 41, 40, 40),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.accessibility, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3), 
                                Expanded(
                                  child: Text(
                                    publicacao['ACESSIBILIDADE'] ?? 'Acessibilidade não disponível',
                                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color.fromARGB(136, 41, 40, 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/editconteudo');
        },
        child: Container(
          width: 56.0,
          height: 56.0,
          decoration: const BoxDecoration(
            color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
    );
  }
}
 
class CustomStarRating extends StatelessWidget {
  final int rating;

  const CustomStarRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 20.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
      ),
      unratedColor: Colors.grey.withOpacity(0.5),
      onRatingUpdate: (rating) {
        estrelaBD = rating.toInt();
      },
    );
  }
}

class CustomEuroRating extends StatelessWidget {
  final int rating;

  const CustomEuroRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 3,
      itemSize: 20.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.euro,
        color: Colors.black,
      ),
      unratedColor: Colors.black.withOpacity(0.3),
      onRatingUpdate: (rating) {
        precoBD = rating.toInt();
      },
    );
  }
}
