// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import 'horiscroll.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const Feed());
}

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> {
  int _selectedSubAreaId = 0;

  void _onSubAreaSelected(int subAreaId) {
    setState(() {
      _selectedSubAreaId = subAreaId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.nomArea),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          HorizontalListView(onSubAreaSelected: _onSubAreaSelected),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchPublicacoes(globals.idCentro, globals.idArea, _selectedSubAreaId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma publicação encontrada'),
                  );
                } else {
                  final List<Map<String, dynamic>> publicacoes = snapshot.data!;
                  return ListView.builder(
                    itemCount: publicacoes.length,
                    itemBuilder: (context, index) {
                      final publicacao = publicacoes[index];
                      var rating = publicacao['mediaAvaliacoesGerais'];
                      var priceRating = publicacao['mediaAvaliacoesPreco'];

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
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/addconteudo');
        },
        child: Container(
          width: 56.0,
          height: 56.0,
          decoration: const BoxDecoration(
            color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
