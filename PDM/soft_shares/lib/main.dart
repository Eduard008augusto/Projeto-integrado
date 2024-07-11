import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './database/var.dart' as globals;
import 'conteudo.dart';
import 'login.dart';
import 'registo.dart';
import 'areas.dart';
import 'feed.dart';
import 'mapa.dart';
import 'settings.dart';
import 'add_conteudo.dart';
import 'perfil.dart';
import 'services/token_service.dart';
//import 'edit_perfil.dart';
//import 'image_picker_page.dart';
import 'feed_eventos.dart';
import 'calendario_eventos.dart';
import 'add_evento.dart';
import 'evento.dart';
import 'favoritos.dart';




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
  globals.idUtilizador = await TokenManager().getIdUtilizador();
  globals.nomeUtilizador = await TokenManager().getNomeUtilizador();
  
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
        '/addconteudo': (context) => const Addconteudo(),
        '/perfil': (context) => const Perfil(),
        '/ediperfil': (context) => const Perfil(),
        '/feedeventos': (context) => const FeedEventos(),
        '/calendario': (context) => const CalendarioEventos(),
        '/addevento': (context) => const AddEvento(),
        '/evento': (context) => const Evento(),
        '/favoritos': (context) => const Favoritos(),
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
