// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:soft_shares/drawer.dart';
import 'database/server.dart';
import 'database/var.dart' as globals;

class Preferencias extends StatefulWidget {
  const Preferencias({super.key});

  @override
  State<Preferencias> createState() => _PreferenciasState();
}

void salvar(var area) async {
  await savePreferencia(globals.idUtilizador, globals.idCentro, area);
}

void apagar(var area) async {
  await deletePreferencia(globals.idUtilizador, globals.idCentro, area);
}

class _PreferenciasState extends State<Preferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Áreas Preferenciais'),
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAreasPreferencias(globals.idCentro, globals.idUtilizador), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError){
            return Center(child: Text('Erro: ${snapshot.error}', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('Lista vazia :(', overflow: TextOverflow.ellipsis, maxLines: 2));
          } else {
            final List<Map<String, dynamic>> areas = snapshot.data!;
            return ListView.builder(
              itemCount: areas.length,
              itemBuilder: (context, index) {
                final area = areas[index];

                return CheckboxListTile(
                  title: Text(area['NOME']),
                  value: area['AreaPreferida'],
                  onChanged: (bool? value) async {
                    setState(() {
                      if(area['AreaPreferida']){
                        apagar(area['ID_AREA']);
                      } else {
                        salvar(area['ID_AREA']);
                      }
                    });
                    await Future.delayed(const Duration(milliseconds: 100));
                    setState(() {});
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}