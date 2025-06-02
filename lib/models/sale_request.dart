import 'cart_item.dart';

class SaleRequest {
  final List<CartItem> items;
  final String paymentMethod;

  SaleRequest(this.items, {required this.paymentMethod});

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'items': items
          .map((item) => {
                'productID': item.product.productID,
                'quantity': item.quantity,
                'salePrice': item.product.salePrice,
              })
          .toList(),
    };
  }
}
