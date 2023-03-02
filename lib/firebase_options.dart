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
    apiKey: 'AIzaSyC9nuyOWZ32xVoBPCmkS4CHzYn9KaVHH4o',
    appId: '1:195266374056:web:3d4208e51e403c2993159d',
    messagingSenderId: '195266374056',
    projectId: 'nepalsms-43400',
    authDomain: 'nepalsms-43400.firebaseapp.com',
    storageBucket: 'nepalsms-43400.appspot.com',
    measurementId: 'G-H4XP35M2YR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPeRmT5kac7MyZuqhO2lpqk2cx7XiyAl0',
    appId: '1:195266374056:android:83d845a9f0e8406493159d',
    messagingSenderId: '195266374056',
    projectId: 'nepalsms-43400',
    storageBucket: 'nepalsms-43400.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbxAIQHdpXHf-YnhuC_JpVjWJfLlfhOJI',
    appId: '1:195266374056:ios:b721fd7b8174e26393159d',
    messagingSenderId: '195266374056',
    projectId: 'nepalsms-43400',
    storageBucket: 'nepalsms-43400.appspot.com',
    androidClientId: '195266374056-ddgi45o2d2k8vno8cvpn343ik5lajccn.apps.googleusercontent.com',
    iosClientId: '195266374056-0obcp9jin9mia0bft0tam2g820f2m437.apps.googleusercontent.com',
    iosBundleId: 'com.eachut.nepalsms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbxAIQHdpXHf-YnhuC_JpVjWJfLlfhOJI',
    appId: '1:195266374056:ios:24cfae1ca1e9023a93159d',
    messagingSenderId: '195266374056',
    projectId: 'nepalsms-43400',
    storageBucket: 'nepalsms-43400.appspot.com',
    androidClientId: '195266374056-ddgi45o2d2k8vno8cvpn343ik5lajccn.apps.googleusercontent.com',
    iosClientId: '195266374056-thsvv2b3km9pk88gk31nhsneuqu350ic.apps.googleusercontent.com',
    iosBundleId: 'com.example.mysparrowsms',
  );
}
