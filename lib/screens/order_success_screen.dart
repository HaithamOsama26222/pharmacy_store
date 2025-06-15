import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class OrderSuccessScreen extends StatelessWidget {
  final int orderId;
  final String paymentMethod;
  final List<CartItem> purchasedItems; // ✅ المنتجات التي تم شراؤها

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.paymentMethod,
    required this.purchasedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نجاح الطلب")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 16),
            Text("تم تنفيذ الطلب بنجاح", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 10),
            Text("رقم الطلب: $orderId"),
            Text("طريقة الدفع: $paymentMethod"),
            const SizedBox(height: 20),
            const Divider(),
            const Text("تفاصيل المنتجات:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = purchasedItems[index];
                  return ListTile(
                    leading: const Icon(Icons.medication),
                    title: Text(item.product.name),
                    subtitle: Text("الكمية: ${item.quantity}"),
                    trailing: Text("${(item.product.salePrice ?? 0) * item.quantity} ر.س"),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("العودة إلى المتجر"),
            ),
          ],
        ),
      ),
    );
  }
}
