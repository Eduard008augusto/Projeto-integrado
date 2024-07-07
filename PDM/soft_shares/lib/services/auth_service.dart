// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  // Google Sign In
  signInWithGoogle() async {
    // begin interactive sign in process
    try {
      // Iniciar o processo interativo de login
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // O usuário cancelou o login
        return false;
      }

      // Obter detalhes de autenticação da solicitação
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Criar uma nova credencial para o usuário
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Fazer login no Firebase com a credencial
      var result = await FirebaseAuth.instance.signInWithCredential(credential);

      // Obter o usuário logado
      User? user = result.user;

      if (user != null) {
        // Login bem-sucedido
        return true;
      } else {
        // Falha no login
        return false;
      }
    } catch (e) {
      throw Exception('Erro durante o login: $e');
    }
  }
}