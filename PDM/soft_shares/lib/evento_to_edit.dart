// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import './database/var.dart' as globals;

class EventoToEdit extends StatelessWidget {
  const EventoToEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchEvento(globals.idEventoEdit),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum evento encontrada', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else {
            final Map<String, dynamic> evento = snapshot.data!;
            if (evento.isEmpty) {
              return const Center(child: Text('Nenhm evento encontrada', overflow: TextOverflow.ellipsis, maxLines: 2));
            }
            
            globals.idSubAreaFAV = evento['ID_SUBAREA'];

            globals.idEventoEdit = evento['ID_EVENTO'];

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
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                evento['NOME'] ?? 'Nome não disponível',
                                style: const TextStyle(fontSize: 20.0),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                (evento['DESCRICAO'] == null || evento['DESCRICAO'] == ' ' || evento['DESCRICAO'] == '') ? 'Descrição não disponível' : evento['DESCRICAO'],
                                style: const TextStyle(fontSize: 16.0),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),
                            const SizedBox(height: 10),
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
          Navigator.pushNamed(context, '/editevento');
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
