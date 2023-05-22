import 'package:projeto_organicos/model/productInBox.dart';

class Box {
  final String boxName;
  final String boxDetails;
  final int boxQuantity;
  final double boxPrice;
  final String boxPhoto;
  final List<ProductInBox> produtos;

  const Box({
    required this.boxDetails,
    required this.boxName,
    required this.boxPhoto,
    required this.boxPrice,
    required this.boxQuantity,
    required this.produtos,
  });
}
