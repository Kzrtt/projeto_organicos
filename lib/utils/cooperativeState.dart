import 'package:flutter/cupertino.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:projeto_organicos/model/producers.dart';

class CooperativeState with ChangeNotifier {
  Cooperative? cooperative;
  List<Producers> producerList = [];
  List<ClientFeedback> feedbacks = [];

  Cooperative? get getCooperative => cooperative;

  void setFeedbackList(List<ClientFeedback> aL) {
    feedbacks = aL;
    notifyListeners();
  }

  void addFeedback(ClientFeedback feedback) {
    feedbacks.add(feedback);
    notifyListeners();
  }

  void setProducerList(List<Producers> producers) {
    producerList = producers;
    notifyListeners();
  }

  void setCooperative(Cooperative newCooperative) {
    cooperative = newCooperative;
    notifyListeners();
  }
}
