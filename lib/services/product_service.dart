import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    // استخدم 10.0.2.2 للمحاكي
    final String baseUrl;

    if (Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:5176/api'; // ✅ هذا هو الصحيح لـ LDPlayer
    } else {
      baseUrl = 'http://localhost:5176/api';
    }

    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('فشل في تحميل المنتجات: ${response.statusCode}');
    }
  }
}
