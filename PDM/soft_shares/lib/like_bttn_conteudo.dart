// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import './database/server.dart';
import './database/var.dart' as globals;

class LikeButtonConteudo extends StatefulWidget {
  final comentario;

  const LikeButtonConteudo({super.key, required this.comentario});

  @override
  _LikeButtonConteudoState createState() => _LikeButtonConteudoState();
}

class _LikeButtonConteudoState extends State<LikeButtonConteudo> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    check();
  }

  int? idLike;

  void check() async {
    Map<String, dynamic> res = await isLikedConteudo(globals.idUtilizador, widget.comentario);
    idLike = res['ID_LIKE'];
    setState(() {
      _isLiked = res['Avaliou'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            size: 16.0,
            color: const Color.fromARGB(255, 57, 99, 156),
          ),
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(), 
          onPressed: () async {
            try {
              if (_isLiked) {
                await deleteLikeConteudo(idLike);
                setState(() {
                  _isLiked = false;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context, 
                    '/conteudo', 
                    arguments: {'tabIndex': 1}, 
                  );                        
                });
              } else {
                await createLikeConteudo(widget.comentario, globals.idUtilizador);
                setState(() {
                  _isLiked = true;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                    context, 
                    '/conteudo', 
                    arguments: {'tabIndex': 1}, 
                  );  
                });
              }
            } catch (error) {
              print('Erro ao adicionar like: $error');
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
                          Text('Erro ao adicionar like: $error'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
