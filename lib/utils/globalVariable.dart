import 'package:flutter/cupertino.dart';

class GlobalVariable with ChangeNotifier {
  int _tabValue = 0;
  int _producerTabValue = 0;

  //getter para pegar o valor da variavel
  int get getTabValue => _tabValue;
  int get getProducerTabValue => _producerTabValue;

  //setter para alterar o valor da variavel
  set tabValue(int newValue) {
    _tabValue = newValue;
    notifyListeners();
  }

  set tabProducerValue(int newValue) {
    _producerTabValue = newValue;
    notifyListeners();
  }
}
