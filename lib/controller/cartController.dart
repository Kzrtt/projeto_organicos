import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/screens/client/productScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_organicos/controller/userController.dart';

import '../model/productInBox.dart';
import '../model/user.dart';

class CartController {
  final String _userUrl = "https://api-production-696d.up.railway.app/user";
  // final String _userUrl = "http://192.168.1.159:27017/user";
  final String _sellUrl = "https://api-production-696d.up.railway.app/sell";

  Future<void> emptyCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": {
            "products": [],
            "boxes": [],
          },
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

  Future<bool> createSell(
    String addressId,
    String deliveryDate,
    String deliveryType,
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      UserController controller = UserController();
      List<Map<String, dynamic>> products = await getAllProductsFromCart();
      List<Map<String, dynamic>> boxes = await getAllBoxesFromCart();
      Map<String, dynamic> address = await controller.getAddress(addressId);
      var response = await Dio().post(
        '$_sellUrl',
        data: {
          "userAddress": address,
          "userId": id,
          "items": {
            "products": [...products],
            "boxes": [...boxes],
          },
          "deliveryDate": deliveryDate,
          "deliveryType": deliveryType,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      emptyCart();
      if (response.data.containsKey('sell')) {
        return true;
      } else {
        return false;
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
    return false;
  }

  void incrementOrSubtractBoxQuantity(Box box, String operation) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> userCart = await getAllProductsFromCart();
      List<Map<String, dynamic>> boxCart = await getAllBoxesFromCart();
      if (operation == "+") {
        boxCart.firstWhere(
            (element) => element['boxId'] == box.id)['quantity'] += 1;
      } else if (operation == "-") {
        boxCart.firstWhere(
            (element) => element['boxId'] == box.id)['quantity'] -= 1;
      }
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": {
            "products": [...userCart],
            "boxes": [...boxCart],
          },
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

  void incrementOrSubtractQuantity(Products product, String operation) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> userCart = await getAllProductsFromCart();
      List<Map<String, dynamic>> boxCart = await getAllBoxesFromCart();
      if (operation == "+") {
        userCart.firstWhere((element) =>
            element['productId']['_id'] == product.productId)['quantity'] += 1;
      } else if (operation == "-") {
        userCart.firstWhere((element) =>
            element['productId']['_id'] == product.productId)['quantity'] -= 1;
      }
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": {
            "products": [...userCart],
            "boxes": [...boxCart],
          },
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
      List<Map<String, dynamic>> cartProductsInfo = [];
      var response = await Dio().get(
        "$_userUrl/cart/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('cart')) {
        try {
          if (response.data['cart']['products'].isNotEmpty) {
            for (var element in response.data['cart']['products']) {
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
                measurementUnit: element['productId']['measurementUnit']
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
      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllBoxesInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      List<Map<String, dynamic>> boxCartInfo = [];
      var response = await Dio().get(
        "$_userUrl/cart/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('cart')) {
        try {
          if (response.data['cart']['boxes'].isNotEmpty) {
            for (var element in response.data['cart']['boxes']) {
              List<ProductInBox> produtos = [];
              for (var element2 in element['boxId']['products']) {
                List<String> categories = [];
                for (var e in element2['productId']['categories']) {
                  categories.add(e['categoryName']);
                }
                Products product = Products(
                  productId: element2['productId']['_id'],
                  productName: element2['productId']['productName'],
                  category: categories,
                  productPhoto: element2['productId']['productPhoto'],
                  productPrice: element2['productId']['productPrice'],
                  stockQuantity: element2['productId']['stockQuantity'],
                  unitValue: element2['productId']['unitValue'],
                  productDetails: element2['productId']['productDetails'],
                  cooperativeId: element2['productId']['cooperativeId'],
                  producerId: element2['productId']['producerId'],
                  measurementUnit: element2['productId']['measurementUnit']
                      ['measurementUnit'],
                );
                ProductInBox productInBox = ProductInBox(
                  product: product,
                  quantity: element2['quantity'],
                  measurementUnity: element2['productId']['measurementUnit']
                      ['measurementUnit'],
                );
                produtos.add(productInBox);
              }

              Box box = Box(
                id: element['boxId']['_id'],
                boxDetails: element['boxId']['boxDetails'],
                boxName: element['boxId']['boxName'],
                boxPhoto: element['boxId']['boxPhoto'],
                boxPrice: element['boxId']['boxPrice'],
                boxQuantity: element['boxId']['stockQuantity'],
                boughtQuantity: element['quantity'],
                produtos: produtos,
              );
              boxCartInfo.add({
                "box": box,
                "boxInCartId": element['_id'],
                "quantity": box.boughtQuantity,
              });
              produtos = [];
            }
          }
        } catch (e, stackTrace) {
          print("erro: $e, stackTrace: $stackTrace");
        }
        return boxCartInfo;
      }
      return boxCartInfo;
    } catch (e, stackTrace) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e, $stackTrace');
      }
      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllProductsFromCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      List<Map<String, dynamic>> cart = [];
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        if (response.data['user']['cart'] != null) {
          for (var element in response.data['user']['cart']['products']) {
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
      throw Exception(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllBoxesFromCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      List<Map<String, dynamic>> boxCart = [];
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        if (response.data['user']['cart'] != null) {
          for (var element in response.data['user']['cart']['boxes']) {
            List<Map<String, dynamic>> productsInBox = [];
            for (var element2 in element['boxProducts']) {
              productsInBox.add({
                "productId": element2['productId'],
                "quantity": element2['quantity'],
              });
            }
            boxCart.add({
              "boxId": element['boxId']['_id'],
              "boxProducts": [...productsInBox],
              "quantity": element['quantity'],
            });
            productsInBox = [];
          }
        }
        return boxCart;
      }
      return boxCart;
    } catch (e, stackTrace) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e, $stackTrace');
      }
      throw Exception(e);
    }
  }

  void removeProductFromCart(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> cart = await getAllProductsFromCart();
      List<Map<String, dynamic>> boxCart = await getAllBoxesFromCart();
      cart.removeWhere((element) => element['productId']['_id'] == productId);
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": {
            "products": [...cart],
            "boxes": [...boxCart],
          },
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

  Future<void> updateBoxValues(
    Box box,
    List<Map<String, dynamic>> produtos,
    int quantity,
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      List<Map<String, dynamic>> boxCart = [];
      List<Map<String, dynamic>> cart = [];

      await removeBoxFromCart(box.id).then((value) async {
        boxCart = await getAllBoxesFromCart();
        cart = await getAllProductsFromCart();
      });

      //limpa o carrinho
      await emptyCart().then((value) async {
        List<Map<String, dynamic>> produtosNaBox = [];
        for (var element in produtos) {
          produtosNaBox.add({
            "productId": element['productId'],
            "quantity": element['quantity'],
          });
        }

        //adiciona a nova box ao carrinho
        boxCart.add({
          "boxId": box.id,
          "boxProducts": [...produtosNaBox],
          "quantity": quantity,
        });

        var response = await Dio().put(
          "$_userUrl/$id",
          data: {
            "cart": {
              "boxes": [...boxCart],
              "products": [...cart],
            },
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        if (response.data.containsKey('user')) {
          print('adicionou os valores ao carrinho');
        }
      });
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

  bool hasSameProductQuantities(
      Map<String, dynamic> boxX, List<Map<String, dynamic>> boxYProducts) {
    var boxXProducts = boxX['boxProducts'];

    if (boxXProducts.length != boxYProducts.length) {
      return false;
    }

    for (var i = 0; i < boxXProducts.length; i++) {
      var productX = boxXProducts[i];
      var productY = boxYProducts[i];

      var quantityX = productX['quantity'];
      var quantityY = productY['quantity'];

      if (quantityX != quantityY) {
        return false;
      }
    }

    return true;
  }

  Future<void> increaseQuantity(Box box, int newQuantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> boxCart = await getAllBoxesFromCart();
      List<Map<String, dynamic>> cart = await getAllProductsFromCart();

      Map<String, dynamic> boxX =
          boxCart.singleWhere((element) => element['boxId'] == box.id);
      boxX['quantity'] = newQuantity;

      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": {
            "boxes": [...boxCart],
            "products": [...cart],
          },
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        print('sucesso');
      }
    } catch (e, stackTrace) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e, $stackTrace');
      }
    }
  }

  Future<void> removeBoxFromCart(String boxId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().get(
        "$_userUrl/cart/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List<Map<String, dynamic>> newBoxCart = [];
      List<Map<String, dynamic>> productsCart = await getAllProductsFromCart();

      emptyCart().then((value) async {
        if (response.data.containsKey('cart')) {
          for (var element in response.data['cart']['boxes']) {
            if (element['_id'] != boxId) {
              List<Map<String, dynamic>> productsInBox = [];
              for (var element2 in element['boxProducts']) {
                productsInBox.add({
                  "productId": element2['productId'],
                  "quantity": element2['quantity'],
                });
              }
              newBoxCart.add({
                "boxId": element['boxId']['_id'],
                "boxProducts": [...productsInBox],
                "quantity": element['quantity'],
              });

              productsInBox = [];
            } else {}
          }
          var response2 = await Dio().put(
            "$_userUrl/$id",
            data: {
              "cart": {
                "products": [...productsCart],
                "boxes": [...newBoxCart],
              },
            },
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );
        }
      });
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

  Future<void> addBoxToCart(
    Box box,
    List<Map<String, dynamic>> produtos,
    int quantity,
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      List<Map<String, dynamic>> boxCart = await getAllBoxesFromCart();
      List<Map<String, dynamic>> cart = await getAllProductsFromCart();
      List<Map<String, dynamic>> produtosNaBox = [];

      if (boxCart.any((element) => element['boxId'] == box.id)) {
        Map<String, dynamic> boxX =
            boxCart.singleWhere((element) => element['boxId'] == box.id);
        if (hasSameProductQuantities(boxX, produtos)) {
          boxCart.removeWhere((element) => element['boxId'] == box.id);
          for (var element in produtos) {
            produtosNaBox.add({
              "productId": element['productId'],
              "quantity": element['quantity'],
            });
          }

          boxCart.add({
            "boxId": box.id,
            "boxProducts": [...produtosNaBox],
            "quantity": boxX['quantity'] + 1,
          });
        } else {
          for (var element in produtos) {
            produtosNaBox.add({
              "productId": element['productId'],
              "quantity": element['quantity'],
            });
          }

          boxCart.add({
            "boxId": box.id,
            "boxProducts": [...produtosNaBox],
            "quantity": quantity,
          });
        }
      } else {
        for (var element in produtos) {
          produtosNaBox.add({
            "productId": element['productId'],
            "quantity": element['quantity'],
          });
        }

        boxCart.add({
          "boxId": box.id,
          "boxProducts": [...produtosNaBox],
          "quantity": quantity,
        });
      }

      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "cart": {
            "boxes": [...boxCart],
            "products": [...cart],
          },
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('user')) {
        produtosNaBox = [];
        print('sucesso');
      }
    } catch (e, stackTrace) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e, $stackTrace');
      }
    }
  }

  Future<void> addProductToCart(String productId, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      List<Map<String, dynamic>> cart = await getAllProductsFromCart();
      List<Map<String, dynamic>> boxCart = await getAllBoxesFromCart();

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
          "cart": {
            "products": [...cart],
            "boxes": [...boxCart],
          },
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
