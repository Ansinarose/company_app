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
    apiKey: 'AIzaSyCv-Lk8szT0HGWjrhJGIj4eVvey-xloS8s',
    appId: '1:847922315139:web:3d8b59f1be69be5a9300b6',
    messagingSenderId: '847922315139',
    projectId: 'companyapp-ff875',
    authDomain: 'companyapp-ff875.firebaseapp.com',
    storageBucket: 'companyapp-ff875.appspot.com',
    measurementId: 'G-E8MF2P9BET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuOYv-fGSJnQHwWM2fxxkMsC7m0kONKTE',
    appId: '1:847922315139:android:22b3b10b042b76239300b6',
    messagingSenderId: '847922315139',
    projectId: 'companyapp-ff875',
    storageBucket: 'companyapp-ff875.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzg52Vdx9iqvIYASOPrYvRLViSd6FHQ_c',
    appId: '1:847922315139:ios:d45664de05530e639300b6',
    messagingSenderId: '847922315139',
    projectId: 'companyapp-ff875',
    storageBucket: 'companyapp-ff875.appspot.com',
    iosBundleId: 'com.example.companyApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzg52Vdx9iqvIYASOPrYvRLViSd6FHQ_c',
    appId: '1:847922315139:ios:d45664de05530e639300b6',
    messagingSenderId: '847922315139',
    projectId: 'companyapp-ff875',
    storageBucket: 'companyapp-ff875.appspot.com',
    iosBundleId: 'com.example.companyApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCv-Lk8szT0HGWjrhJGIj4eVvey-xloS8s',
    appId: '1:847922315139:web:31fb708638a30d759300b6',
    messagingSenderId: '847922315139',
    projectId: 'companyapp-ff875',
    authDomain: 'companyapp-ff875.firebaseapp.com',
    storageBucket: 'companyapp-ff875.appspot.com',
    measurementId: 'G-F2CN86TY16',
  );
}