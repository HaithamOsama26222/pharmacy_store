import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // أو الشاشة الرئيسية المناسبة لك

class OrderSuccessScreen extends StatelessWidget {
  final int orderId;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("نجاح الطلب")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              "✅ تم تنفيذ الطلب بنجاح",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "رقم الطلب: $orderId",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "طريقة الدفع: $paymentMethod",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
              },
              child: const Text("العودة إلى المتجر"),
            )
          ],
        ),
      ),
    );
  }
}
