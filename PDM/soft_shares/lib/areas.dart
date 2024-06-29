import 'package:flutter/material.dart';
import './database/server.dart';

void main() {
  runApp(const Areas());
}

class Areas extends StatelessWidget {
  const Areas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Areas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'),);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma área encontrada'),);
          } else {
            final List<Map<String, dynamic>> areas = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Duas colunas por linha
                crossAxisSpacing: 10.0, // Espaçamento entre as colunas
                mainAxisSpacing: 10.0, // Espaçamento entre as linhas
                childAspectRatio: 0.90, // Proporção da altura dos cards em relação à largura
              ),
              itemCount: areas.length,
              itemBuilder: (context, index) {
                final area = areas[index];
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        'https://pintbackend-w8pt.onrender.com/images/${area['IMAGEMAREA']}',
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text(area['NOME']),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
