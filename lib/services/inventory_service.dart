import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventory.dart';

class InventoryService {
  // ✅ غيّر IP إلى IP السيرفر الفعلي عند التشغيل على جهاز حقيقي
  static const String baseUrl = 'http://10.0.2.2:5000/api/Inventory';

  /// ✅ جلب جميع عناصر الجرد
  static Future<List<Inventory>> fetchInventories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Inventory.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل بيانات الجرد');
    }
  }

  /// ✅ جلب عنصر جرد حسب المعرّف
  static Future<Inventory> fetchInventoryById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Inventory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('لم يتم العثور على عنصر الجرد');
    }
  }

  /// ✅ إضافة عنصر جرد جديد
  static Future<void> addInventory(Inventory inventory) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'productID': inventory.productID,
        'quantityInStock': inventory.quantityInStock,
        'lowStockThreshold': inventory.lowStockThreshold,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة عنصر الجرد');
    }
  }

  /// ✅ تحديث بيانات عنصر الجرد
  static Future<void> updateInventory(Inventory inventory) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${inventory.inventoryID}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'inventoryID': inventory.inventoryID,
        'productID': inventory.productID,
        'quantityInStock': inventory.quantityInStock,
        'lowStockThreshold': inventory.lowStockThreshold,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('فشل في تعديل بيانات الجرد');
    }
  }

  /// ✅ حذف عنصر جرد
  static Future<void> deleteInventory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('فشل في حذف عنصر الجرد');
    }
  }
}
