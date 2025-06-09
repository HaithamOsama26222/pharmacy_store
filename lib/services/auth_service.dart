import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.8.94:5000/api/Auth';

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ تخزين البيانات بعد نجاح تسجيل الدخول (باستخدام الحقول الصحيحة)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("userID", data["userId"]);
        await prefs.setString("userName", data["username"]);
        await prefs.setString("role", data["role"]);
        await prefs.setBool("isLoggedIn", true);

        return {'success': true, 'data': data};
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'فشل تسجيل الدخول',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'استجابة غير متوقعة من الخادم',
          };
        }
      }
    } catch (e) {
      print('Login Exception: $e');
      return {
        'success': false,
        'message': 'حدث خطأ أثناء الاتصال بالخادم',
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

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }
}
