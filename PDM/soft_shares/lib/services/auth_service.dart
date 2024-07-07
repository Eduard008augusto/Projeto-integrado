// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/server.dart';
import '../database/var.dart' as globals;

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
        print('User ID: ${user.uid}');
        print('User Name: ${user.displayName}');
        print('User Email: ${user.email}');
        print('User Photo URL: ${user.photoURL}');
        print('Email Verificado: ${user.emailVerified}');
        print('Número de Telefone: ${user.phoneNumber}');
        print('Login Anônimo: ${user.isAnonymous}');
        print('Metadata (Criação): ${user.metadata.creationTime}');
        print('Metadata (Último Login): ${user.metadata.lastSignInTime}');
        print('Provedores: ${user.providerData}');
        print('ID do Locatário: ${user.tenantId}');
        print('Token de Atualização: ${user.refreshToken}');

        await registo(globals.idCentro, user.displayName, user.email, user.uid);

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