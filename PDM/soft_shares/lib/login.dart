// ignore_for_file: must_be_immutable, avoid_print
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
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 70.0),
              child: SvgPicture.asset(
                '../assets/images/logo.svg',
                width: 120,
                height: 120,
              ),
            )
          ),

          const SizedBox(
            height: 180,
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
                    labelText: 'Email ou Usuário',
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
                    labelText: 'Palavra-passe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            )
          ),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Esqueci-me da palavra-passe?'),
            ],
          ),

          const Divider(height: 70, thickness: 1, indent: 30, endIndent: 30, color: Color.fromARGB(255, 41, 40, 40),),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print('Google CLICK');
                  },
                  child: SvgPicture.asset(
                    '../assets/images/google.svg',
                    width: 50,
                    height: 50,
                  ),
                ),

                const SizedBox(width: 50,),

                GestureDetector(
                  onTap: () {
                    print('Facebook CLICK');
                  },
                  child: SvgPicture.asset(
                    '../assets/images/facebook.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
        ],
      )
    );
  }
}