import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const MaterialApp(
    home: Favoritos(),
  ));
}

class Favoritos extends StatelessWidget {
  const Favoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 20),
          Icon(Icons.calendar_month_outlined),
          SizedBox(width: 20),
          Icon(Icons.filter_alt_outlined),
        ],
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFavoritos(globals.idUtilizador),
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
              child: Text('Nenhum favorito encontrado'),
            );
          } else {
            final List<Map<String, dynamic>> favoritos = snapshot.data!;
            return ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final favorito = favoritos[index]['conteudo'];
                var rating = favorito['mediaAvaliacoesGerais'] ?? 0;
                var priceRating = favorito['mediaAvaliacoesPreco'] ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      globals.idPublicacao = favorito['ID_CONTEUDO'];
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
                              'https://pintbackend-w8pt.onrender.com/images/${favorito['IMAGEMCONTEUDO'] ?? ''}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              favorito['NOMECONTEUDO'] ?? 'Sem nome',
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
                                  '(${favorito['totalAvaliacoes'] ?? 0})',
                                  style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                ),
                                const SizedBox(width: 5),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < rating ? Icons.star : Icons.star_border,
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
                              children: List.generate(3, (index) {
                                return Icon(
                                  Icons.euro,
                                  color: index < priceRating
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
                                    favorito['MORADA'] ?? 'Sem localização',
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
                                  favorito['TELEFONE'] ?? 'Sem telefone',
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
    );
  }
}
