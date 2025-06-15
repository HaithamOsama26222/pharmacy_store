import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacy_store/config.dart';

class CustomerAuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email_Customer': email,
          'password_Customer': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'customerId': data['customerId'],
          'name': data['name'],
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
