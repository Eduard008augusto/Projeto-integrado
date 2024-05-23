// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              '../assets/images/logo.svg',
              width: 150,
              height: 150,
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email ou Usuário',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              
              child: const Text('Palavra-passe'),
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextField(
                controller: passController,
                decoration: const InputDecoration(
                  labelText: 'Palavra-passe',
                  border: OutlineInputBorder(),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}