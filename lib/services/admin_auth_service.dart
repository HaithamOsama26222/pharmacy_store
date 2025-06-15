import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminAuthService {
  static const String _baseUrl = 'http://10.0.2.2:5000/api/Auth';

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/admin-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Admin login failed: ${response.body}');
      return false;
    }
  }
}