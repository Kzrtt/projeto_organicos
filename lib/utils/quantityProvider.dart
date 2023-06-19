import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  List<int> quantity;
  int boxQuantity;

  QuantityProvider({List<int>? initialQuantity, int? initialBoxQuantity})
      : quantity = initialQuantity ?? [],
        boxQuantity = initialBoxQuantity ?? 0;

  void decreaseBoxQuantity() {
    if (boxQuantity > 0) {
      boxQuantity -= 1;
      notifyListeners();
    }
  }

  void increaseBoxQuantity(num maxQuantity) {
    if (boxQuantity < maxQuantity) {
      boxQuantity += 1;
      notifyListeners();
    }
  }

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
