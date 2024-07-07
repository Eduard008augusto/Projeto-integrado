// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_shares/database/server.dart';

import './database/var.dart' as globals;

void main() {
  runApp(Registar());
}

class Registar extends StatelessWidget {
  Registar({super.key});

  File? image;
  DateTime? selectedDate;

  TextEditingController nomeController = TextEditingController();
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
                      controller: nomeController,
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
                    const Text('Telefone'), // Alteração aqui para 'Telefone'
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                        hintText: 'Telefone',
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

            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  image = File(pickedFile.path);
                }
              },
              child: const Text('Escolher Imagem'),
            ),

            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  locale: const Locale('pt', 'PT'),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  selectedDate = pickedDate;
                }

                globals.data = selectedDate!;
              },
              child: const Text('Escolher Data de Nascimento'),
            ),

            OutlinedButton(
              onPressed: () async {
                if (passController.text == confPassController.text) {
                  //globals.email = emailController.text;
                  globals.nome = userController.text;
                  globals.password = passController.text;

                  await uploadImage(image!);

                  await registo(globals.idCentro, globals.nome, globals.email,
                      globals.password, globals.imagem, globals.data);

                  Navigator.pushNamed(context, '/areas');
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
                ),
              ),
              child: const Text('Registar'),
            ),
          ],
        ),
      ),
    );
  }
}
