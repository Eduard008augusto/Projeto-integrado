import 'package:flutter/material.dart';

import 'login.dart';
import 'registo_p1.dart';
import 'registo_p2.dart';
import 'areas.dart';
import 'feed.dart';
import 'mapa.dart';
import 'settings.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soft Shares',
      initialRoute: '/',
      routes: {
        '/': (context) => RegistarP1(),
        '/areas': (context) => const Areas(),
        '/login': (context) => Login(),
        '/registo1': (context) => RegistarP1(),
        '/registo2': (context) => RegistarP2(),
        '/feed': (context) => const Feed(),
        '/mapa': (context) => const Mapa(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
