import 'package:dio/dio.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/screens/client/productScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_organicos/controller/userController.dart';

import '../model/user.dart';

class CartController {
  final String _userUrl = "http://localhost:27017/user";
  final String _sellUrl = "http://localhost:27017/sell";

  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> cartProductsInfo = [];

  void emptyCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": [],
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

  void createSell(String addressId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      UserController controller = UserController();
      List<Map<String, dynamic>> products = await getAllProductsFromCart();
      Map<String, dynamic> address = await controller.getAddress(addressId);
      var response = await Dio().post(
        '$_sellUrl',
        data: {
          "userAddress": address,
          "userId": id,
          "products": [...products],
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('sell')) {
        emptyCart();
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

  void incrementOrSubtractQuantity(Products product, String operation) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> userCart = await getAllProductsFromCart();
      if (operation == "+") {
        userCart.firstWhere((element) =>
                element['productId']['_id'] == product.productId)['quantity'] +=
            product.unitValue;
      } else if (operation == "-") {
        userCart.firstWhere((element) =>
                element['productId']['_id'] == product.productId)['quantity'] -=
            product.unitValue;
      }
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": [
            ...cart,
          ],
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

  Future<List<Map<String, dynamic>>> getAllProductsInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      var response = await Dio().get(
        "$_userUrl/cart/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('cart')) {
        try {
          if (response.data['cart'].isNotEmpty) {
            for (var element in response.data['cart']) {
              List<String> categories = [];
              for (var e in element['productId']['categories']) {
                categories.add(e['categoryName']);
              }
              Products product = Products(
                productId: element['productId']['_id'],
                productName: element['productId']['productName'],
                category: categories,
                productPhoto: element['productId']['productPhoto'],
                productPrice: element['productId']['productPrice'],
                stockQuantity: element['productId']['stockQuantity'],
                unitValue: element['productId']['unitValue'],
                productDetails: element['productId']['productDetails'],
                cooperativeId: element['productId']['cooperativeId'],
                producerId: element['productId']['producerId'],
                measuremntUnit: element['productId']['measurementUnit']
                    ['measurementUnit'],
              );
              cartProductsInfo.add({
                "product": product,
                "quantity": element['quantity'],
              });
            }
          }
        } catch (e, stackTrace) {
          print("erro: $e, stackTrace: $stackTrace");
        }
        return cartProductsInfo;
      }
      return cartProductsInfo;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return cartProductsInfo;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProductsFromCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        if (response.data['user']['cart'] != null) {
          for (var element in response.data['user']['cart']) {
            cart.add({
              "productId": element['productId'],
              "quantity": element['quantity'],
            });
          }
        }
        return cart;
      }
      return cart;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return cart;
    }
  }

  void removeProductFromCart(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> cart = await getAllProductsFromCart();
      cart.removeWhere((element) => element['productId']['_id'] == productId);
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": [
            ...cart,
          ],
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

  void addProductToCart(String productId, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      List<Map<String, dynamic>> cart = await getAllProductsFromCart();

      bool productExistsInCart =
          cart.any((element) => element['productId'] == productId);
      if (productExistsInCart) {
        cart.firstWhere(
                (element) => element['productId'] == productId)['quantity'] +=
            quantity;
      } else {
        cart.add({
          "productId": productId,
          "quantity": quantity,
        });
      }

      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": [
            ...cart,
          ],
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (!response.data.containsKey('user')) {
        print('erro');
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
}
