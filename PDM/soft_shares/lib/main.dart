import 'package:flutter/material.dart';

import 'login.dart';
import 'registo.dart';
import 'areas.dart';
import 'feed.dart';

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
        '/': (context) => const Feed(),
        '/areas': (context) => const Areas(),
        '/login': (context) => Login(),
        '/registo': (context) => Registar(),
        '/feed': (context) => const Feed(),
      },
    );
  }
}