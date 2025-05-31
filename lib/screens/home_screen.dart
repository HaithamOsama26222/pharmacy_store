import 'package:flutter/material.dart';
import 'package:pharmacy_store/screens/inventory_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('عرض الجرد'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InventoryScreen()),
              );
            },
          ),
          // يمكنك إضافة عناصر أخرى هنا
        ],
      ),
    );
  }
}
