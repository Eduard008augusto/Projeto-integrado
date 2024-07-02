import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scalingFactor = screenWidth > screenHeight ? screenWidth / 400 : screenHeight / 400;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
 drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 48, 99, 141),
              ),
              child: Text('MENU'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/PagPerfil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border_rounded),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pushNamed(context, '/PagFavoritos');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Definições'),
              onTap: () {
                Navigator.pushNamed(context, '/PagDefinicoes');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            // SVG  fundo 
            SvgPicture.asset(
              'assets/Distritos/PT_1.svg',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            
            // SVG  VilaReal 
            
            Positioned(
              top: screenHeight * 0.021 * scalingFactor,
              left: screenWidth * 0.155 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: SvgPicture.asset(
                  'assets/Distritos/VilaReal.svg',
                  width: screenWidth * 0.142 * scalingFactor,
                  height: screenWidth * 0.142 * scalingFactor,
                ),
              ),
            ),

            // SVG  Viseu 

            Positioned(
              top: screenHeight * 0.075 * scalingFactor,
              left: screenWidth * 0.145 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: SvgPicture.asset(
                  'assets/Distritos/Viseu.svg',
                  width: screenWidth * 0.16 * scalingFactor,
                  height: screenWidth * 0.16 * scalingFactor,
                ),
              ),
            ),

            // SVG  Lisboa 

            Positioned(
              top: screenHeight * 0.233 * scalingFactor,
              left: screenWidth * 0.022 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: SvgPicture.asset(
                  'assets/Distritos/Lisboa.svg',
                  width: screenWidth * 0.11 * scalingFactor,
                  height: screenWidth * 0.11 * scalingFactor,
                ),
              ),
            ),
            
            // SVG  Santarem

             Positioned(
              top: screenHeight * 0.188 * scalingFactor,
              left: screenWidth * 0.076 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: SvgPicture.asset(
                  'assets/Distritos/Santarem.svg',
                  width: screenWidth * 0.19 * scalingFactor,
                  height: screenWidth * 0.19 * scalingFactor,
                ),
              ),
            ),

            // SVG  Portalegre

             Positioned(
              top: screenHeight * 0.196* scalingFactor,
              left: screenWidth * 0.165 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: SvgPicture.asset(
                  'assets/Distritos/Portalegre.svg',
                  width: screenWidth * 0.152 * scalingFactor,
                  height: screenWidth * 0.152 * scalingFactor,
                ),
              ),
            ),

  
            // SVG  CateloBranco

             Positioned(
              top: screenHeight * 0.137 * scalingFactor,
              left: screenWidth * 0.165 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: SvgPicture.asset(
                  'assets/Distritos/CasteloBranco.svg',
                  width: screenWidth * 0.152 * scalingFactor,
                  height: screenWidth * 0.152 * scalingFactor,
                ),
              ),
            ),


            // Contador (tamanho fixo)
            Positioned(
              bottom: 20 * scalingFactor,
              child: Text(
                '$_counter',
                style: TextStyle(fontSize: 24 * scalingFactor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
