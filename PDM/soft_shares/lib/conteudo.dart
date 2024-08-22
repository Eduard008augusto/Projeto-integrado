// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:path/path.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import './database/var.dart' as globals;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'like_bttn.dart';
//import 'package:comment_box/comment/comment.dart';

import 'up_picconteudo.dart';

bool isFavorite = false;
bool isLiked = false;
bool avaliado = false;

int estrela = 0;
int preco = 0;

int estrelaBD = 0;
int precoBD = 0;

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
                  'Classificação Geral',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                CustomStarRating(rating: estrelaBD),
                const SizedBox(height: 16),
                const Text(
                  'Classificação do Preço',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomEuroRating(rating: precoBD),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (avaliado) {
                      await updateAvaliacao(globals.idAvaliacao, globals.idPublicacao, globals.idUtilizador, estrelaBD, precoBD);
                    } else {
                      await createAvaliacao(globals.idPublicacao, globals.idUtilizador, estrelaBD, precoBD);
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
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    await launchUrl(googleMapsUrl);
  }

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
          globals.nomArea,
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
            String  morada = publicacao['MORADA'] ?? ' não disponível';
            String  horario = publicacao['HORARIO'] ?? ' não disponível';
            String  telefone = publicacao['TELEFONE'] ?? ' não disponível';
            String  website = publicacao['WEBSITE'] ?? ' não disponível';
            String  acessibilidade = publicacao['ACESSIBILIDADE'] ?? 'Acessibilidade não disponível';

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
                                child: publicacao['IMAGEMCONTEUDO'] != null ? Image.network(
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
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                child: DefaultTabController(
                                  initialIndex: 0,
                                  length: 3, 
                                  child: Column(
                                    children: [
                                      TabBar(
                                        labelColor: const Color.fromARGB(255, 57, 99, 156),
                                        unselectedLabelColor: Colors.grey,
                                        indicatorColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                        tabs: const [
                                          Tab(icon: Icon(Icons.info_outline),),
                                          Tab(icon: Icon(Icons.chat_outlined),),
                                          Tab(icon: Icon(Icons.photo_library_outlined),),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      SizedBox(
                                        height: 350,
                                        child: TabBarView(
                                          children: [
                                            Center(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [                           
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on_outlined, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                                      SizedBox(width: 3), 
                                                      Expanded(
                                                        child: Text(
                                                          morada,
                                                          style: TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    height: 50,
                                                    thickness: 1,
                                                    indent: 20,
                                                    endIndent: 20,
                                                    color: Color.fromARGB(136, 41, 40, 40),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.access_time, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                                      SizedBox(width: 3), 
                                                      Expanded(
                                                        child: Text(
                                                          horario,
                                                          style: TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    height: 50,
                                                    thickness: 1,
                                                    indent: 20,
                                                    endIndent: 20,
                                                    color: Color.fromARGB(136, 41, 40, 40),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.phone_outlined, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                                      SizedBox(width: 3), 
                                                      Expanded(
                                                        child: Text(
                                                          telefone,
                                                          style: TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    height: 50,
                                                    thickness: 1,
                                                    indent: 20,
                                                    endIndent: 20,
                                                    color: Color.fromARGB(136, 41, 40, 40),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.web, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                                      SizedBox(width: 3), 
                                                      Expanded(
                                                        child: Text(
                                                          website,
                                                          style: TextStyle(color: Color.fromARGB(255, 69, 79, 100)),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    height: 50,
                                                    thickness: 1,
                                                    indent: 20,
                                                    endIndent: 20,
                                                    color: Color.fromARGB(136, 41, 40, 40),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.accessibility, size: 17.0, color: Color.fromARGB(255, 57, 99, 156)),
                                                      SizedBox(width: 3), 
                                                      Expanded(
                                                        child: Text(
                                                          acessibilidade,
                                                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                                                    future: getComentarioConteudo(globals.idPublicacao),
                                                    builder: (context, snapshot) {
                                                    if(snapshot.connectionState == ConnectionState.waiting){
                                                      return Center(child: CircularProgressIndicator(),);
                                                    } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                                                      return const Center(child: Text('Nenhum comentário encontrado!', overflow: TextOverflow.ellipsis, maxLines: 2));
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
                                                                      final comID = comentario['ID_COMENTARIO'];
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
                                                                                                                await denunciarComentarioConteudo(globals.idPublicacao);
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
                                                                                          Text('${comentario['COMENTARIO']}'),
                                                                                          Row(
                                                                                            children: [
                                                                                              
                                                                                              LikeButton(comentario: comID),
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
                                                                                      await createComentarioConteudo(
                                                                                        globals.idCentro,
                                                                                        globals.idPublicacao,
                                                                                        globals.idUtilizador,
                                                                                        comentarioController.text,
                                                                                      );
                                                                                      Navigator.of(context).pop();
                                                                                      Navigator.pushNamed(context, '/conteudo');
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
                                                        builder: (context) => const MultipleImagePickerPage(),
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _launchGoogleMaps(publicacao['MORADA'] ?? 'Morada não disponível');
                              },
                              icon: const Icon(
                                Icons.directions,
                                color: Colors.white,
                                size:20.0, 
                              ),
                              label: const Text(
                                'Direções',
                                style: TextStyle(fontSize: 14.0), 
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // padd interno
                                minimumSize: const Size(95, 43), 
                                backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                                foregroundColor: Colors.white, 
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showRatingDialog(context);
                              },
                              icon: const Icon(
                                Icons.star,
                                color: Colors.white,
                                size:20.0, 
                              ),
                              label: const Text(
                                'Classificar',
                                style: TextStyle(fontSize: 14.0), 
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), //padd interno
                                minimumSize: const Size(95, 43), 
                                backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                                foregroundColor: Colors.white, 
                              ),
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final query = Uri.encodeComponent(publicacao['MORADA']);
                                  final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
                                  Share.shareUri(googleMapsUrl);
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                label: const Text(
                                  'Partilhar',
                                  style: TextStyle(fontSize: 14.0), 
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // padd interno
                                  minimumSize: const Size(95, 43), 
                                  backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0), 
                                  foregroundColor: Colors.white, 
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildAlbum() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: getAlbumConteudo(globals.idPublicacao),
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
                                        SizedBox(width: 8), // Espaçamento entre o avatar e o nome
                                        Text(
                                          user['NOME'] ?? 'Nome não disponível',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black.withOpacity(0.5), // Ajuste a opacidade do texto
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
      if (isFavorite) {
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
          return const Icon(Icons.error);
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
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
            ),
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
