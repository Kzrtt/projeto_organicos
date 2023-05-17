import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:projeto_organicos/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/adress.dart';

class UserState with ChangeNotifier {
  User? user;
  List<Adress> adressList = [];
  List<ClientFeedback> feedbacks = [];

  User? get getUser => user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  void setFeedbackList(List<ClientFeedback> aL) {
    feedbacks = aL;
    notifyListeners();
  }

  void addFeedback(ClientFeedback feedback) {
    feedbacks.add(feedback);
    notifyListeners();
  }

  void setAdressList(List<Adress> aL) {
    adressList = aL;
    notifyListeners();
  }

  void removeAdress(String id) {
    adressList.removeWhere((element) => element.adressId == id);
    notifyListeners();
  }

  void addAdress(Adress adress) {
    adressList.add(adress);
    notifyListeners();
  }
}
