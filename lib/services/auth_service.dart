import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/Auth/login';

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ تخزين البيانات بعد نجاح تسجيل الدخول
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("userID", data["userID"]);
      await prefs.setString("userName", data["userName"]);
      await prefs.setBool("isLoggedIn", true);

      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': jsonDecode(response.body)['message'] ?? 'فشل تسجيل الدخول'
      };
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userName");
  }
}
