import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/sale_request.dart';
import 'order_success_screen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get totalPrice {
    return widget.cartItems.fold(0, (sum, item) {
      return sum + (item.product.salePrice ?? 0) * item.quantity;
    });
  }

  Future<void> submitSale() async {
    final sale = SaleRequest(widget.cartItems);
    final url = Uri.parse('http://10.0.2.2:5176/api/sales');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sale.toJson()),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          widget.cartItems.clear();
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ فشل: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ خطأ أثناء الإرسال: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سلة المشتريات")),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("السلة فارغة"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        leading: const Icon(Icons.medication_outlined),
                        title: Text(item.product.productName ?? 'بدون اسم'),
                        subtitle: Text(
                          "السعر: ${item.product.salePrice?.toStringAsFixed(2) ?? '-'} × ${item.quantity}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              widget.cartItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "الإجمالي: ${totalPrice.toStringAsFixed(2)} ر.س",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: submitSale,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("إتمام الطلب"),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
