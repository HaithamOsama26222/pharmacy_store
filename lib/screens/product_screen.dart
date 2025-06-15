import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(title: Text("المنتجات")),
      body: Center(child: Text("صفحة المنتجات")),
    );
  }
}