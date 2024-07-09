import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import './services/firebase_options.dart';

import './database/var.dart' as globals;
import 'conteudo.dart';
import 'login.dart';
import 'registo.dart';
import 'areas.dart';
import 'feed.dart';
import 'mapa.dart';
import 'settings.dart';
import 'add_conteudo.dart';
//import 'perfil.dart';
import 'services/token_service.dart';


Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeFirebase();

  globals.token = await TokenManager().getToken();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soft Shares',
      initialRoute: '/',
      routes: {
        '/': (context) => globals.token == null ? Login() : const Mapa(),
        '/areas': (context) => const Areas(),
        '/login': (context) => Login(),
        '/registo': (context) => Registar(),
        '/feed': (context) => const Feed(),
        '/mapa': (context) => const Mapa(),
        '/settings': (context) => const SettingsPage(),
        '/conteudo': (context) => const Conteudo(),
        '/addconteudo': (context) => Addconteudo(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'PT'),
      ],
    );
  }
}
