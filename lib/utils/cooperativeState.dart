import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/model/cooperative.dart';

class CooperativeState with ChangeNotifier {
  Cooperative? cooperative;

  Cooperative? get getCooperative => cooperative;

  void setCooperative(Cooperative newCooperative) {
    cooperative = newCooperative;
    notifyListeners();
  }
}
