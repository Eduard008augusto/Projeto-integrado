import 'package:flutter/material.dart';
import 'package:soft_shares/drawer.dart';
import './database/server.dart';
import './database/var.dart' as globals;

void main() {
  runApp(const Areas());
}

String obterSaudacao() {
  var agora = DateTime.now();
  var horaAtual = agora.hour;

  if (horaAtual >= 5 && horaAtual < 12) {
    return 'Bom dia';
  } else if (horaAtual >= 12 && horaAtual < 18) {
    return 'Boa Tarde';
  } else {
    return 'Boa Noite';
  }
}

class Areas extends StatelessWidget {
  const Areas({super.key});

  String getImagePath(int idCentro) {
    switch (idCentro) {
      case 1:
        return 'assets/images/Banner/viseu.png';
      case 2:
        return 'assets/images/Banner/santarem.png';
      case 3:
        return 'assets/images/Banner/fundao.png';
      case 4:
        return 'assets/images/Banner/portalegre.png';
      case 5:
        return 'assets/images/Banner/vilareal.png';
      default:
        return 'assets/images/Banner/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Areas'),
      ),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage(getImagePath(globals.idCentro)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: fetchUtilizador(globals.idUtilizador),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('ID DE UTILIZADOR INVÁLIDO'));
                    } else {
                      final Map<String, dynamic> user = snapshot.data!;
                      String saudacao = '${obterSaudacao()} ${user['NOME']}!';
                      return Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            saudacao,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Reduced font size for smaller size
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Added spacing between image and cards
            // Display the list of areas
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
                        childAspectRatio: 0.75,
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
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
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      area['NOME'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
      ),
    );
  }
}
