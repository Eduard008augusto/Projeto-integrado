// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api, sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_shares/drawer.dart';
import './database/server.dart';
import './database/var.dart' as globals;
import 'image_picker_page.dart';

class EditEvento extends StatefulWidget {
  const EditEvento({super.key});

  @override
  EditEventoState createState() => EditEventoState();
}

class EditEventoState extends State<EditEvento> {
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
          title: const Text('Editar Evento'),
        ),
        drawer: const MenuDrawer(),
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchEvento(globals.idEventoEdit),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Evento não encontrado!', overflow: TextOverflow.ellipsis, maxLines: 2));
            } else {
              final Map<String, dynamic> evento = snapshot.data!;

              nomeController.text = evento['NOME'] ?? 'NOME';
              localizacaoController.text = evento['LOCALIZACAO'] ?? 'LOCALIZACAO';
              telefoneController.text = evento['TELEFONE'].toString();
              descricaoController.text = evento['DESCRICAO'] ?? 'DESCRICAO';
              dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(evento['DATA']));
              precoController.text = evento['PRECO'] ?? 'PRECO';

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
                                    const Text('Área e Subárea *'),
                                    Container(
                                      width: double.infinity,
                                      child: DropdownListView(area: evento['ID_AREA'], subarea: evento['ID_SUBAREA'],),
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
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        hintText: 'Data e Hora do Evento',
                                        border: OutlineInputBorder(),
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.parse(evento['DATA']),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2101),
                                        );

                                        if (pickedDate != null) {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (pickedTime != null) {
                                              selectedDateTime = DateTime(
                                                pickedDate.year,
                                                pickedDate.month,
                                                pickedDate.day,
                                                pickedTime.hour,
                                                pickedTime.minute,
                                              );
                                              dataHoraController.text = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime!);
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
        )
      );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Deseja editar este evento?'),
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
                globals.nomeEvento = nomeController.text;
                globals.localizacaoEvento = localizacaoController.text;
                globals.telefoneEvento = int.tryParse(telefoneController.text) ?? 0;
                globals.descricaoEvento = descricaoController.text;
                globals.dataEvento = selectedDateTime ?? DateTime.now();
                globals.precoEvento = double.tryParse(precoController.text) ?? 0.0;

                try {
                  if (image != null) {
                    await uploadImage(image!);
                    await updateEvento(
                      globals.idEventoEdit,
                      globals.idAreaDropDown,
                      globals.idSubAreaDropDown,
                      globals.nomeEvento,
                      globals.dataEvento,
                      globals.localizacaoEvento,
                      globals.imagem,
                      globals.telefoneEvento,
                      globals.descricaoEvento,
                      globals.precoEvento,
                    );

                    if (mounted) {
                      Navigator.pushNamed(context, '/pendente');
                    }
                  } else {
                    await updateEvento(
                      globals.idEventoEdit,
                      globals.idAreaDropDown,
                      globals.idSubAreaDropDown,
                      globals.nomeEvento,
                      globals.dataEvento,
                      globals.localizacaoEvento,
                      null,
                      globals.telefoneEvento,
                      globals.descricaoEvento,
                      globals.precoEvento,
                    );

                    if (mounted) {
                      Navigator.pushNamed(context, '/pendente');
                    }
                  }

                  globals.imagem = '';
                } catch (e) {
                  print('Erro ao editar evento: $e');
                  if (mounted) {
                    print('Erro ao editar evento: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao editar evento: $e'),
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
