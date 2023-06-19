import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/user.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/userState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateUser {
  static final String key = "loggedUser";
  static final String coopKey = "loggedCooperative";

  static saveUser(User user, DateTime tokenDateLimit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      key,
      jsonEncode({
        "user": user.toJson(),
        "isAuth": true,
        "tokenDate": tokenDateLimit.toString(),
      }),
    );
  }

  static saveCooperative(
      Cooperative cooperative, DateTime tokenDateLimit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      coopKey,
      jsonEncode({
        "cooperative": cooperative.toJson(),
        "isAuth": true,
        "tokenDate": tokenDateLimit.toString(),
      }),
    );
  }

  static Future<List<dynamic>> isAuth(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonResponse = prefs.getString(key);
    String? jsonResponseCoop = prefs.getString(coopKey);
    List<dynamic> response = [];
    if (jsonResponse != null) {
      var decodedResponse = jsonDecode(jsonResponse);
      final userState = Provider.of<UserState>(
        context,
        listen: false,
      );
      userState.setUser(User.fromJson(decodedResponse['user']));
      response.add(decodedResponse['isAuth']);
      response.add('user');

      return response;
    } else if (jsonResponseCoop != null) {
      var decodedResponse = jsonDecode(jsonResponseCoop);
      final cooperativeState = Provider.of<CooperativeState>(
        context,
        listen: false,
      );
      cooperativeState.setCooperative(
        Cooperative.fromJson(decodedResponse['cooperative']),
      );
      response.add(decodedResponse['isAuth']);
      response.add('cooperative');

      return response;
    }
    return response;
  }
}
