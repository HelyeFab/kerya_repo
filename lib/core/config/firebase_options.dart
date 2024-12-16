import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can create them using the Firebase Console',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // TODO: Replace with your Android configuration
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can create them using the Firebase Console',
        );
      case TargetPlatform.iOS:
        // TODO: Replace with your iOS configuration
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can create them using the Firebase Console',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
