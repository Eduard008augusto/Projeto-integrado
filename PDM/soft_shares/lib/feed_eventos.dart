import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const MaterialApp(
    home: FeedEventos(),
  ));
}

class FeedEventos extends StatelessWidget {
  const FeedEventos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/calendario');
            },
          ),
          const SizedBox(width: 20,),
          const Icon(Icons.search),
          const SizedBox(width: 20,),
          const Icon(Icons.filter_alt_outlined),
        ],
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEventos(globals.idCentro),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'),);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum evento encontrado'),);
          } else {
            final List<Map<String, dynamic>> eventos = snapshot.data!;
            return ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                double preco = double.tryParse(evento['PRECO'].toString()) ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      globals.idEvento = evento['ID_EVENTO'];
                      Navigator.pushNamed(context, '/evento_detalhes');
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
                              'https://pintbackend-w8pt.onrender.com/images/${evento['IMAGEMEVENTO']}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              evento['NOME'],
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
                                const Icon(Icons.location_on_outlined, size: 17.0, color: Color.fromARGB(255, 69, 79, 100)),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    evento['LOCALIZACAO'],
                                    style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
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
                                const Icon(Icons.calendar_today_outlined, size: 17.0, color: Color.fromARGB(255, 69, 79, 100)),
                                const SizedBox(width: 3),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime.parse(evento['DATA'])),
                                  style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.euro_outlined, size: 17.0, color: Color.fromARGB(255, 69, 79, 100)),
                                const SizedBox(width: 3),
                                Text(
                                  'Preço: $preco€',
                                  style: const TextStyle(color: Colors.black),
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
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/addevento');
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
