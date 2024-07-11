// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_shares/drawer.dart';
import 'package:soft_shares/dropdown_subareas.dart';
import './database/server.dart';
import './database/var.dart' as globals;
import 'image_picker_page.dart';

void main() {
  runApp(const AddEvento());
}

class AddEvento extends StatefulWidget {
  const AddEvento({super.key});

  @override
  AddEventoState createState() => AddEventoState();
}

class AddEventoState extends State<AddEvento> {
  File? image;
  DateTime? selectedDateTime;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController localizacaoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataHoraController = TextEditingController();
  TextEditingController precoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo Evento'),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, '/calendario');
            }, icon: const Icon(Icons.calendar_month_outlined),),
            const SizedBox(width: 20),
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
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ImagePickerPage(
                                      onImagePicked: (File? pickedImage) {
                                        setState(() {
                                          image = pickedImage;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.cloud_upload_outlined, size: 50, color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0)),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ImagePickerPage(
                                            onImagePicked: (File? pickedImage) {
                                              setState(() {
                                                image = pickedImage;
                                              });
                                            },
                                          ),
                                        ),
                                      );
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
                                controller: localizacaoController,
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
                              const Text('Data e Hora do Evento *'),
                              TextFormField(
                                controller: dataHoraController,
                                decoration: const InputDecoration(
                                  hintText: 'Data e Hora do Evento',
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickedDate != null) {
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      setState(() {
                                        selectedDateTime = DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute,
                                        );
                                        dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime!);
                                      });
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira a data e hora';
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
                              const Text('Preço *'),
                              TextFormField(
                                controller: precoController,
                                decoration: const InputDecoration(
                                  hintText: 'Preço',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira o preço';
                                  } else if (double.tryParse(value) == null || double.tryParse(value)! < 0) {
                                    return 'Por favor, insira um preço válido';
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
                              TextFormField(
                                controller: telefoneController,
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
                              const Text('Descrição'),
                              TextFormField(
                                controller: descricaoController,
                                decoration: const InputDecoration(
                                  hintText: 'Descrição',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4,
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
                        _showConfirmationDialog();
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
      );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Deseja adicionar este evento?'),
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
                globals.nomeEvento = nomeController.text;
                globals.localizacaoEvento = localizacaoController.text;
                globals.telefoneEvento = int.tryParse(telefoneController.text) ?? 0;
                globals.descricaoEvento = descricaoController.text;
                globals.dataEvento = selectedDateTime ?? DateTime.now();
                globals.precoEvento = double.tryParse(precoController.text) ?? 0.0;

                try {
                  if (image != null) {
                    await uploadImage(image!);
                    await createEvento(
                      globals.idCentro,
                      globals.idArea,
                      globals.idSubArea,
                      globals.idUtilizador,
                      globals.nomeEvento,
                      globals.dataEvento,
                      globals.localizacaoEvento,
                      globals.telefoneEvento,
                      globals.imagem,
                      globals.descricaoEvento,
                      globals.precoEvento,
                    );

                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/feedeventos');
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: const Icon(Icons.warning),
                          title: const Text('ERRO'),
                          content: const Text('Adicione uma imagem!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  print('Erro ao adicionar evento: $e');
                  if (mounted) {
                    print('Erro ao adicionar evento: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao adicionar evento: $e'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
