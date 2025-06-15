import 'package:flutter/material.dart';
import '../models/inventory.dart';
import '../services/inventory_service.dart';

class AddInventoryDialog extends StatefulWidget {
  final VoidCallback onInventoryAdded;

  const AddInventoryDialog({super.key, required this.onInventoryAdded});

  @override
  State<AddInventoryDialog> createState() => _AddInventoryDialogState();
}

class _AddInventoryDialogState extends State<AddInventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _productNameController = TextEditingController(); // ✅ جديد
  final _quantityController = TextEditingController();
  final _lowStockController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final inventory = Inventory(
      inventoryID: 0,
      productID: int.parse(_productIdController.text),
      productName: _productNameController.text.trim(), // ✅ مضاف فعليًا
      quantityInStock: int.parse(_quantityController.text),
      lowStockThreshold: int.parse(_lowStockController.text),
      lastUpdated: DateTime.now(),
    );

    setState(() => _isLoading = true);
    final success = await InventoryService.addInventory(inventory);
    setState(() => _isLoading = false);

    if (success && mounted) {
      widget.onInventoryAdded();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل في إضافة الصنف")),
      );
    }
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("إضافة صنف جديد"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _productIdController,
                decoration: const InputDecoration(labelText: "رقم المنتج"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: "اسم المنتج"), // ✅ جديد
                validator: (v) => v == null || v.trim().isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: "الكمية"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lowStockController,
                decoration: const InputDecoration(labelText: "حد التنبيه الأدنى"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "مطلوب" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text("إضافة"),
        ),
      ],
    );
  }
}
