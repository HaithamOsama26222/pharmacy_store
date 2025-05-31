import 'cart_item.dart';

class SaleRequest {
  final List<CartItem> items;

  SaleRequest(this.items);

  Map<String, dynamic> toJson() {
    return {
      'saleDetails': items
          .map((item) => {
                'productID': item.product.productID,
                'quantity': item.quantity,
                'price': item.product.salePrice
              })
          .toList(),
    };
  }
}
