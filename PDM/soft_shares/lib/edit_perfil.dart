// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import './database/server.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const EditarPerfil());
}

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {

  File? image;
  DateTime? selectedDateTime;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController moradaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _showConfirmationDialog(context);
              }
            },
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUtilizador(globals.idUtilizador),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ID DE UTILIZADOR INVÁLIDO'));
          } else {
            final Map<String, dynamic> user = snapshot.data!;
            nomeController.text = user['NOME'];
            descricaoController.text = user['DESCRICAO'] ?? 'Descrição';
            moradaController.text = user['MORADA'] ?? 'Morada';
            telefoneController.text = user['TELEFONE']?.toString() ?? '0';
            dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(user['DATANASCIMENTO'] ?? '1970-01-01T00:00:00.000Z'));
            
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                            onTap: () {
                              _pickImage();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_upload_outlined, size: 50, color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                                  ),
                                  child: const Text('Escolher Imagem'),
                                ),
                                const SizedBox(height: 8),
                                if (image != null)
                                  Image.file(image!),
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
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nome', style: TextStyle(fontSize: 16)),
                              TextFormField(
                                controller: nomeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Sobre si', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: descricaoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Morada', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: moradaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Telefone', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: telefoneController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Data de Nascimento'),
                          TextFormField(
                            controller: dataNascimentoController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: 'Data de Nascimento',
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(user['DATANASCIMENTO'] ?? '1970-01-01T00:00:00.000Z'),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2101),
                              );
                    
                              if (pickedDate != null) {
                                selectedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                );

                                dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(selectedDateTime!);
                                globals.dataNascimento = selectedDateTime!;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 70,
                      thickness: 1,
                      color: Color.fromARGB(255, 41, 40, 40),
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
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text('Salvar'),
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
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Deseja salvar as alterações do perfil?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () async {
                
                globals.nome = nomeController.text;
                globals.descricaoU = descricaoController.text;
                globals.moradaU = moradaController.text;
                globals.telefoneU = int.tryParse(telefoneController.text) ?? 0;

                if (image != null) {
                  await uploadImage(image!);
                }
                
                await updateUser(
                  globals.idUtilizador,
                  globals.nome,
                  globals.descricaoU,
                  globals.moradaU,
                  globals.dataNascimento,
                  globals.telefoneU,
                  globals.imagem
                );

                globals.imagem = '';

                Navigator.pushReplacementNamed(context, '/perfil');
              },
            ),
          ],
        );
      },
    );
  }
}
