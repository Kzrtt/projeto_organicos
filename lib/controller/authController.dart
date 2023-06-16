import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/utils/authenticateUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class AuthController {
  final String _baseUrl = "https://api-production-696d.up.railway.app/auth";

  void createClient(User user, String dietType, BuildContext context) async {
    try {
      var response = await Dio().post(
        "$_baseUrl/sign_up",
        data: {
          "userName": user.userName,
          "userCpf": user.userCpf,
          "userEmail": user.userEmail,
          "userCell": user.userCell,
          "password": user.password,
          "userBirthDate": user.birthdate,
          "isSubscriber": false,
          "isNutritionist": false,
          "diets": dietType,
        },
      );
      if (response.data.containsKey('error')) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(response.data["error"]),
          ),
        );
      } else if (response.data.containsKey('token')) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Usuário cadastrado com sucesso!"),
          ),
        );
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
    }
  }

  Future<String> login(
      String email, String password, BuildContext context) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      var response = await Dio().post(
        "$_baseUrl/authenticate/",
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.data["error"] == "User not found") {
        return "erro";
      } else if (response.data["error"] == "Invalid password") {
        print("senha errada");
        return "erro";
      }
      if (response.data.containsKey('user')) {
        String userToken = response.data["token"];
        String userId = response.data['user']['_id'];
        await _prefs.setString("userToken", userToken);
        await _prefs.setString("userId", userId);
        return "telaCliente";
      } else if (response.data.containsKey('cooperative')) {
        String cooperativeToken = response.data["token"];
        String cooperativeId = response.data['cooperative']['_id'];
        await _prefs.setString("cooperativeToken", cooperativeToken);
        await _prefs.setString("cooperativeId", cooperativeId);
        return "telaCooperativa";
      }
      print(response.data);
      return "erro";
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return "erro";
    }
  }
}
