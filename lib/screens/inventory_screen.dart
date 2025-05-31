import 'package:flutter/material.dart';
import '../models/inventory.dart';
import '../services/inventory_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Inventory>> _inventoryFuture;

  @override
  void initState() {
    super.initState();
    _inventoryFuture = InventoryService.fetchInventories(); // ✅
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("جرد المخزون")),
      body: FutureBuilder<List<Inventory>>(
        future: _inventoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات جرد'));
          }

          final inventories = snapshot.data!;
          return ListView.builder(
            itemCount: inventories.length,
            itemBuilder: (context, index) {
              final inv = inventories[index];
              return ListTile(
                title: Text(inv.productName),
                subtitle: Text('الكمية: ${inv.quantityInStock}'),
                trailing: Text('الحد الأدنى: ${inv.lowStockThreshold}'),
              );
            },
          );
        },
      ),
    );
  }
}
