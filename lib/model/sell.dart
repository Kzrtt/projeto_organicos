class Sell {
  final String sellId;
  final List<Map<String, dynamic>> products;
  final String status;
  final Map<String, dynamic> address;
  final String sellDate;
  final String deliveryDate;
  final List<String> cooperatives;

  Sell({
    required this.address,
    required this.products,
    required this.sellId,
    required this.status,
    required this.sellDate,
    required this.cooperatives,
    required this.deliveryDate,
  });
}
