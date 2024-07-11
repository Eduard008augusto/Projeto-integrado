// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_shares/database/server.dart';

import './database/var.dart' as globals;

void main() {
  runApp(Registar());
}

class Registar extends StatelessWidget {
  Registar({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 110.0),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 120,
                  height: 120,
                ),
              ),
            ),

            const SizedBox(
              height: 75,
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nome'),
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                        hintText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email'),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Palavra-passe'),
                  TextField(
                    controller: passController,
                    decoration: const InputDecoration(
                      hintText: 'Palavra-passe',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Confirmar Palavra-passe'),
                  TextField(
                    controller: confPassController,
                    decoration: const InputDecoration(
                      hintText: 'Confirmar Palavra-passe',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20.0,),

            OutlinedButton(
              onPressed: () async {
                try{
                  if(emailController.text.isEmpty || userController.text.isEmpty || passController.text.isEmpty || confPassController.text.isEmpty){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: const Icon(Icons.warning),
                          title: const Text('ERRO'),
                          content: const Text('Preencha todos os campos!'),
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
                    return;
                  }

                  if(passController.text == confPassController.text){
                    globals.email = emailController.text;
                    globals.nome = userController.text;
                    globals.password = passController.text;

                    await registo(globals.idCentroUSER, globals.nome, globals.email, globals.password);

                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: const Icon(Icons.warning),
                          title: const Text('ERRO'),
                          content: const Text('As palavras-passes devem coincidir!'),
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
                    return;
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        icon: const Icon(Icons.warning),
                        title: const Text('ERRO'),
                        content: Text('ERROR: ${e.toString()}'),
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
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 153),
                backgroundColor: const Color.fromARGB(255, 0, 184, 224),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),  
                ),
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 1,
                )
              ),
              child: const Text('Registar'),
            ),
          ],
        ),
      );
  }
}
