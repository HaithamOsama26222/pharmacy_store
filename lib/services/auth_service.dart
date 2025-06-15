import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("userID", data["userId"]);
      await prefs.setString("userName", data["username"]);
      await prefs.setString("role", data["role"]);
      return {"success": true, "data": data};
    } else {
      return {"success": false, "message": "فشل تسجيل الدخول"};
    }
  }
}