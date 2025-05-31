import 'package:flutter/material.dart';
import '../../models/inventory.dart';
import '../../services/inventory_service.dart';
import '../../widgets/add_inventory_dialog.dart';

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
    _inventoryFuture = InventoryService.fetchInventories();
  }

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا الصنف؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await InventoryService.deleteInventory(id);

        if (!mounted) return; // ✅ حل التحذير الأول

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم الحذف بنجاح")),
        );

        setState(_refreshInventory);
      } catch (e) {
        if (!mounted) return; // ✅ حل التحذير الثاني

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في الحذف: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إدارة الجرد")),
      body: FutureBuilder<List<Inventory>>(
        future: _inventoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد بيانات جرد"));
          }

          final inventories = snapshot.data!;
          return ListView.builder(
            itemCount: inventories.length,
            itemBuilder: (context, index) {
              final item = inventories[index];
              return ListTile(
                title: Text(item.productName),
                subtitle: Text("الكمية: ${item.quantityInStock}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _confirmDelete(item.inventoryID),
                    ),
                    // يمكنك لاحقًا إضافة زر تعديل هنا أيضًا
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddInventoryDialog(
              onInventoryAdded: () {
                setState(_refreshInventory);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
