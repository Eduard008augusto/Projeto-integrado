// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, sized_box_for_whitespace, duplicate_ignore

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_shares/drawer.dart';

import './database/server.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const EditConteudo());
}


class EditConteudo extends StatefulWidget {
  const EditConteudo({super.key});

  @override
  _EditConteudoState createState() => _EditConteudoState();
}

class _EditConteudoState extends State<EditConteudo> {
  File? image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  int area = 0;
  int subarea = 0;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController moradaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController acessibilidadeController = TextEditingController();
  TextEditingController horarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Conteudo'),
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPublicacao(globals.idConteudoEdit),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('Publicação não encontrada'),);
          } else {
            final Map<String, dynamic> publicacao = snapshot.data!;
            nomeController.text = publicacao['NOMECONTEUDO'] ?? 'NOME';
            moradaController.text = publicacao['MORADA'] ?? 'MORADA';
            horarioController.text = publicacao['HORARIO'] ?? 'HORARIO';
            telefoneController.text = publicacao['TELEFONE'] ?? 'TELEFONE';
            websiteController.text = publicacao['WEBSITE'] ?? 'WEBSITE';
            acessibilidadeController.text = publicacao['ACESSIBILIDADE'] ?? 'ACESSIBILIDADE';
            return Column(
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
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Área e Subárea *'),
                                  Container(
                                    width: double.infinity,
                                    child: DropdownListView(area: publicacao['ID_AREA'], subarea: publicacao['ID_SUBAREA'],),
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
                                    controller: moradaController,
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
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text('Editar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          content: const Text('Deseja editar este conteúdo?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                globals.nomeP = nomeController.text;
                globals.moradaP = moradaController.text;
                globals.websiteP = websiteController.text.isNotEmpty ? websiteController.text : '';
                globals.acessibilidadeP = acessibilidadeController.text.isNotEmpty ? acessibilidadeController.text : '';
                globals.horarioP = horarioController.text.isNotEmpty ? horarioController.text : '';
                globals.telefoneP = int.tryParse(telefoneController.text) ?? 0;

                try {
                  if (image != null) {
                    await uploadImage(image!);
                  } else {
                    globals.imagem = '';
                  }

                  await updateConteudo(
                    globals.idConteudoEdit,
                    globals.idAreaDropDown,
                    globals.idSubAreaDropDown,
                    globals.nomeP,
                    globals.moradaP,
                    globals.horarioP,
                    globals.telefoneP,
                    globals.imagem,
                    globals.websiteP,
                    globals.acessibilidadeP,
                  );

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/pendente');
                  }

                  globals.imagem = '';
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao editar conteúdo: $e'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class DropdownListView extends StatefulWidget {
  final int? area;
  final int? subarea;

  const DropdownListView({super.key, this.area, this.subarea});

  @override
  _DropdownListViewState createState() => _DropdownListViewState();
}

class _DropdownListViewState extends State<DropdownListView> {
  String? selectedArea;
  List<Map<String, dynamic>> areas = [];

  String? selectedSubArea;
  List<Map<String, dynamic>> subAreas = [];

  @override
  void initState() {
    super.initState();



    fetchAndSetAreas();
    fetchAndSetSubAreas();
  }

  void fetchAndSetAreas() async {
    final fetchedAreas = await fetchAreas();
    var data = await getArea(widget.area);
    setState(() {
      areas = fetchedAreas;
      selectedArea = data['NOME'];
      globals.idAreaDropDown = data['ID_AREA'];
    });
  }

  void fetchAndSetSubAreas() async {
    final fetchedSubAreas = await fetchSubAreas(widget.area);
    var data = await getSubArea(widget.subarea);
    setState(() {
      subAreas = fetchedSubAreas;
      selectedSubArea = data['NOME'];
      globals.idSubAreaDropDown = data['ID_SUBAREA'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchAreas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma área encontrada'));
            } else {
              final items = snapshot.data!;
              return DropdownButtonFormField<String>(
                value: selectedArea,
                hint: const Text('Selecione uma área'),
                isExpanded: true,
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['NOME'],
                    child: Row(
                      children: [
                        Text(item['NOME']),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArea = value;
                    globals.idAreaDropDown = items.firstWhere((item) => item['NOME'] == value)['ID_AREA'];
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma área';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            }
          },
        ),

        const SizedBox(height: 10,),

        FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchSubAreas(globals.idAreaDropDown),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma subárea encontrada'));
            } else {
              final items = snapshot.data!;
              try {
                return DropdownButtonFormField<String>(
                  value: selectedSubArea,
                  hint: const Text('Selecione uma Subárea'),
                  isExpanded: true,
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      onTap: (){
                        globals.idSubAreaDropDown = item['ID_SUBAREA'];
                      },
                      value: item['NOME'],
                      child: Row(
                        children: [
                          Image.network(
                            'https://pintbackend-w8pt.onrender.com/images/${item['IMAGEMSUBAREA']}',
                            height: 35.0,
                            width: 35.0,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image, size: 35.0);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(item['NOME']),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubArea = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma subárea';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              } catch (e) {
                return DropdownButtonFormField<String>(
                  value: null,
                  hint: const Text('Selecione uma Subárea'),
                  isExpanded: true,
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      onTap: (){
                        globals.idSubAreaDropDown = item['ID_SUBAREA'];
                      },
                      value: item['NOME'],
                      child: Row(
                        children: [
                          Image.network(
                            'https://pintbackend-w8pt.onrender.com/images/${item['IMAGEMSUBAREA']}',
                            height: 35.0,
                            width: 35.0,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image, size: 35.0);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(item['NOME']),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubArea = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma subárea';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
