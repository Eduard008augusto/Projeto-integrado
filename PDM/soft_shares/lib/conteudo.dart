// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import './database/var.dart' as globals;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// Import the photo picker file

bool isFavorite = false;
bool avaliado = false;

int estrela = 0;
int preco = 0;

class Conteudo extends StatelessWidget {
  const Conteudo({super.key});

  void _showRatingDialog(BuildContext context, int estrelas, int preco) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Classificação Geral',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                CustomStarRating(rating: estrela),
                const SizedBox(height: 16),
                const Text(
                  'Classificação do Preço',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomEuroRating(rating: preco),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {

                    print(estrelas);
                    print(preco);
                    
                    if(avaliado){
                      await updateAvaliacao(globals.idAvaliacao, globals.idPublicacao, globals.idUtilizador, estrelas, preco);
                    } else {
                      await createAvaliacao(globals.idPublicacao, globals.idUtilizador, estrelas, preco);
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('Classificar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchGoogleMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$query';

    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> check() async {
      try {
        var data = await checkAvaliacao(globals.idUtilizador, globals.idPublicacao);
        if(data['Avaliou']){
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
          globals.nomArea,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 20),
          Icon(Icons.calendar_month_outlined),
          SizedBox(width: 20),
          Icon(Icons.filter_alt_outlined),
        ],
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
            int ratingEstrela = mediaAvaliacoesGerais.toInt();
            int ratingPreco = publicacao['mediaAvaliacoesPreco'] ?? 0;
            int totalAvaliacoes = int.tryParse(publicacao['totalAvaliacoes']) ?? 0;
            globals.idSubAreaFAV = publicacao['ID_SUBAREA'];

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
                              const Positioned(
                                bottom: 10.0,
                                right: 10.0,
                                child: FavoriteButton(),
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
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < ratingEstrela ? Icons.star : Icons.star_border,
                                            color: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                          );
                                        }),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                return Icon(
                                  Icons.euro,
                                  color: index < ratingPreco
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.3),
                                );
                              }),
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
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _launchGoogleMaps(publicacao['MORADA'] ?? 'Morada não disponível');
                          },
                          icon: const Icon(Icons.directions, color: Colors.white,),
                          label: const Text('Direções'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                            foregroundColor: Colors.white 
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showRatingDialog(context, ratingEstrela, ratingPreco); 
                          },
                          icon: const Icon(Icons.star, color: Colors.white),
                          label: const Text('Classificar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                            foregroundColor: Colors.white, 
                          ),
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
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late Future<Map<String, dynamic>> _futureFavorite;

  @override
  void initState() {
    super.initState();
    _futureFavorite = setFavorito();
  }

  Future<Map<String, dynamic>> setFavorito() async {
    var data = await isFavorito(globals.idUtilizador, globals.idPublicacao);
    setState(() {
      isFavorite = data['isFavorito'];
      if(isFavorite){
        globals.idFavorito = data['IDFAVORITO'];
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureFavorite,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return const Icon(Icons.error);
        } else {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? const Color.fromARGB(0xFF, 0xF0, 0x6C, 0x9F) : Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              try {
                if (isFavorite) {
                  var res = await deleteFavorito(globals.idFavorito);
                  if (res['success']) {
                    setState(() {
                      isFavorite = false;
                    });
                  } else {
                    throw Exception('Falha ao atualizar favorito');
                  }
                } else {
                  var res = await createFavorito(globals.idCentro, globals.idArea, globals.idSubAreaFAV, globals.idPublicacao, globals.idUtilizador);
                  print(res);
                  if (res['success']) {
                    setState(() {
                      isFavorite = true;
                    });
                  } else {
                    throw Exception('Falha ao atualizar favorito');
                  }
                }
              } catch (e) {
                print('Erro: $e');
              }
            },
          );
        }
      },
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
      //allowHalfRating: true,
      itemSize: 20.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
      ),
      unratedColor: Colors.grey.withOpacity(0.5),
      onRatingUpdate: (rating) {
        print(rating);
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
        print(rating);
      },
    );
  }
}
