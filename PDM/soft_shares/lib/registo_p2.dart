// ignore_for_file: must_be_immutable, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './database/var.dart' as globals;
import './database/server.dart';

void main() {
  runApp(RegistarP2());
}

class RegistarP2 extends StatelessWidget {
  RegistarP2({super.key});

  TextEditingController moradaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imagemController = TextEditingController();

  File? image;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
        image = File(pickedFile.path);
    }
  }

  DateTime? selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale("pt", "PT"),  // Configura a localização para Português (Portugal)
    );
    
    if(picked != null) {
      selectedDate = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
          

            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Center(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Morada'),
                  TextField(
                    controller: moradaController,
                    decoration: const InputDecoration(
                      hintText: 'Morada',
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
                  const Text('Telefone'),
                  TextField(
                    controller: telefoneController,
                    decoration: const InputDecoration(
                      hintText: 'Telefone',
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
                  const Text('Descrição'),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      hintText: 'Breve descrição sobre si',
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
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.camera),
                    child: const Text('Capture Image with Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: const Text('Select Image from Gallery'),
                  ),

                  ElevatedButton(onPressed: () => selectedDate, child: const Text('Data de Nascimento'))
                ],
              )
            ),

            const SizedBox(height: 30,),

            OutlinedButton(onPressed: (){
              globals.morada = moradaController.text;
              globals.telefone = int.parse(telefoneController.text);
              globals.desc = descController.text;
              globals.imagemperfil = image;
              globals.dataNascimento = selectedDate;

              registo(globals.idCentro, globals.nome, globals.desc, globals.morada, globals.dataNascimento, globals.telefone, globals.email, globals.password, globals.imagemperfil);

              Navigator.pushNamed(context, '/areas');
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
            child: const Text('Registar')),
          ],
        ),
      ),
    );
  }
}