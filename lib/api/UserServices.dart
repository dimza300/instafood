import 'dart:convert';
import 'package:Instafood/helpers/GlobalConst.dart';
import 'package:Instafood/model/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserServices {
  final _storage = FlutterSecureStorage();
  final globData = new Globalconst();
  final url = Globalconst.baseUrlApi;

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$url/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return data['token'];
    } else {
      return null;
    }
  }

  Future<User?> fetchUserData() async {
    final token = await globData.getTokenStorage();
    final response = await http.get(
      Uri.parse('$url/api/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    final token = await globData.getTokenStorage();
    await http.post(
      Uri.parse('$url/api/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    await _storage.delete(key: 'token');
  }
}
