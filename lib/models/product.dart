class Product {
  final int productID;
  final String? productName;
  final String? unit;
  final int? stockQuantity;
  final double? purchasePrice;
  final double? salePrice;
  final DateTime? expiryDate;
  final int? minimumStock;
  final String? imageUrl;

  Product({
    required this.productID,
    this.productName,
    this.unit,
    this.stockQuantity,
    this.purchasePrice,
    this.salePrice,
    this.expiryDate,
    this.minimumStock,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'],
      productName: json['productName'],
      unit: json['unit'],
      stockQuantity: json['stockQuantity'],
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      minimumStock: json['minimumStock'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'productName': productName,
      'unit': unit,
      'stockQuantity': stockQuantity,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'expiryDate': expiryDate?.toIso8601String(),
      'minimumStock': minimumStock,
      'imageUrl': imageUrl,
    };
  }
}
