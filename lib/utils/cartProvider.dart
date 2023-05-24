import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/model/products.dart';

class CartProvider with ChangeNotifier {
  List<Products> produtos = [];
  List<int> quantidades = [];

  List<Products> get getCart => produtos;
  List<int> get getQuantity => quantidades;

  void setCart(List<Products> newCart) {
    produtos = newCart;
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
