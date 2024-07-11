// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_shares/services/auth_service.dart';
import './database/var.dart' as globals;


import 'database/server.dart';
import './services/token_service.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
              )
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
                  const Text('Utilizador'),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ]
              ),
              )
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
              )
            ),

            const SizedBox(height: 20.0,),

            OutlinedButton(onPressed: () async {
              if (emailController.text.isEmpty || passController.text.isEmpty) {
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

              try {
                Map<String, dynamic> data = await login(emailController.text, passController.text);

                print(data);

                if (data['success']) {
                  await TokenManager().storeIdUtilizador(data['id_utilizador']);
                  globals.idUtilizador = await TokenManager().getIdUtilizador();
                  await TokenManager().storeToken(data['token']);
                  await TokenManager().storeNomeUtilizador(data['nome']);
                  globals.nomeUtilizador = await TokenManager().getNomeUtilizador();

                  Navigator.pushReplacementNamed(context, '/mapa');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        icon: const Icon(Icons.warning),
                        title: const Text('ERRO'),
                        content: const Text('Login falhou! Verifique suas credenciais.'),
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
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const Icon(Icons.warning),
                      title: const Text('ERRO'),
                      content: Text(e.toString()),
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
            child: const Text('ENTRAR')),

            const Row(
              children: [
                Expanded(
                  child: Divider(
                    height: 70,
                    thickness: 1,
                    indent: 30,
                    endIndent: 10,
                    color: Color.fromARGB(255, 41, 40, 40),
                  ),
                ),
                Text("OU"),
                Expanded(
                  child: Divider(
                    height: 70,
                    thickness: 1,
                    indent: 10,
                    endIndent: 30,
                    color: Color.fromARGB(255, 41, 40, 40),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      bool success = await AuthService().signInWithGoogle();
                      print(success);
                      if (success) {
                        Navigator.pushReplacementNamed(context, '/mapa');
                      } else {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning),
                            title: const Text('ERRO'),
                            content: const Text('ERRO DURANTE O LOGIN'),
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
                    } catch (e, stackTrace) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning),
                            title: const Text('ERRO'),
                            content: Text('ERROR: ${e.toString()}\n\n${stackTrace.toString()}'),
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
                  child: SvgPicture.asset(
                    'assets/images/google.svg',
                    width: 50,
                    height: 50,
                  ),
                ),

                const SizedBox(width: 50,),

                GestureDetector(
                  onTap: () async {
                    try{
                      bool success = await AuthService().signInWithFacebook();
                      if(success){
                        Navigator.pushReplacementNamed(context, '/mapa');
                      } else {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning),
                            title: const Text('ERRO'),
                            content: const Text('ERRO DURANTE O LOGIN'),
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
                  child: SvgPicture.asset(
                    'assets/images/facebook.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60,),
           
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Não possui uma conta?'),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/registo');
                }, child: const Text('Clique aqui!')),
              ],
            ),
          ],
        ),
      );
  }
}