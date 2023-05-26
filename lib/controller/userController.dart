import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/adress.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/screens/client/signUpScreen.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/userState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class UserController {
  final String _baseUrl = "http://localhost:27017/auth";
  final String _userUrl = "http://localhost:27017/user";
  final String _categoryUrl = "http://localhost:27017/category";
  final String _productsUrl = "http://localhost:27017/product/products";
  List<Adress> _adressList = [];
  List<ClientFeedback> _feedbackList = [];
  List<Category> _categoryList = [];
  List<Products> _productList = [];
  Map<String, dynamic> address = {};

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

  Future<Map<String, dynamic>> getAddress(String addressId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      List<Adress> addresses = await getAllAdresses(id!);
      for (var element in addresses) {
        if (element.adressId == addressId) {
          address.addAll({
            "complement": element.complement,
            "street": element.street,
            "city": element.city,
            "state": element.state,
            "zipcode": element.zipCode,
          });
        }
      }
      return address;
    } catch (e) {
      print('erro: $e');
      return address;
    }
  }

  void setDefaultAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
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

  Future<List<Products>> getAllProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      var response = await Dio().get(
        _productsUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('products')) {
        for (var element in response.data['products']) {
          if (element['active'] == true) {
            List<String> categories = [];
            for (var e in element['categories']) {
              categories.add(e['categoryName']);
            }
            Products products = Products(
              productId: element['_id'],
              productName: element['productName'],
              category: categories,
              productPhoto: element['productPhoto'],
              productPrice: element['productPrice'],
              stockQuantity: element['stockQuantity'],
              unitValue: element['unitValue'],
              productDetails: element['productDetails'],
              cooperativeId: element['cooperativeId'],
              producerId: element['producerId'],
              measuremntUnit: element['measurementUnit']['measurementUnit'],
            );
            _productList.add(products);
          }
        }
      }
      return _productList;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _productList;
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("userToken");
      var response = await Dio().get(
        _categoryUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('categories')) {
        var categories = response.data['categories'];
        for (var element in categories) {
          Category category = Category(
            active: element['active'],
            categoryId: element['_id'],
            categoryName: element['categoryName'],
          );
          _categoryList.add(category);
        }
        return _categoryList;
      } else {
        print('erro');
        return _categoryList;
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _categoryList;
    }
  }

  Future<List<ClientFeedback>> getAllFeedbacks(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      UserState userState = UserState();
      if (response.data.containsKey('user')) {
        for (var element in response.data['user']['feedbacks']) {
          ClientFeedback f = ClientFeedback(
            id: element['_id'],
            title: element['titleFeedback'],
            response: element['response'] ?? "aguardando resposta",
            message: element['message'],
            data: element['dataFeedback'],
          );
          userState.addFeedback(f);
          _feedbackList.add(f);
          print(_feedbackList.length);
        }
      }
      return _feedbackList;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _feedbackList;
    }
  }

  void createFeedback(String message, String title, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      final List<ClientFeedback> e = await getAllFeedbacks(id);
      List<Map<String, dynamic>> listaDeJson = e
          .map((objeto) => {
                'titleFeedback': objeto.title,
                'dataFeedback': objeto.data,
                'message': objeto.message,
                '_id': objeto.id,
              })
          .toList();
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "feedbacks": [
            ...listaDeJson,
            {
              'titleFeedback': title,
              'dataFeedback': DateTime.now().toString().substring(0, 10),
              'message': message,
            },
          ]
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
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

  void deleteAdress(String id, String idToBeDeleted) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("userToken");
      final List<Adress> e = await getAllAdresses(id);
      e.removeWhere((element) => element.adressId == idToBeDeleted);
      List<Map<String, dynamic>> listaDeJson = e
          .map((objeto) => {
                'nickname': objeto.nickname,
                'complement': objeto.complement,
                'street': objeto.street,
                'city': objeto.city,
                'state': objeto.state,
                'zipcode': objeto.zipCode,
              })
          .toList();
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "addresses": [...listaDeJson]
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
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

  Future<List<Adress>> getAllAdresses(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("userToken");
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      UserState userState = UserState();
      if (response.data.containsKey('user')) {
        for (var element in response.data['user']['addresses']) {
          Adress a = Adress(
            nickname: element['nickname'],
            complement: element['complement'],
            street: element['street'],
            city: element['city'],
            state: element['state'],
            zipCode: element['zipcode'],
            adressId: element['_id'],
            isDefault: element['isDefault'],
          );
          userState.addAdress(a);
          _adressList.add(a);
        }
      }
      return _adressList;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _adressList;
    }
  }

  void createAdress(Adress adress, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      final List<Adress> e = await getAllAdresses(id);
      List<Map<String, dynamic>> listaDeJson = e
          .map((objeto) => {
                'nickname': objeto.nickname,
                'complement': objeto.complement,
                'street': objeto.street,
                'city': objeto.city,
                'state': objeto.state,
                'zipcode': objeto.zipCode,
              })
          .toList();
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "addresses": [
            ...listaDeJson,
            {
              "nickname": adress.nickname,
              "complement": adress.complement,
              "street": adress.street,
              "city": adress.city,
              "state": adress.state,
              "zipcode": adress.zipCode
            }
          ]
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (!response.data.containsKey('user')) {
        print('usuário não existe');
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
