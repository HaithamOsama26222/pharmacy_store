import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacy_store/config.dart';

class UserAuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/UserAuth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'userId': data['userId'],
          'username': data['username'],
          'role': data['role'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'فشل تسجيل الدخول',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ أثناء الاتصال بالخادم',
      };
    }
  }
}
