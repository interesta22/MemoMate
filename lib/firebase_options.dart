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
    apiKey: 'AIzaSyCH55-nxIOZd21ztQhBhRP1WECd0YflW_8',
    appId: '1:270248848389:web:40cec584dfe967167d406c',
    messagingSenderId: '270248848389',
    projectId: 'notes-app-cbaf0',
    authDomain: 'notes-app-cbaf0.firebaseapp.com',
    storageBucket: 'notes-app-cbaf0.appspot.com',
    measurementId: 'G-2WDTH0ME0P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDH6V4pRd_M_2_vpFjSnGQo2Jeni0xf4MI',
    appId: '1:270248848389:android:8280fa6113a1c74f7d406c',
    messagingSenderId: '270248848389',
    projectId: 'notes-app-cbaf0',
    storageBucket: 'notes-app-cbaf0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzutwKi2mA8PjlBoZbS0MdvGH9VF5h_wA',
    appId: '1:270248848389:ios:609e96bb6b486ac47d406c',
    messagingSenderId: '270248848389',
    projectId: 'notes-app-cbaf0',
    storageBucket: 'notes-app-cbaf0.appspot.com',
    iosBundleId: 'com.example.myNotesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzutwKi2mA8PjlBoZbS0MdvGH9VF5h_wA',
    appId: '1:270248848389:ios:609e96bb6b486ac47d406c',
    messagingSenderId: '270248848389',
    projectId: 'notes-app-cbaf0',
    storageBucket: 'notes-app-cbaf0.appspot.com',
    iosBundleId: 'com.example.myNotesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCH55-nxIOZd21ztQhBhRP1WECd0YflW_8',
    appId: '1:270248848389:web:e30bf5a351a01cd77d406c',
    messagingSenderId: '270248848389',
    projectId: 'notes-app-cbaf0',
    authDomain: 'notes-app-cbaf0.firebaseapp.com',
    storageBucket: 'notes-app-cbaf0.appspot.com',
    measurementId: 'G-T3ZEJ5Q8LS',
  );
}
