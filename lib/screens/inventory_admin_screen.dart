import 'package:flutter/material.dart';
import '../models/inventory.dart';
import '../services/inventory_service.dart';
import '../widgets/add_inventory_dialog.dart';
import '../widgets/edit_inventory_dialog.dart';

class InventoryAdminScreen extends StatefulWidget {
  const InventoryAdminScreen({super.key});

  @override
  State<InventoryAdminScreen> createState() => _InventoryAdminScreenState();
}

class _InventoryAdminScreenState extends State<InventoryAdminScreen> {
  late Future<List<Inventory>> _inventoryFuture;

  @override
  void initState() {
    super.initState();
    _refreshInventory();
  }

  void _refreshInventory() {
    setState(() {
      _inventoryFuture = InventoryService.fetchInventories();
    });
  }

  Future<void> _confirmDelete(int inventoryId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا الصنف؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await InventoryService.deleteInventory(inventoryId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حذف الصنف")),
      );
      _refreshInventory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إدارة الجرد")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddInventoryDialog(onInventoryAdded: _refreshInventory),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Inventory>>(
        future: _inventoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد بيانات."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                title: Text(item.productName),
                subtitle: Text("الكمية: ${item.quantityInStock}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => EditInventoryDialog(
                            inventory: item,
                            onInventoryUpdated: _refreshInventory,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(item.inventoryID),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
