class SaleSummary {
  final int saleID;
  final String date;
  final int itemCount;
  final double total;

  SaleSummary({
    required this.saleID,
    required this.date,
    required this.itemCount,
    required this.total,
  });

  factory SaleSummary.fromJson(Map<String, dynamic> json) {
    return SaleSummary(
      saleID: json['saleID'],
      date: json['date'],
      itemCount: json['itemCount'],
      total: (json['total'] as num).toDouble(),
    );
  }
}
