import 'package:projeto_organicos/model/category.dart';

class Products {
  final String productId;
  final String productName;
  final String productDetails;
  final String productPhoto;
  final num productPrice;
  final List<String> category;
  final num stockQuantity;
  final int unitValue;
  final String measuremntUnit;
  final String cooperativeId;
  final String producerId;

  Products({
    required this.productId,
    required this.productName,
    required this.category,
    required this.productPhoto,
    required this.productPrice,
    required this.stockQuantity,
    required this.unitValue,
    required this.productDetails,
    required this.cooperativeId,
    required this.producerId,
    required this.measuremntUnit,
  });
}
