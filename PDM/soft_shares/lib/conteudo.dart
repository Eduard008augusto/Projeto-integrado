// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';

import './database/var.dart' as globals;

void main() {
  runApp(const MaterialApp(
    home: Conteudo(),
  ));
}

class Conteudo extends StatelessWidget {
  const Conteudo({super.key});

  void _showRatingDialog(BuildContext context) {
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
                  'Classificar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: const Icon(Icons.star_border),
                      onPressed: () {},
                    );
                  }),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Preço',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return IconButton(
                      icon: const Icon(Icons.euro_symbol),
                      onPressed: () {},
                    );
                  }),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
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

  @override
  Widget build(BuildContext context) {
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200, // Definindo altura fixa para a imagem
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  'https://pintbackend-w8pt.onrender.com/images/${publicacao['IMAGEMCONTEUDO']}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
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
                                    publicacao['NOMECONTEUDO'],
                                    style: const TextStyle(fontSize: 20.0),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '(${publicacao['totalAvaliacoes']})',
                                      style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
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
                                    publicacao['MORADA'],
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
                                    publicacao['HORARIO'],
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
                                    publicacao['TELEFONE'],
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
                                    publicacao['WEBSITE'],
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
                                    publicacao['ACESSIBILIDADE'],
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
                            // Lógica para ação do botão "Direções"
                          },
                          icon: const Icon(Icons.directions, color: Colors.white,),
                          label: const Text('Direções'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), // Cor de fundo
                            foregroundColor: Colors.white // Cor do texto
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showRatingDialog(context); // Chama o diálogo de classificação
                          },
                          icon: const Icon(Icons.star, color: Colors.white),
                          label: const Text('Classificar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), // Cor de fundo
                            foregroundColor: Colors.white, // Cor do texto
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
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? const Color.fromARGB(0xFF, 0xF0, 0x6C, 0x9F) : Colors.white,
        size: 30.0,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
