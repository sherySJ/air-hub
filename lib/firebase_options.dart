// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA_8T5eUwk2WnjaTEtWRB1IC0jwGVPlYyk',
    appId: '1:535801431601:web:1ce9ab0d463a423a24f710',
    messagingSenderId: '535801431601',
    projectId: 'air-hub-4a86a',
    authDomain: 'air-hub-4a86a.firebaseapp.com',
    storageBucket: 'air-hub-4a86a.appspot.com',
    measurementId: 'G-E2Z1W606BV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDq7U0suFNAX8EG8AfCv0zwPJNtvAdfjSs',
    appId: '1:535801431601:android:8729a6af72bc2ae324f710',
    messagingSenderId: '535801431601',
    projectId: 'air-hub-4a86a',
    storageBucket: 'air-hub-4a86a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHcf59azl2d0C1TAa9DR4l7v5XYoz0Gmw',
    appId: '1:535801431601:ios:fe0e1f8ae93c490524f710',
    messagingSenderId: '535801431601',
    projectId: 'air-hub-4a86a',
    storageBucket: 'air-hub-4a86a.appspot.com',
    iosClientId: '535801431601-bmvcjin3jo360amljaq1bbnia76ikcfh.apps.googleusercontent.com',
    iosBundleId: 'com.example.airHub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHcf59azl2d0C1TAa9DR4l7v5XYoz0Gmw',
    appId: '1:535801431601:ios:fe0e1f8ae93c490524f710',
    messagingSenderId: '535801431601',
    projectId: 'air-hub-4a86a',
    storageBucket: 'air-hub-4a86a.appspot.com',
    iosClientId: '535801431601-bmvcjin3jo360amljaq1bbnia76ikcfh.apps.googleusercontent.com',
    iosBundleId: 'com.example.airHub',
  );
}