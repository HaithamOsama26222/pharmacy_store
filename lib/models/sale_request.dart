class SaleRequest {
  final List<CartItem> items;
  final String paymentMethod;
  final int customerId;

  SaleRequest({
    required this.items,
    required this.paymentMethod,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => {
        'productID': item.product.productID,
        'quantity': item.quantity,
        'salePrice': item.product.salePrice,
      }).toList(),
    };
  }
}
