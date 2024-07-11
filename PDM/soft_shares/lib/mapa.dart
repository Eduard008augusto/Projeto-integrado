import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drawer_mapa.dart';
import './database/var.dart' as globals;

void main() {
  // Bloqueia a orientação para retrato (vertical)
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const Mapa());
  });
}

class Mapa extends StatelessWidget {
  const Mapa({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double scalingFactor = screenWidth > screenHeight ? screenWidth / 400 : screenHeight / 400;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset(
            'assets/images/logo2.svg', 
            height: 25.0,
            width: 25.0,
          ),
        ),

      drawer: const MenuDrawer(),
      body: Center(
        child: Stack(
          children: [
            // SVG  fundo 
            SvgPicture.asset(
              'assets/images/Distritos/PT_1.svg',
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
                  globals.idCentro = 5;
                  Navigator.pushNamed(context, '/areas');
                },
                child: SvgPicture.asset(
                  'assets/images/Distritos/VilaReal.svg',
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
                  globals.idCentro = 1;
                  Navigator.pushNamed(context, '/areas');
                },
                child: SvgPicture.asset(
                  'assets/images/Distritos/Viseu.svg',
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
                  globals.idCentro = 6;
                  Navigator.pushNamed(context, '/areas');
                },
                child: SvgPicture.asset(
                  'assets/images/Distritos/Lisboa.svg',
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
                  globals.idCentro = 2;
                  Navigator.pushNamed(context, '/areas');
                },
                child: SvgPicture.asset(
                  'assets/images/Distritos/Santarem.svg',
                  width: screenWidth * 0.19 * scalingFactor,
                  height: screenWidth * 0.19 * scalingFactor,
                ),
              ),
            ),

            // SVG  Portalegre

             Positioned(
              top: screenHeight * 0.196 * scalingFactor,
              left: screenWidth * 0.165 * scalingFactor,
              child: GestureDetector(
                onTap: () {
                  globals.idCentro = 4;
                  Navigator.pushNamed(context, '/areas');
                },
                child: SvgPicture.asset(
                  'assets/images/Distritos/Portalegre.svg',
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
                  globals.idCentro = 3;
                  Navigator.pushNamed(context, '/areas');
                },
                child: SvgPicture.asset(
                  'assets/images/Distritos/CasteloBranco.svg',
                  width: screenWidth * 0.152 * scalingFactor,
                  height: screenWidth * 0.152 * scalingFactor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
