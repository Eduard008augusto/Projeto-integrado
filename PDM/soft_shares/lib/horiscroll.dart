import 'package:flutter/material.dart';
import './database/server.dart';
import './database/var.dart' as globals;

class HorizontalListView extends StatefulWidget {
  final Function(int) onSubAreaSelected;

  const HorizontalListView({super.key, required this.onSubAreaSelected});

  @override
  HorizontalListViewState createState() => HorizontalListViewState();
}

class HorizontalListViewState extends State<HorizontalListView> {
  int _selectedSubAreaId = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSubAreas(globals.idArea),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final items = [
              {
                'ID_SUBAREA': 0,
                'NOME': 'Todos',
                'IMAGEMSUBAREA': '82af5c884b93402a7cc253a3f105d291'
              },
              ...?snapshot.data // Use null-aware spread operator
            ];

            if (items.length <= 5) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items.map((item) {
                    final isSelected = _selectedSubAreaId == item['ID_SUBAREA'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSubAreaId = item['ID_SUBAREA'];
                          globals.idSubArea = item['ID_SUBAREA'];
                          widget.onSubAreaSelected(_selectedSubAreaId);
                        });
                      },
                      child: Opacity(
                        opacity: isSelected ? 1.0 : 0.5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / items.length,
                          child: Column(
                            children: [
                              Image.network(
                                'https://pintbackend-w8pt.onrender.com/images/${item['IMAGEMSUBAREA']}',
                                height: 35.0,
                                width: 35.0,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['NOME'],
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0) : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedSubAreaId == items[index]['ID_SUBAREA'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSubAreaId = items[index]['ID_SUBAREA'];
                          globals.idSubArea = items[index]['ID_SUBAREA'];
                          widget.onSubAreaSelected(_selectedSubAreaId);
                        });
                      },
                      child: Opacity(
                        opacity: isSelected ? 1.0 : 0.5,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://pintbackend-w8pt.onrender.com/images/${items[index]['IMAGEMSUBAREA']}',
                                height: 35.0,
                                width: 35.0,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                items[index]['NOME'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
