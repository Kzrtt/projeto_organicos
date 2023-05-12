import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/client/signUpScreen.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  final String _baseUrl = "http://localhost:27017/auth";

  void createClient(User user, DietType diet, BuildContext context) async {
    try {
      var response = await Dio().post(
        "$_baseUrl/sign-up",
        data: {
          "userName": user.userName,
          "userCpf": user.userCpf,
          "userEmail": user.userEmail,
          "userCell": user.userCell,
          "password": user.password,
          "isSubscriber": false,
          "isNutritionist": false,
          "diets": [diet.toString()],
        },
      );
      if (response.data['error'] == 'This user already exists') {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(response.data["error"]),
          ),
        );
      }
      print(response.data["token"]);
    } catch (e) {
      print("$e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      var response = await Dio().post(
        "$_baseUrl/authenticate/",
        data: {
          "userEmail": email,
          "password": password,
        },
      );
      if (response.data["error"] == "User not found") {
        return false;
      } else if (response.data["error"] == "Invalid password") {
        print("senha errada");
        return false;
      }
      String token = response.data["token"];
      print(token);
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
