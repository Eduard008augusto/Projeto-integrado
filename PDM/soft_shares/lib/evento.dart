// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:soft_shares/add_comentario_conteudo.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import './database/var.dart' as globals;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MaterialApp(
    home: Evento(),
  ));
}

class Evento extends StatelessWidget {
  const Evento({super.key});

  Future<void> _launchGoogleMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    await launchUrl(googleMapsUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalhes do Evento',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushNamed(context, '/calendario');
          }, icon: const Icon(Icons.calendar_month_outlined),),
          const SizedBox(width: 20),
        ],
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchEvento(globals.idEvento),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum evento encontrado', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else {
            final Map<String, dynamic> evento = snapshot.data!;
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
                                child: evento['IMAGEMEVENTO'] != null
                                    ? Image.network(
                                        'https://pintbackend-w8pt.onrender.com/images/${evento['IMAGEMEVENTO']}',
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
                            Text(
                              evento['NOME'] ?? 'Nome não disponível',
                              style: const TextStyle(fontSize: 20.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              evento['DESCRICAO'] ?? 'Descrição não disponível',
                              style: const TextStyle(fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: DefaultTabController(
                                initialIndex: 0,
                                length: 3,
                                child: Column(
                                  children: [
                                    const TabBar(
                                      labelColor: Color.fromARGB(255, 57, 99, 156),
                                      unselectedLabelColor: Colors.grey,
                                      indicatorColor: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                      tabs: [
                                        Tab(icon: Icon(Icons.info_outline),),
                                        Tab(icon: Icon(Icons.chat_outlined),),
                                        Tab(icon: Icon(Icons.photo_library_outlined),),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 350,
                                      child: TabBarView(
                                        children: [
                                          Center(child:
                                            Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    evento['LOCALIZACAO'] ?? 'Localização não disponível',
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
                                    evento['DATA'] != null
                                        ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(evento['DATA']))
                                        : 'Data e hora não disponíveis',
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
                                    evento['TELEFONE'].toString(),
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
                                const Icon(Icons.euro, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    evento['PRECO'] != null
                                        ? '${evento['PRECO'].toString()}€'
                                        : 'Preço não disponível',
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
                                const Icon(Icons.groups, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    evento['totalInscritos'] != null ?
                                    '${evento['totalInscritos'].toString()} pessoas inscritas'
                                    : 'Total de inscrições',
                                    style: const TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                         ],
                       ),
                     ),
                    const Column(
                           children: [
                             Text('Comentarios'),
                      ],

                    ),  
                    const Column(
                           children: [
                             Text('ALBUM'),
                      ],
                    ), 

                  ],
                 ),
               )
             ],
           ),
         ),
       ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _launchGoogleMaps(evento['LOCALIZACAO']);
                          },
                          icon: const Icon(Icons.directions, color: Colors.white),
                          label: const Text('Direções'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            var data = await checkInscricao(globals.idUtilizador, evento['ID_EVENTO']);
                            bool inscrito = data['isInscrito'];
                            if (inscrito) {
                              await deleteInscricao(data['ID_INSCRICAO']);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    icon: const Icon(Icons.check),
                                    title: const Text('Sucesso'),
                                    content: const Text('Sua inscrição foi anulada!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              await createInscricao(evento['ID_EVENTO'], globals.idUtilizador);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    icon: const Icon(Icons.check),
                                    title: const Text('Sucesso'),
                                    content: const Text('Você está inscrito!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          icon: const Icon(Icons.how_to_reg, color: Colors.white),
                          label: const Text('Inscrever'),
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
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final query = Uri.encodeComponent(evento['LOCALIZACAO']);
                        final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                        Share.shareUri(googleMapsUrl);
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text('Partilhar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                        foregroundColor: Colors.white, 
                      ),
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
