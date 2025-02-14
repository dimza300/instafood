import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Globalconst {
  static const baseUrlApi = 'http://10.0.2.2';
  final _storage = const FlutterSecureStorage();

  Future<String> getTokenStorage() async {
    try {
      final token = await _storage.read(key: 'token');
      return token ?? "";
    } catch (e) {
      return "";
    }
  }
}
