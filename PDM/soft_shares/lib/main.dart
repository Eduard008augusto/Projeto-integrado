import 'package:flutter/material.dart';

import 'database/server.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/registo': (context) => const Registar(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centros'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var centros = snapshot.data!['data'];
            return ListView.builder(
              itemCount: centros.length,
              itemBuilder: (context, index) {
                var centro = centros[index];
                return ListTile(
                  title: Text(centro['CENTRO']),
                  subtitle: Text(centro['MORADA']),
                  trailing: Text(centro['TELEFONE'].toString()),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum dado encontrado'));
          }
        },
      ),
    );
  }
}

class Registar extends StatelessWidget {
  const Registar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registar'),
      ),
      body: const Center(
        child: Text('Página de Registo'),
      ),
    );
  }
}
