import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/client/signUpScreen.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  final String _baseUrl = "http://localhost:27017/auth";
  final String _userUrl = "http://localhost:27017/user";
  User user = User(
    userName: "",
    userCpf: "",
    userEmail: "",
    userCell: "",
    password: "",
    birthdate: "",
    isSubscriber: false,
    isNutritious: false,
  );

  Future<User> updateClient(String? id, User user, User oldUser) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "userName":
              user.userName.isNotEmpty ? user.userName : oldUser.userName,
          "userCpf": user.userCpf.isNotEmpty ? user.userCell : oldUser.userCpf,
          "userCell":
              user.userCell.isNotEmpty ? user.userCell : oldUser.userCell,
          "userBirthDate":
              user.birthdate.isNotEmpty ? user.birthdate : oldUser.birthdate,
          "isSubscriber": false,
          "isNutritionist": false,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        user = User(
          userName: response.data['user']['userName'],
          userCpf: response.data['user']['userCpf'],
          userEmail: response.data['user']['userEmail'],
          userCell: response.data['user']['userCell'],
          password: "",
          birthdate: response.data['user']['userBirthDate'],
          isSubscriber: response.data['user']['isSubscriber'],
          isNutritious: response.data['user']['isNutritionist'],
        );
        return user;
      } else {
        print("erro ao atualizar o usuario");
        return user;
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return user;
    }
  }

  Future<User> getClient(String? id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        user = User(
          userName: response.data['user']['userName'],
          userCpf: response.data['user']['userCpf'],
          userEmail: response.data['user']['userEmail'],
          userCell: response.data['user']['userCell'],
          password: "",
          birthdate: response.data['user']['userBirthDate'],
          isSubscriber: response.data['user']['isSubscriber'],
          isNutritious: response.data['user']['isNutritionist'],
        );
        return user;
      } else {
        print('Usuario não existe');
      }
      return user;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return user;
    }
  }

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
