import 'package:flutter/material.dart';
import '../../models/inventory.dart';
import '../../services/inventory_service.dart';

class EditInventoryDialog extends StatefulWidget {
  final Inventory inventory;
  final VoidCallback onInventoryUpdated;

  const EditInventoryDialog({
    super.key,
    required this.inventory,
    required this.onInventoryUpdated,
  });

  @override
  State<EditInventoryDialog> createState() => _EditInventoryDialogState();
}

class _EditInventoryDialogState extends State<EditInventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _lowStockController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
        text: widget.inventory.quantityInStock.toString());
    _lowStockController = TextEditingController(
        text: widget.inventory.lowStockThreshold.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedInventory = Inventory(
        inventoryID: widget.inventory.inventoryID,
        productID: widget.inventory.productID,
        productName: widget.inventory.productName,
        quantityInStock: int.parse(_quantityController.text),
        lowStockThreshold: int.parse(_lowStockController.text),
      );

      await InventoryService.updateInventory(updatedInventory);

      if (!mounted) return;
      widget.onInventoryUpdated();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في التحديث: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("تعديل بيانات الجرد"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("اسم المنتج: ${widget.inventory.productName}"),
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
              : const Text("حفظ"),
        ),
      ],
    );
  }
}
