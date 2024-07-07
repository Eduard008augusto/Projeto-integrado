// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_shares/database/server.dart';
import './database/var.dart' as globals;

void main() {
  runApp(Addconteudo());
}

class Addconteudo extends StatelessWidget {
  Addconteudo({super.key});

  File? image;
  DateTime? selectedDate;

  TextEditingController nomeController = TextEditingController();
  TextEditingController localController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();
  TextEditingController contactoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Placeholder para carregar a fotografia
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 110.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        image = File(pickedFile.path);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_upload, size: 50, color: Colors.blueAccent),
                        const SizedBox(height: 8),
                        const Text('Drag and Drop files to upload or', style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              image = File(pickedFile.path);
                            }
                          },
                          child: const Text('Browse'),
                        ),
                        const SizedBox(height: 8),
                        const Text('Supported files: PNG, JPG', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 75),

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

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Localização'),
                      TextField(
                        controller: localController,
                        decoration: const InputDecoration(
                          hintText: 'Localização',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Contacto'),
                      TextField(
                        controller: contactoController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Contacto',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Website'),
                      TextField(
                        controller: localController,
                        decoration: const InputDecoration(
                          hintText: 'Website',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
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
                    globals.nome = nomeController.text;
                    globals.nome = localController.text;
                    /*globals.password = passController.text;*/

                    await uploadImage(image!);

                    await registo(
                      globals.idCentro,
                      globals.nome,
                      globals.email,
                      globals.password,
                      globals.imagem,
                      globals.data,
                    );

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
                child: const Text('Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
