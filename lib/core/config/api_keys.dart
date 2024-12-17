// TODO: Move to secure storage in production
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String? get googleApiKey => dotenv.env['GOOGLE_TRANSLATE_API_KEY'];
  // static const String gooLabsApiKey = '993108e7c1e48c6056be45cfdd25e6aa9d490d860c5476ee0c3dab5838109ad6';
}
