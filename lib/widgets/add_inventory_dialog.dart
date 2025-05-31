import 'package:flutter/material.dart';
import '../../models/inventory.dart';
import '../../services/inventory_service.dart';

class AddInventoryDialog extends StatefulWidget {
  final VoidCallback onInventoryAdded;

  const AddInventoryDialog({super.key, required this.onInventoryAdded});

  @override
  State<AddInventoryDialog> createState() => _AddInventoryDialogState();
}

class _AddInventoryDialogState extends State<AddInventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lowStockController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _productIdController.dispose();
    _quantityController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newInventory = Inventory(
        inventoryID: 0,
        productID: int.parse(_productIdController.text),
        productName: '',
        quantityInStock: int.parse(_quantityController.text),
        lowStockThreshold: int.parse(_lowStockController.text),
      );

      await InventoryService.addInventory(newInventory);

      if (!mounted) return; // ✅ لتفادي الخطأ بعد await
      widget.onInventoryAdded();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في الإضافة: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("إضافة صنف جديد"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _productIdController,
              decoration: const InputDecoration(labelText: "معرف المنتج"),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? "مطلوب" : null,
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: "الكمية المتوفرة"),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? "مطلوب" : null,
            ),
            TextFormField(
              controller: _lowStockController,
              decoration: const InputDecoration(labelText: "الحد الأدنى للجرد"),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? "مطلوب" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("إضافة"),
        ),
      ],
    );
  }
}
