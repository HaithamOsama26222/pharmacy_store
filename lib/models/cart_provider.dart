import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    final existing = _items.firstWhere(
      (element) => element.product.productID == item.product.productID,
      orElse: () => CartItem(product: item.product, quantity: 0),
    );

    if (existing.quantity == 0) {
      _items.add(item);
    } else {
      existing.quantity += item.quantity;
    }

    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.productID == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.fold(
      0, (sum, item) => sum + (item.quantity * (item.product.salePrice ?? 0)));
}
