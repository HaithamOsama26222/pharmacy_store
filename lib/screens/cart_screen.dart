import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/cart_item.dart';
import '../models/sale_request.dart';
import 'order_success_screen.dart';

final logger = Logger();

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedPaymentMethod = 'الدفع عند الاستلام';

  double get totalPrice {
    return widget.cartItems.fold(0, (sum, item) {
      return sum + (item.product.salePrice ?? 0) * item.quantity;
    });
  }

  Future<void> _submitSale() async {
  if (selectedPaymentMethod.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("يرجى اختيار وسيلة الدفع")),
    );
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final customerId = prefs.getInt('customerId');

  if (customerId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("لم يتم العثور على هوية العميل")),
    );
    return;
  }

  final sale = SaleRequest(
    items: cartItems,
    paymentMethod: selectedPaymentMethod,
    customerId: customerId, // ✅ أضفنا معرف العميل هنا
  );

  final url = Uri.parse('http://10.0.2.2:5176/api/sales');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(sale.toJson()),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final orderId = data['saleID'];

    cartItems.clear(); // إذا لم تستخدم provider بعد
    if (!mounted) return;
   Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => OrderSuccessScreen(
      orderId: orderId,
      paymentMethod: selectedPaymentMethod,
      purchasedItems: List.from(cartItems), // ✅ تمرير المنتجات
    ),
  ),
);

    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("فشل في تنفيذ الطلب")),
    );
  }
}

    } catch (e) {
      if (!mounted) return;
      logger.e("⚠️ خطأ أثناء الإرسال: $e");
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "اختر وسيلة الدفع:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RadioListTile(
                        title: const Text('الدفع عند الاستلام'),
                        value: 'الدفع عند الاستلام',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('بطاقة فيزا / ماستركارد'),
                        value: 'بطاقة فيزا / ماستركارد',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('مدى'),
                        value: 'مدى',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('STC PAY'),
                        value: 'STC PAY',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
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
