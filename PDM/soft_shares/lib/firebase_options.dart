// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDEtA2EvOSi3VLXpbE0JLsgyOTgchgV9pc',
    appId: '1:916645397340:web:814160e42ecc5679def799',
    messagingSenderId: '916645397340',
    projectId: 'pint-login-b0779',
    authDomain: 'pint-login-b0779.firebaseapp.com',
    storageBucket: 'pint-login-b0779.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCw9IvR1dWIV1Gp1WWPZQy4SsCvDi0caMY',
    appId: '1:916645397340:android:489d4c418bb3aa5edef799',
    messagingSenderId: '916645397340',
    projectId: 'pint-login-b0779',
    storageBucket: 'pint-login-b0779.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxKq0z726HsuaAzo4c_m-BPvgabdyr9UM',
    appId: '1:916645397340:ios:ef4667fd51b6dd7cdef799',
    messagingSenderId: '916645397340',
    projectId: 'pint-login-b0779',
    storageBucket: 'pint-login-b0779.appspot.com',
    iosBundleId: 'com.example.softShares',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxKq0z726HsuaAzo4c_m-BPvgabdyr9UM',
    appId: '1:916645397340:ios:ef4667fd51b6dd7cdef799',
    messagingSenderId: '916645397340',
    projectId: 'pint-login-b0779',
    storageBucket: 'pint-login-b0779.appspot.com',
    iosBundleId: 'com.example.softShares',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDEtA2EvOSi3VLXpbE0JLsgyOTgchgV9pc',
    appId: '1:916645397340:web:2e036b9f2c83431bdef799',
    messagingSenderId: '916645397340',
    projectId: 'pint-login-b0779',
    authDomain: 'pint-login-b0779.firebaseapp.com',
    storageBucket: 'pint-login-b0779.appspot.com',
  );
}
