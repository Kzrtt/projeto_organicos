class Sell {
  final String sellId;
  final List<Map<String, dynamic>> products;
  final String status;
  final Map<String, dynamic> address;
  final String sellDate;

  Sell({
    required this.address,
    required this.products,
    required this.sellId,
    required this.status,
    required this.sellDate,
  });
}
