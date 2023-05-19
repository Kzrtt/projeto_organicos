import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/producers.dart';

class CooperativeState with ChangeNotifier {
  Cooperative? cooperative;
  List<Producers> producerList = [];

  Cooperative? get getCooperative => cooperative;

  void setProducerList(List<Producers> producers) {
    producerList = producers;
    notifyListeners();
  }

  void setCooperative(Cooperative newCooperative) {
    cooperative = newCooperative;
    notifyListeners();
  }
}
