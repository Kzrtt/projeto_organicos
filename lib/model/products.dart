import 'package:projeto_organicos/model/category.dart';

class Products {
  final String productId;
  final String productName;
  final String productDetails;
  final String productPhoto;
  final double productPrice;
  final List<String> category;
  final int stockQuantity;
  final String unitValue;
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

class Box {
  final int boxId;
  final String boxName;
  final double boxPrice;
  final int quantity;
  final List<Products> products;
  final bool isFromCooperative;

  Box({
    required this.boxId,
    required this.boxName,
    required this.boxPrice,
    required this.isFromCooperative,
    required this.products,
    required this.quantity,
  });
}
