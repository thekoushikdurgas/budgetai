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
    apiKey: 'AIzaSyBRs_OXjMiXJdgiMAMvapfsPY90m9C9yKo',
    appId: '1:162174681428:web:291c149263df1cce4708c1',
    messagingSenderId: '162174681428',
    projectId: 'budgetai-10d1c',
    authDomain: 'budgetai-10d1c.firebaseapp.com',
    storageBucket: 'budgetai-10d1c.firebasestorage.app',
    measurementId: 'G-VJVXL9FK0G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHYaR9zWQhrpI06q3C14Wj0Jm95Bft_fc',
    appId: '1:162174681428:android:06b0e01ed2c180b84708c1',
    messagingSenderId: '162174681428',
    projectId: 'budgetai-10d1c',
    storageBucket: 'budgetai-10d1c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCENKcClq6G6YDqewEp8jqjAJ-rJG1ddU4',
    appId: '1:162174681428:ios:9ef5925a9c1711714708c1',
    messagingSenderId: '162174681428',
    projectId: 'budgetai-10d1c',
    storageBucket: 'budgetai-10d1c.firebasestorage.app',
    iosClientId: '162174681428-utniudtqnur59657jcdc7bqaos1j80ee.apps.googleusercontent.com',
    iosBundleId: 'com.durgas.templateAppBloc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCENKcClq6G6YDqewEp8jqjAJ-rJG1ddU4',
    appId: '1:162174681428:ios:9ef5925a9c1711714708c1',
    messagingSenderId: '162174681428',
    projectId: 'budgetai-10d1c',
    storageBucket: 'budgetai-10d1c.firebasestorage.app',
    iosClientId: '162174681428-utniudtqnur59657jcdc7bqaos1j80ee.apps.googleusercontent.com',
    iosBundleId: 'com.durgas.templateAppBloc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRs_OXjMiXJdgiMAMvapfsPY90m9C9yKo',
    appId: '1:162174681428:web:771d1a44e101e30f4708c1',
    messagingSenderId: '162174681428',
    projectId: 'budgetai-10d1c',
    authDomain: 'budgetai-10d1c.firebaseapp.com',
    storageBucket: 'budgetai-10d1c.firebasestorage.app',
    measurementId: 'G-ZEF15D8CER',
  );

}