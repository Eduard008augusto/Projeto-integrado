// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_shares/drawer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();
  TextEditingController contactoController = TextEditingController();

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
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Classificação'),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showRatingDialog(context);
                                  },
                                  icon: const Icon(Icons.star, color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),),
                                  label: const Text('Classificar'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                  ),
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
                        // Adicione a lógica para adicionar conteúdo aqui
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

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Classificação Geral',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const CustomStarRating(rating: 4),
                const SizedBox(height: 16),
                const Text(
                  'Classificação do Preço',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const CustomEuroRating(rating: 2),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Classificar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomStarRating extends StatelessWidget {
  final double rating;

  const CustomStarRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
      ),
      unratedColor: Colors.grey.withOpacity(0.5),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}

class CustomEuroRating extends StatelessWidget {
  final int rating;

  const CustomEuroRating({required this.rating, super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 3,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.euro,
        color: Colors.black,
      ),
      unratedColor: Colors.black.withOpacity(0.3),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
