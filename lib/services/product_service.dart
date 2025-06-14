import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pharmacy_store/models/product.dart';
import 'package:pharmacy_store/config.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('فشل في تحميل المنتجات: ${response.statusCode}');
    }
  }
}
