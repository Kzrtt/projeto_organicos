import 'package:flutter/cupertino.dart';

class GlobalVariable with ChangeNotifier {
  int _tabValue = 0;

  //getter para pegar o valor da variavel
  int get getTabValue => _tabValue;

  //setter para alterar o valor da variavel
  set tabValue(int newValue) {
    _tabValue = newValue;
    notifyListeners();
  }
}
