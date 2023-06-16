class Sell {
  final String sellId;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> boxes;
  final String status;
  final Map<String, dynamic> address;
  final String sellDate;
  final String deliveryDate;
  final String deliveryType;
  final List<String> cooperatives;

  Sell({
    required this.address,
    required this.products,
    required this.boxes,
    required this.sellId,
    required this.status,
    required this.sellDate,
    required this.cooperatives,
    required this.deliveryDate,
    required this.deliveryType,
  });
}
