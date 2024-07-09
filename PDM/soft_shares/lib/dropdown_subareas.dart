// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import './database/server.dart';
import './database/var.dart' as globals;

class DropdownListView extends StatefulWidget {
  const DropdownListView({super.key});

  @override
  _DropdownListViewState createState() => _DropdownListViewState();
}

class _DropdownListViewState extends State<DropdownListView> {
  String? selectedSubArea;
  List<Map<String, dynamic>> subAreas = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetSubAreas();
  }

  void fetchAndSetSubAreas() async {
    final fetchedSubAreas = await fetchSubAreas(globals.idArea);
    setState(() {
      subAreas = fetchedSubAreas;
      selectedSubArea = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSubAreas(globals.idArea),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma subárea encontrada'));
        } else {
          final items = snapshot.data!;
          return DropdownButtonFormField<String>(
            value: selectedSubArea,
            hint: const Text('Selecione uma Subárea'),
            isExpanded: true,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                onTap: (){
                  globals.idSubArea = item['ID_SUBAREA'];
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
      },
    );
  }
}
