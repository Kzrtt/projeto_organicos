import 'package:projeto_organicos/model/productInBox.dart';

class Box {
  final String id;
  final String boxName;
  final String boxDetails;
  final num boxQuantity;
  final num boxPrice;
  final String boxPhoto;
  final int boughtQuantity;
  final List<ProductInBox> produtos;

  const Box({
    required this.id,
    required this.boxDetails,
    required this.boxName,
    required this.boxPhoto,
    required this.boxPrice,
    required this.boxQuantity,
    required this.boughtQuantity,
    required this.produtos,
  });
}
