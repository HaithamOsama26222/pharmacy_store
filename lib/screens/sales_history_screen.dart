import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _sales;

  @override
  void initState() {
    super.initState();
    _sales = fetchSales();
  }

  Future<List<Map<String, dynamic>>> fetchSales() async {
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getInt('customerId');

    if (customerId == null) {
      throw Exception('لا يوجد معرف عميل مسجل');
    }

    final url = Uri.parse('http://10.0.2.2:5176/api/sales/by-customer/$customerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('فشل تحميل سجل الطلبات');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سجل الطلبات")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _sales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("خطأ: ${snapshot.error}"));
          }

          final sales = snapshot.data;
          if (sales == null || sales.isEmpty) {
            return const Center(child: Text("لا توجد طلبات سابقة."));
          }

          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return ListTile(
                title: Text("طلب رقم: ${sale['saleID']}"),
                subtitle: Text("التاريخ: ${sale['saleDate'].split('T')[0]}"),
                trailing: Text("${sale['totalAmount']} ر.س"),
              );
            },
          );
        },
      ),
    );
  }
}
