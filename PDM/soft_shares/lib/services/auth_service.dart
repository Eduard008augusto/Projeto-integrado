// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../database/server.dart'; 
import '../database/var.dart' as globals;
import 'token_service.dart';

class AuthService {

  // Google Sign In
  signInWithGoogle() async {

      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return false;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      var result = await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = result.user;

      if (user != null) {
        try{
          Map<String, dynamic> regRes = await registo(globals.idCentroUSER, user.displayName, user.email, user.uid);

          if(regRes['success']){
            globals.idUtilizador = regRes['ID_UTILIZADOR'];
            return true;
          }
        } catch (e) {
          print(e);

          Map<String, dynamic> logRes = await login(user.email!, user.uid);
          
          if(logRes['success']){
            globals.idUtilizador = logRes['id_utilizador'];
            await TokenManager().storeToken(logRes['token']);
            return true;
          }
          else{
            throw Exception('GOOGLE: Error durante login!');
          }
        }
      } else {
        return false;
      }
  }

  Map _userObj = {};

  signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        User? user = userCredential.user;

        if (user != null) {
          final userData = await FacebookAuth.instance.getUserData();
          _userObj = userData;

          try {
            print(_userObj["id"]);
            print(_userObj["email"]);
            Map<String, dynamic> regRes = await registo(globals.idCentroUSER, _userObj["name"], _userObj["email"], _userObj["id"]);

            if (regRes['success']) {
              globals.idUtilizador = regRes['ID_UTILIZADOR'];
              return true;
            }
          } catch (e) {
            print(_userObj["id"]);
            print(_userObj["email"]);
            Map<String, dynamic> logRes = await login(_userObj["email"], _userObj["id"]);

            if (logRes['success']) {
              globals.idUtilizador = logRes['id_utilizador'];
              await TokenManager().storeToken(logRes['token']);
              return true;
            } else {
              throw Exception('FACEBOOK: Error durante login!');
            }
          }
        } else {
          return false;
        }
      } else if (result.status == LoginStatus.cancelled) {
        return false;
      } else {
        throw Exception('Erro no login com Facebook: ${result.message}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
