import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  final String userName;
  final String userCpf;
  final String userEmail;
  final String userCell;
  final String password;
  final String birthdate;
  final bool isSubscriber;
  final bool isNutritious;
  List<String> diets;
  List<String> adresses;
  List<String> feedbacks;

  User({
    required this.userName,
    required this.userCpf,
    required this.userEmail,
    required this.userCell,
    required this.password,
    required this.birthdate,
    required this.isSubscriber,
    required this.isNutritious,
    this.adresses = const [],
    this.diets = const [],
    this.feedbacks = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userCpf': userCpf,
      'userEmail': userEmail,
      'userCell': userCell,
      'password': password,
      'birthdate': birthdate,
      'isSubscriber': isSubscriber,
      'isNutritious': isNutritious,
      'diets': diets,
      'adresses': adresses,
      'feedbacks': feedbacks,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      userCpf: json['userCpf'],
      userEmail: json['userEmail'],
      userCell: json['userCell'],
      password: json['password'],
      birthdate: json['birthdate'],
      isSubscriber: json['isSubscriber'],
      isNutritious: json['isNutritious'],
      diets: List<String>.from(json['diets']),
      adresses: List<String>.from(json['adresses']),
      feedbacks: List<String>.from(json['feedbacks']),
    );
  }
}
