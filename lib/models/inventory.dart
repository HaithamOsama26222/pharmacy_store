class Inventory {
  final int inventoryID;
  final int productID;
  final String productName;
  final int quantityInStock;
  final int lowStockThreshold;
  final DateTime? lastUpdated;

  Inventory({
    required this.inventoryID,
    required this.productID,
    required this.productName,
    required this.quantityInStock,
    required this.lowStockThreshold,
    this.lastUpdated,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      inventoryID: json['inventoryID'] ?? 0,
      productID: json['productID'] ?? 0,
      productName: json['productName'] ?? '',
      quantityInStock: json['quantityInStock'] ?? 0,
      lowStockThreshold: json['lowStockThreshold'] ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryID': inventoryID,
      'productID': productID,
      'productName': productName,
      'quantityInStock': quantityInStock,
      'lowStockThreshold': lowStockThreshold,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}
