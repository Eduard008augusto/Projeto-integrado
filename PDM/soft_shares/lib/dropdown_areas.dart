// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import './database/server.dart';
import './database/var.dart' as globals;

class DropdownListViewArea extends StatefulWidget {
  const DropdownListViewArea({super.key});

  @override
  _DropdownListViewAreaState createState() => _DropdownListViewAreaState();
}

class _DropdownListViewAreaState extends State<DropdownListViewArea> {
  String? selectedArea;
  List<Map<String, dynamic>> areas = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetAreas();
  }

  void fetchAndSetAreas() async {
    final fetchedAreas = await fetchAreas();
    setState(() {
      areas = fetchedAreas;
      selectedArea = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
                onTap: (){
                  globals.idAreaEdit = item['ID_AREA'];
                  print(globals.idAreaEdit);
                },
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
    );
  }
}
