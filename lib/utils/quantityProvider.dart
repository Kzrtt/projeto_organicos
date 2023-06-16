import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  List<int> quantity;

  QuantityProvider({List<int>? initialQuantity})
      : quantity = initialQuantity ?? [];

  void decreaseQuantity(int index) {
    if (quantity[index] > 0) {
      quantity[index] -= 1;
      notifyListeners();
    }
  }

  void increaseQuantity(int index, num maxQuantity) {
    if (quantity[index] < maxQuantity) {
      quantity[index] += 1;
      notifyListeners();
    }
  }
}
