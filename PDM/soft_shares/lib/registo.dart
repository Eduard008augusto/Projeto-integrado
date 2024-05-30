// ignore_for_file: must_be_immutable, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return MaterialApp(
      home: Scaffold(
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
                  const Text('Email'),
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
              child: Center(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nome de Usuário'),
                  TextField(
                    controller: userController,
                    decoration: const InputDecoration(
                      hintText: 'Nome de Usuário',
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
                  ),
                ],
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
                  const Text('Confirmar Palavra-passe'),
                  TextField(
                    controller: confPassController,
                    decoration: const InputDecoration(
                      hintText: 'Confirmar Palavra-passe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              )
            ),

            OutlinedButton(onPressed: (){
              print('Login CLICK');
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
          ],
        ),
      ),
    );
  }
}