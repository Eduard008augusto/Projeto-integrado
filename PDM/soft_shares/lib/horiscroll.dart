import 'package:flutter/material.dart';
import './database/server.dart';
import './database/var.dart' as globals;

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({super.key});
  
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum dado disponível'));
          } else {
            final items = snapshot.data!;
            if (items.length <= 5) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items.map((item) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / items.length,
                      child: Column(
                        children: [
                          Image.network(
                            'https://pintbackend-w8pt.onrender.com/images/${item['IMAGEMSUBAREA']}',
                            height: 35.0,
                            width: 35.0,
                          ),
                          const SizedBox(height: 8),
                          Text(item['NOME']),
                        ],
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
                    return Container(
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
                          ),
                        ],
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
