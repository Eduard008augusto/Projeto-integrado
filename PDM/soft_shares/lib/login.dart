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
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 70.0),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 120,
                  height: 120,
                ),
              )
            ),

            const SizedBox(
              height: 100,
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
                      hintText: 'Email ou Usuário',
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

            Container(
              margin: const EdgeInsets.only(right: 16.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    print('HALLO :)');
                  }, child: const Text('Esqueci-me da palavra-passe')),
                ],
              ),
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
                  onTap: () {
                    print('Google CLICK');
                  },
                  child: SvgPicture.asset(
                    'assets/images/google.svg',
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
                    'assets/images/facebook.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}