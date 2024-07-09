import 'package:flutter/material.dart';
import 'package:soft_shares/drawer.dart';
import './database/server.dart';
import './database/var.dart' as globals;
//import 'package:intl/intl.dart';

void main() {
  runApp(const Areas());
}

String obterSaudacao() {
  var agora = DateTime.now();
  var horaAtual = agora.hour;

  if (horaAtual >= 5 && horaAtual < 12) {
    return 'Bom dia!';
  } else if (horaAtual >= 12 && horaAtual < 18) {
    return 'Boa Tarde!';
  } else {
    return 'Boa Noite!';
  }
}

class Areas extends StatelessWidget {
  const Areas({super.key});

  @override
  Widget build(BuildContext context) {
    String saudacao = obterSaudacao();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Areas'),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              saudacao,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAreas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma área encontrada'));
                } else {
                  final List<Map<String, dynamic>> areas = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.90,
                    ),
                    itemCount: areas.length,
                    itemBuilder: (context, index) {
                      final area = areas[index];
                      return GestureDetector(
                        onTap: () {
                          globals.idArea = area['ID_AREA'];
                          globals.nomArea = area['NOME']; 
                          Navigator.pushNamed(context, '/feed');
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity, 
                                height: 150.0, 
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                    'https://pintbackend-w8pt.onrender.com/images/${area['IMAGEMAREA']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
