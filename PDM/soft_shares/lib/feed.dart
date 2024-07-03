import 'package:flutter/material.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/drawer.dart';

import './database/var.dart' as globals;

void main() {
  runApp(const MaterialApp(
    home: Feed(),
  ));
}

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOME AREA'),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 20,),
          Icon(Icons.calendar_month),
          SizedBox(width: 20,),
          Icon(Icons.filter_alt_outlined),
        ],
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 100.0, // Altura do scroll horizontal
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconWithSubtitle(icon: Icons.home, subtitle: 'Home'),
                  IconWithSubtitle(icon: Icons.business, subtitle: 'Business'),
                  IconWithSubtitle(icon: Icons.school, subtitle: 'School'),
                  IconWithSubtitle(icon: Icons.local_hospital, subtitle: 'Hospital'),
                  IconWithSubtitle(icon: Icons.park, subtitle: 'Park'),
                  IconWithSubtitle(icon: Icons.shopping_cart, subtitle: 'Shopping'),
                  IconWithSubtitle(icon: Icons.restaurant, subtitle: 'Restaurant'),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchPublicacoes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'),);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma publicação encontrada'),);
                } else {
                  final List<Map<String, dynamic>> publicacoes = snapshot.data!;
                  return ListView.builder(
                    itemCount: publicacoes.length,
                    itemBuilder: (context, index) {
                      final publicacao = publicacoes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 15.0), // Espaçamento entre os cards
                        child: SizedBox(
                          height: 300, // Define a altura do card
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                    'https://pintbackend-w8pt.onrender.com/images/${publicacao['IMAGEMCONTEUDO']}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200, // Ajuste a altura da imagem conforme necessário
                                  ),
                                ),
                                const SizedBox(height: 10.0,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(publicacao['NOMECONTEUDO'], style: const TextStyle(fontSize: 20.0),),
                                      Text(publicacao['MORADA']),
                                      Text(publicacao['TELEFONE']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

class IconWithSubtitle extends StatelessWidget {
  final IconData icon;
  final String subtitle;

  const IconWithSubtitle({super.key, required this.icon, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0,),
          const SizedBox(height: 5.0,),
          Text(subtitle),
        ],
      ),
    );
  }
}
