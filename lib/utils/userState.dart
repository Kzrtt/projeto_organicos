import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/model/user.dart';

class UserState with ChangeNotifier {
  User? user;

  User? get getUser => user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}
