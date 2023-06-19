import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:projeto_organicos/model/products.dart';

class CartProvider with ChangeNotifier {
  CartController controller = CartController();
  List<Products> produtos = [];
  List<int> quantidades = [];
  List<int> boxQuantity = [];

  List<Products> get getCart => produtos;
  List<int> get getQuantity => quantidades;
  List<int> get getBoxQuantity => boxQuantity;

  void setCart(List<Products> newCart) {
    produtos = newCart;
    notifyListeners();
  }

  void setBoxQuantities(List<int> newQuantities) {
    boxQuantity = newQuantities;
    notifyListeners();
  }

  void setQuantity(List<int> newQuantity) {
    quantidades = newQuantity;
    notifyListeners();
  }

  void addProduct(Products product, int quantity) {
    if (produtos.any((element) => element.productId == product.productId)) {
      int index = 0;
      for (var i = 0; i < produtos.length; i++) {
        if (produtos[i].productId == product.productId) {
          index = i;
        }
      }
      quantidades[index] = quantidades[index] + quantity;
      notifyListeners();
    } else {
      produtos.add(product);
      quantidades.add(quantity);
      notifyListeners();
    }
  }

  void removeProduct(Products products) {
    int index = produtos.indexOf(products);
    produtos.removeAt(index);
    quantidades.removeAt(index);
    notifyListeners();
  }
}
