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
    apiKey: 'AIzaSyARVt-ngJxhuoJMCWXlXvexPQLa4IaKWWU',
    appId: '1:503474351219:web:de89aef85a90c353474e06',
    messagingSenderId: '503474351219',
    projectId: 'fitness-firebase-d1262',
    authDomain: 'fitness-firebase-d1262.firebaseapp.com',
    storageBucket: 'fitness-firebase-d1262.firebasestorage.app',
    measurementId: 'G-XZTYGFZVMY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPdjUYU0WcPLjk-_SyYcldSjDnStu_W2w',
    appId: '1:503474351219:android:11174876c13b5277474e06',
    messagingSenderId: '503474351219',
    projectId: 'fitness-firebase-d1262',
    storageBucket: 'fitness-firebase-d1262.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDn9KsdbqrJ5qmyBlANZ8aqTeidtL_FL28',
    appId: '1:503474351219:ios:12a8a28e15c64843474e06',
    messagingSenderId: '503474351219',
    projectId: 'fitness-firebase-d1262',
    storageBucket: 'fitness-firebase-d1262.firebasestorage.app',
    iosBundleId: 'com.example.firQuest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDn9KsdbqrJ5qmyBlANZ8aqTeidtL_FL28',
    appId: '1:503474351219:ios:12a8a28e15c64843474e06',
    messagingSenderId: '503474351219',
    projectId: 'fitness-firebase-d1262',
    storageBucket: 'fitness-firebase-d1262.firebasestorage.app',
    iosBundleId: 'com.example.firQuest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARVt-ngJxhuoJMCWXlXvexPQLa4IaKWWU',
    appId: '1:503474351219:web:54f52ef27d5e896c474e06',
    messagingSenderId: '503474351219',
    projectId: 'fitness-firebase-d1262',
    authDomain: 'fitness-firebase-d1262.firebaseapp.com',
    storageBucket: 'fitness-firebase-d1262.firebasestorage.app',
    measurementId: 'G-TCVS9VZHFS',
  );

}