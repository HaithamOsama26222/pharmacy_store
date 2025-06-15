import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../data/cart_data.dart'; // ⬅️ هذا للاستفادة من cartItems

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل المنتج"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // صورة المنتج أو أيقونة بديلة
            product.imageUrl != null
                ? Image.network(product.imageUrl!, height: 150)
                : const Icon(Icons.medication, size: 100, color: Colors.blue),

            const SizedBox(height: 16),
            Text(
              product.productName ?? 'اسم غير متوفر',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),
            Text("الوحدة: ${product.unit ?? '-'}"),
            Text("الكمية المتوفرة: ${product.stockQuantity ?? 0}"),
            Text(
                "سعر البيع: ${product.salePrice?.toStringAsFixed(2) ?? '-'} ر.س"),
            Text(
                "سعر الشراء: ${product.purchasePrice?.toStringAsFixed(2) ?? '-'} ر.س"),
            Text("الحد الأدنى للمخزون: ${product.minimumStock ?? 0}"),
            if (product.expiryDate != null)
              Text(
                  "تاريخ الانتهاء: ${product.expiryDate!.toLocal().toString().split(' ')[0]}"),

            const Spacer(),

            ElevatedButton.icon(
  icon: const Icon(Icons.add_shopping_cart),
  label: const Text("إضافة إلى السلة"),
  onPressed: () {
    Provider.of<CartProvider>(context, listen: false).addItem(
      CartItem(product: product, quantity: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تمت إضافة المنتج إلى السلة")),
    );
  },
)