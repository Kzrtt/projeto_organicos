import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/cooperativeAdress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CooperativeProvider with ChangeNotifier {
  final String _baseUrl = "http://localhost:27017/auth";

  void createCooperative(
    Cooperative cooperative,
    CooperativeAdress adress,
    BuildContext context,
  ) async {
    try {
      var response = await Dio().post(
        "$_baseUrl/sign_up",
        data: {
          "cooperativeName": cooperative.cooperativeName,
          "cooperativeEmail": cooperative.cooperativeEmail,
          "cooperativeCnpj": cooperative.cooperativeCnpj,
          "cooperativePhone": cooperative.cooperativePhone,
          "coopeartiveAdress": {
            "complement": adress.complement,
            "street": adress.street,
            "state": adress.state,
            "city": adress.city,
            "zipcode": adress.zipCode
          },
          "cooperativeProfilePhoto": cooperative.cooperativeProfilePhoto,
          "password": cooperative.password,
        },
      );
      if (response.data['error'] == 'This cooperative already exists') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(response.data["error"]),
          ),
        );
      }
      print(response.data['token']);
    } catch (e) {
      print('$e');
      return null;
    }
  }
}
