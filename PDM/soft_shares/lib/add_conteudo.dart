// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_shares/drawer.dart';
import 'dropdown_subareas.dart';

import './database/server.dart';
import './database/var.dart' as globals;

void main() {
  runApp(Addconteudo());
}

class Addconteudo extends StatelessWidget {
  Addconteudo({super.key});

  File? image;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController localController = TextEditingController();
  TextEditingController contactoController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController acessibilidadeController = TextEditingController();
  TextEditingController horarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Novo Conteudo'),
          actions: const [
            Icon(Icons.search),
            SizedBox(width: 20),
            Icon(Icons.calendar_month_outlined),
            SizedBox(width: 20),
            Icon(Icons.filter_alt_outlined),
          ],
        ),
        drawer: const MenuDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
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
                                  const Icon(Icons.cloud_upload_outlined, size: 50, color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0)),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        image = File(pickedFile.path);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                    ),
                                    child: const Text('Escolher Imagem'),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10.0,
                            left: 25.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Subárea *'),
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: double.infinity,
                                child: const DropdownListView(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nome *'),
                              TextFormField(
                                controller: nomeController,
                                decoration: const InputDecoration(
                                  hintText: 'Nome',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira o nome';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Localização *'),
                              TextFormField(
                                controller: localController,
                                decoration: const InputDecoration(
                                  hintText: 'Localização',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira a localização';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Website'),
                              TextField(
                                controller: websiteController,
                                decoration: const InputDecoration(
                                  hintText: 'Website',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Horário'),
                              TextFormField(
                                controller: horarioController,
                                decoration: const InputDecoration(
                                  hintText: 'Horário',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Acessibilidade'),
                              TextFormField(
                                controller: acessibilidadeController,
                                decoration: const InputDecoration(
                                  hintText: 'Acessibilidade',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                    label: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(165, 255, 64, 0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _showConfirmationDialog(context);
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Você deseja adicionar este conteúdo?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {

                globals.nomeP = nomeController.text;
                globals.moradaP = localController.text;
                globals.websiteP = websiteController.text;
                globals.acessibilidadeP = acessibilidadeController.text;
                globals.horarioP = horarioController.text;
                globals.telefoneP = int.tryParse(contactoController.text)!;
                
                try{
                  await uploadImage(image!);

                  await createPublicacao(
                    globals.idCentro,
                    globals.idArea,
                    globals.idSubArea,
                    globals.idUtilizador,
                    globals.nomeP,
                    globals.moradaP,
                    globals.horarioP,
                    globals.telefoneP,
                    globals.imagem,
                    globals.websiteP,
                    globals.acessibilidadeP
                  );

                  Navigator.pushReplacementNamed(context, '/areas');
                } catch (e) {
                  print(e);
                  throw Exception(e);
                }
              },
            ),
          ],
        );
      },
    );
  }

}

