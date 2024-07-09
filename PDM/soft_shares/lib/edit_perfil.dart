import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import './database/server.dart';
import './database/var.dart' as globals;
import 'image_picker_page.dart'; // Import the new ImagePickerPage

void main() {
  runApp(const EditarPerfil());
}

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController moradaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController senhaAtualController = TextEditingController();
  TextEditingController novaSenhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();
  String? imagemPerfil;
  File? _selectedImage;

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
            descricaoController.text = user['DESCRICAO'];
            moradaController.text = user['MORADA'] ?? '';
            telefoneController.text = user['TELEFONE']?.toString() ?? '';
            dataNascimentoController.text = user['DATANASCIMENTO'] != null
                ? DateFormat('dd-MM-yyyy').format(DateTime.parse(user['DATANASCIMENTO']))
                : '';
            imagemPerfil = imagemPerfil ?? user['IMAGEMPERFIL'];

            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: _selectedImage == null
                                  ? NetworkImage('https://pintbackend-w8pt.onrender.com/images/$imagemPerfil')
                                  : FileImage(_selectedImage!) as ImageProvider,
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ImagePickerPage(
                                          onImagePicked: (File? image) {
                                            setState(() {
                                              _selectedImage = image;
                                              if (image != null) {
                                                imagemPerfil = image.path;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30.0),
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
                    const Text('Descrição', style: TextStyle(fontSize: 16)),
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
                    const Text('Data de Nascimento', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: dataNascimentoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dataNascimentoController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                    ),
                    const Divider(
                      height: 70,
                      thickness: 1,
                      color: Color.fromARGB(255, 41, 40, 40),
                    ),
                    const Text('Senha Atual', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: senhaAtualController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Nova Senha', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: novaSenhaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Confirmar Nova Senha', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: confirmarSenhaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != novaSenhaController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
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
              onPressed: () {
                // Adicione a lógica para salvar as mudanças aqui
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
