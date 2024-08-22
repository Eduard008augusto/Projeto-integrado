// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:soft_shares/add_comentario_conteudo.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import './database/var.dart' as globals;
import 'package:intl/intl.dart';
import 'like_bttn.dart';

import 'up_picevento.dart';

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
                    Column(
                       children: [
                         Expanded(
                           child: FutureBuilder<List<Map<String, dynamic>>>(
                             future: getComentarioEvento(globals.idEvento),
                             builder: (context, snapshot) {
                             if(snapshot.connectionState == ConnectionState.waiting){
                               return Center(child: CircularProgressIndicator(),);
                             } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                                                             TextEditingController comentarioController = TextEditingController();

                             return Stack(
                               children: [
                                 const Center(
                                   child: Text('Nenhum comentário encontrado!', overflow: TextOverflow.ellipsis, maxLines: 2),
                                 ),
                                 Positioned(
                                   bottom: 0,
                                   left: 10,
                                   right: 10,
                                   child: Container(
                                     color: Color.fromARGB(255, 254, 247, 255),
                                     width: double.infinity,
                                     padding: EdgeInsets.all(10.0),
                                     child: Row(
                                       children: [
                                         Expanded(
                                           child: TextFormField(
                                             decoration: InputDecoration(
                                               hintText: 'Adicione um comentário...',
                                               border: UnderlineInputBorder(
                                                 borderSide: BorderSide(color: Colors.grey),
                                               ),
                                             ),
                                           ),
                                         ),
                                        IconButton(
                                           icon: Icon(Icons.send),
                                           onPressed: () async {
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
                                                         const SizedBox(height: 16),
                                                         TextField(
                                                           controller: TextEditingController(),
                                                           keyboardType: TextInputType.text,
                                                           decoration: const InputDecoration(
                                                             hintText: 'Adicione um comentário...',
                                                             border: OutlineInputBorder(),
                                                           ),
                                                         ),
                                                         const SizedBox(height: 16),
                                                         ElevatedButton(
                                                           onPressed: () async {
                                                             await createComentarioEvento(
                                                               globals.idCentro,
                                                               globals.idEvento,
                                                               globals.idUtilizador,
                                                               comentarioController.text,
                                                             );
                                                             Navigator.of(context).pop();
                                                             Navigator.pushNamed(context, '/evento');
                                                           },
                                                           child: const Text('Confirmar'),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 );
                                               },
                                             );
                                           },
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ],
                             );
                             } else if(snapshot.hasError){
                               return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
                             } else {
                               final List<Map<String, dynamic>> comentarios = snapshot.data!;
                               TextEditingController comentarioController = TextEditingController();

                               return Stack(
                                 children: [
                                   SingleChildScrollView(
                                     child: Padding(
                                       padding: const EdgeInsets.all(16.0),
                                       child: Column(
                                         children: [
                                           Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: comentarios.map((comentario) {
                                               return FutureBuilder<Map<String, dynamic>>(
                                                 future: fetchUtilizador(comentario['ID_UTILIZADOR']),
                                                 builder: (context, snapshot) {
                                                   if (snapshot.connectionState == ConnectionState.waiting) {
                                                     return CircularProgressIndicator(); 
                                                   } else if (snapshot.hasError) {
                                                     return Text('Erro ao carregar dados do user'); 
                                                   } else if (!snapshot.hasData) {
                                                     return Text('Nenhum dado encontrado para este user'); 
                                                   } else {
                                                     final Map<String, dynamic> user = snapshot.data!; 
                                                     return Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Row(
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           children: [
                                                             Padding(
                                                               padding: const EdgeInsets.only(top: 10.0), 
                                                               child: CircleAvatar(
                                                                 radius: 18,
                                                                 backgroundImage: NetworkImage(
                                                                   user['IMAGEMPERFIL'] == null 
                                                                     ? 'https://cdn.discordapp.com/attachments/1154170394400542730/1260333904976679064/01.png?ex=668ef0ea&is=668d9f6a&hm=b909016ee5266e728eb2421b043a637a5d32156b3f0f4e9c59c4575af5208667&' 
                                                                     : 'https://pintbackend-w8pt.onrender.com/images/${user['IMAGEMPERFIL']}'),
                                                               ),
                                                             ),
                                                             SizedBox(width: 10),
                                                             Expanded(
                                                               child: Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   Row(
                                                                     children: [
                                                                       Text('${user['NOME']}',
                                                                         style: TextStyle(
                                                                           fontSize: 14.0, 
                                                                           color: Colors.black.withOpacity(0.6), 
                                                                         ),
                                                                       ),
                                                                       Spacer(),
                                                                       // botao de denuncia "...""
                                                                       IconButton(
                                                                         icon: Icon(Icons.more_vert, size: 16.0),
                                                                         padding: EdgeInsets.all(0),
                                                                         constraints: BoxConstraints(), 
                                                                         onPressed:(){
                                                                           showDialog(
                                                                             context: context,
                                                                             builder: (BuildContext context) {
                                                                               return AlertDialog(
                                                                                 //title: Text('Denunciar comentário'),
                                                                                 content: Text('Deseja denunciar este comentário?'),
                                                                                 actions: [
                                                                                   TextButton.icon(
                                                                                     onPressed: () {
                                                                                       Navigator.of(context).pop();
                                                                                     },
                                                                                     icon: const Icon(Icons.cancel_outlined, color: Color.fromARGB(255, 57, 99, 156)),
                                                                                     label: Text(
                                                                                       'Cancelar',
                                                                                         style: TextStyle(
                                                                                         color:Color.fromARGB(255, 57, 99, 156)
                                                                                       ),
                                                                                     ),
                                                                                   ),
                                                                                   TextButton.icon(
                                                                                     onPressed: () async {
                                                                                       try {
                                                                                         await denunciarComentarioEvento(globals.idEvento);
                                                                                         Navigator.of(context).pop();

                                                                                         // NÃO TÁ A APARECER ESTA MENSAGEM
                                                                                         showDialog(
                                                                                           context: context,
                                                                                           builder: (BuildContext context) {
                                                                                             return AlertDialog(
                                                                                               shape: RoundedRectangleBorder(
                                                                                                 borderRadius: BorderRadius.circular(10),
                                                                                               ),
                                                                                               content: Padding(
                                                                                                 padding: const EdgeInsets.all(16.0),
                                                                                                 child: Column(
                                                                                                   mainAxisSize: MainAxisSize.min,
                                                                                                   children: const [
                                                                                                     SizedBox(height: 16),
                                                                                                     Text('Obrigado!\nComentário denunciado com sucesso!'),
                                                                                                   ],
                                                                                                 ),
                                                                                               ),
                                                                                             );
                                                                                           },
                                                                                         );
                                                                                       } catch (error) {
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
                                                                                                     SizedBox(height: 16),
                                                                                                     Text('Erro ao denunciar comentário!\n$error'),
                                                                                                   ],
                                                                                                 ),
                                                                                               ),
                                                                                             );
                                                                                           },
                                                                                         );
                                                                                       }
                                                                                       
                                                                                       Navigator.of(context).pop();
                                                                                     },
                                                                                     icon: Icon(Icons.report_outlined, color: Color.fromARGB(255, 57, 99, 156)),
                                                                                     label: Text(
                                                                                       'Denunciar',
                                                                                       style: TextStyle(
                                                                                         color:Color.fromARGB(255, 57, 99, 156), 
                                                                                       ),
                                                                                     ),
                                                                                   ),
                                                                                 ],
                                                                               );
                                                                             }
                                                                           );
                                                                         },
                                                                       ),
                                                                     ],
                                                                   ),
                                                                   //corpo do comentario
                                                                   //SizedBox(height: 4),
                                                                   Text('${comentario['COMENTARIO']}'),
                                                                   //SizedBox(height: 4),
                                                                   Row(
                                                                     children: [
                                                                       LikeButton(),
                                                                       Text('${comentario['totalLikes']}'),
                                                                     ],
                                                                   ),
                                                                 ],
                                                               ),
                                                             )
                                                           ],
                                                         ),
                                                         SizedBox(height: 20),  // entre coment
                                                       ],
                                                     );                                   
                                                   } 
                                                 } 
                                               );
                                             }).toList(),
                                           ),
                                           SizedBox(height: 50), // no fim
                                         ],
                                       ),
                                     )
                                   ),
                                   
                                   Positioned(
                                     bottom: 0,
                                     left: 10,
                                     right: 10,
                                     child: Container( 
                                       color: Color.fromARGB(255, 254, 247, 255),
                                       width: double.infinity,  
                                       padding: EdgeInsets.all(10.0),
                                       child: Row(
                                         children: [
                                           Expanded(
                                             child: TextFormField(
                                               controller: comentarioController,
                                               decoration: InputDecoration(
                                                 hintText: 'Adicione um comentário...',
                                                 border: UnderlineInputBorder(
                                                   borderSide: BorderSide(color: Colors.grey),
                                                 ),
                                               ),
                                             ),
                                           ),
                                           IconButton(
                                             icon: Icon(Icons.send),
                                             onPressed: () async {
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
                                                           const SizedBox(height: 16),
                                                           TextField(
                                                             controller: comentarioController,
                                                             keyboardType: TextInputType.text,
                                                             decoration: const InputDecoration(
                                                               hintText: 'Adicione um comentário...',
                                                               border: OutlineInputBorder(),
                                                             ),
                                                           ),
                                                           const SizedBox(height: 16),
                                                           ElevatedButton(
                                                             onPressed: () async {
                                                               await createComentarioEvento(
                                                                 globals.idCentro,
                                                                 globals.idEvento,
                                                                 globals.idUtilizador,
                                                                 comentarioController.text,
                                                               );
                                                               Navigator.of(context).pop();
                                                               Navigator.pushNamed(context, '/evento');
                                                             },
                                                             child: const Text('Confirmar'),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   );
                                                 },
                                               );
                                             }
                                           )
                                         ]
                                       )
                                     )
                                   )
                                 ]
                               );
                             }
                           }
                         )
                       ),
                     ],
                   ),                    
                                Stack(
                                  children: [
                                    SingleChildScrollView(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            buildAlbum(),
                                            const SizedBox(height: 80), 
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      right: 20,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const MultipleImagePickerPage2(),
                                            ),
                                          );
                                        },
                                        backgroundColor: Colors.transparent, 
                                        elevation: 0, 
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                                            shape: BoxShape.circle, 
                                          ),
                                          padding: const EdgeInsets.all(15), // Padding para tornar o botão maior
                                          child: const Icon(Icons.add, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                             ],
                           ),
                         ),
                       ],    
                     ),
                   ),
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
        }
      )
    );
  }
}
 

Widget buildAlbum() {
return FutureBuilder<List<Map<String, dynamic>>>(
  future: getAlbumEvento(globals.idEvento),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('Nenhuma imagem encontrada', overflow: TextOverflow.ellipsis, maxLines: 2));
    } else {
      final List<Map<String, dynamic>> imagens = snapshot.data!;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,
        ),
        itemCount: imagens.length,
        itemBuilder: (context, index) {
          final imagem = imagens[index];
          return FutureBuilder<Map<String, dynamic>>(
            future: fetchUtilizador(imagem['ID_UTILIZADOR']),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userSnapshot.hasError) {
                return const Center(child: Text('Erro ao carregar dados do user'));
              } else if (!userSnapshot.hasData) {
                return const Center(child: Text('Nenhum dado encontrado para este user'));
              } else {
                final user = userSnapshot.data!;
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 9.0), // Padding à esquerda do avatar
                                        child: CircleAvatar(
                                          radius: 17,
                                          backgroundImage: NetworkImage(
                                            user['IMAGEMPERFIL'] == null
                                                ? 'https://cdn.discordapp.com/attachments/1154170394400542730/1260333904976679064/01.png?ex=668ef0ea&is=668d9f6a&hm=b909016ee5266e728eb2421b043a637a5d32156b3f0f4e9c59c4575af5208667&'
                                                : 'https://pintbackend-w8pt.onrender.com/images/${user['IMAGEMPERFIL']}',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8), 
                                      Text(
                                        user['NOME'] ?? 'Nome não disponível',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.5), 
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              Image.network(
                                'https://pintbackend-w8pt.onrender.com/images/${imagem['IMAGEM']}',
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 45.0,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 254, 247, 255),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    'https://pintbackend-w8pt.onrender.com/images/${imagem['IMAGEM']}',
                    fit: BoxFit.cover,
                   ),
                 );
               }
             },
           );
         },
       );
     }
   },
 );
}
