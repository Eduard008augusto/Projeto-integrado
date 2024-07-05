import 'package:flutter/material.dart';

import 'login.dart';
import 'registo.dart';
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
        '/': (context) => const Mapa(),
        '/areas': (context) => const Areas(),
        '/login': (context) => Login(),
        '/registo': (context) => Registar(),
        '/feed': (context) => const Feed(),
        '/mapa': (context) => const Mapa(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
