import 'package:projeto_organicos/model/products.dart';

class ProductInBox {
  final Products product;
  final double quantity;
  final String measurementUnity;

  const ProductInBox({
    required this.product,
    required this.quantity,
    required this.measurementUnity,
  });
}
