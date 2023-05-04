class Products {
  final int productId;
  final String productName;
  final String productDetails;
  final double productPrice;
  final int productQuantity;
  final bool isFromCooperative;

  Products({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productDetails,
    required this.isFromCooperative,
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
