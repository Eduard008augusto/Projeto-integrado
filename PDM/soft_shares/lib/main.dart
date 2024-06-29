import 'package:flutter/material.dart';

import 'login.dart';
import 'registo.dart';
import 'areas.dart';

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
        '/': (context) => const Areas(),
        '/login': (context) => Login(),
        '/registo': (context) => Registar(),
      },
    );
  }
}