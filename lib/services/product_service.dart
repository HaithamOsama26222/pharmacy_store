import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    // عنوان السيرفر عند تشغيل التطبيق على هاتف حقيقي
final String baseUrl = 'http://192.168.8.94:5176/api';

    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('فشل في تحميل المنتجات: ${response.statusCode}');
    }
  }
}
