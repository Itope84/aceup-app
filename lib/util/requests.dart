import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiRequest {
  static final String BASE_URL = "https://aceup.app/api/v1";

  static Future<Map<String, String>> headers() async {
    final storage = new FlutterSecureStorage();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String token =  await storage.read(key: 'token');
    if(token != null) {
      headers.addAll({
        'Authorization': "Bearer $token"
      });
    }

    return headers;
  }
}