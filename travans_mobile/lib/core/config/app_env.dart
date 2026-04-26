import 'package:flutter/foundation.dart';

class AppEnv {
  static const googleClientId =
      '901273605331-pkfm74l0jqa292mh12h4269tfiukbgho.apps.googleusercontent.com';

  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }

    return 'http://localhost:8080/api';
  }
}
