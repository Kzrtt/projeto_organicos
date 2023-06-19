import 'package:dio/dio.dart';
import 'package:projeto_organicos/model/adress.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:projeto_organicos/model/productInBox.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/model/sell.dart';

import 'package:projeto_organicos/utils/userState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class UserController {
  final String _userUrl = "https://api-production-696d.up.railway.app/user";
  final String _categoryUrl =
      "https://api-production-696d.up.railway.app/category";
  final String _productsUrl =
      "https://api-production-696d.up.railway.app/product";
  final String _sellUrl = "https://api-production-696d.up.railway.app/sell";
  List<Adress> _adressList = [];
  List<ClientFeedback> _feedbackList = [];
  List<Category> _categoryList = [];
  List<Products> _productList = [];
  List<Box> _boxList = [];
  Map<String, dynamic> address = {};
  List<Sell> _sells = [];
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

  Future<List<String>> getUserDiet() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().get(
        "$_userUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<String> userDiets = [];
      if (response.data.containsKey('user')) {
        for (var element in response.data['user']['diets']) {
          userDiets.add(element['_id']);
        }
      }
      return userDiets;
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

  Future<Map<String, dynamic>> searchCep(String cep) async {
    try {
      var response = await Dio().get(
        "https://viacep.com.br/ws/$cep/json/",
      );
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  void buyAgain(String sellId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().get(
        "$_sellUrl/$sellId",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('sell')) {
        try {
          List<Map<String, dynamic>> cart = [];
          List<Map<String, dynamic>> boxCart = [];
          for (var element in response.data['sell']['items']['products']) {
            cart.add({
              "productId": element['productId']['_id'],
              "quantity": element['quantity'],
            });
          }
          for (var element in response.data['sell']['items']['boxes']) {
            List<Map<String, dynamic>> produtosNaBox = [];
            for (var element2 in element['boxProducts']) {
              produtosNaBox.add({
                "productId": element2['productId'],
                "quantity": element2['quantity'],
              });
            }

            boxCart.add({
              "boxId": element['boxId']['_id'],
              "boxProducts": [...produtosNaBox],
              "quantity": 1,
            });
          }
          var response2 = await Dio().put(
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
        } catch (e, stackTrace) {
          print("erro: $e, stackTrace: $stackTrace");
        }
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

  void deleteAccount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().put(
        "$_userUrl/$id",
        data: {
          "active": false,
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

  Future<List<Box>> getAllBoxes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("userToken");
      String? id = prefs.getString("userId");
      var response = await Dio().get(
        "$_productsUrl/boxes",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('boxes')) {
        try {
          List<ProductInBox> produtos = [];
          for (var element in response.data['boxes']) {
            for (var element2 in element['products']) {
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
              id: element['_id'],
              boxDetails: element['boxDetails'],
              boxName: element['boxName'],
              boxPhoto: element['boxPhoto'],
              boxPrice: element['boxPrice'],
              boughtQuantity: 0,
              boxQuantity: element['stockQuantity'],
              produtos: produtos,
            );
            if (element['active'] == true) {
              _boxList.add(box);
            }

            produtos = [];
          }
        } catch (e, stackTrace) {
          print("erro: $e, stackTrace: $stackTrace");
        }
      }
      return _boxList;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _boxList;
    }
  }

  Future<List<Category>> getAllCategorys() async {
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

  Future<List<Sell>> getAllHistoric() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? id = prefs.getString('userId');
      var response = await Dio().get(
        _sellUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('sells')) {
        try {
          Map<String, dynamic> endereco = {};
          List<Map<String, dynamic>> produtos = [];
          List<Map<String, dynamic>> boxes = [];
          for (var element in response.data['sells']) {
            endereco = {
              "complement": element['userAddress']['complement'],
              "street": element['userAddress']['street'],
              "city": element['userAddress']['city'],
              "state": element['userAddress']['state'],
              "zipcode": element['userAddress']['zipcode'],
            };

            List<String> cooperatives = [];
            for (var element2 in element['cooperatives']) {
              cooperatives.add(element2['cooperativeName']);
            }

            for (var element3 in element['items']['products']) {
              List<String> categories = [];
              for (var e in element3['productId']['categories']) {
                categories.add(e['categoryName']);
              }
              Products product = Products(
                productId: element3['productId']['_id'],
                productName: element3['productId']['productName'],
                category: categories,
                productPhoto: element3['productId']['productPhoto'],
                productPrice: element3['productId']['productPrice'],
                stockQuantity: element3['productId']['stockQuantity'],
                unitValue: element3['productId']['unitValue'],
                productDetails: element3['productId']['productDetails'],
                cooperativeId: element3['productId']['cooperativeId'],
                producerId: element3['productId']['producerId'],
                measurementUnit: element3['productId']['measurementUnit']
                    ['measurementUnit'],
              );
              produtos.add(
                {
                  "produto": product,
                  "quantidade": element3['quantity'],
                },
              );
            }

            for (var element4 in element['items']['boxes']) {
              List<ProductInBox> products = [];
              for (var element5 in element4['boxId']['products']) {
                List<String> categorias = [];
                for (var e2 in element5['productId']['categories']) {
                  categorias.add(e2['categoryName']);
                }

                Products product = Products(
                  productId: element5['productId']['_id'],
                  productName: element5['productId']['productName'],
                  category: categorias,
                  productPhoto: element5['productId']['productPhoto'],
                  productPrice: element5['productId']['productPrice'],
                  stockQuantity: element5['productId']['stockQuantity'],
                  unitValue: element5['productId']['unitValue'],
                  productDetails: element5['productId']['productDetails'],
                  cooperativeId: element5['productId']['cooperativeId'],
                  producerId: element5['productId']['producerId'],
                  measurementUnit: element5['productId']['measurementUnit']
                      ['measurementUnit'],
                );

                ProductInBox productInBox = ProductInBox(
                  product: product,
                  quantity: element5['quantity'],
                  measurementUnity: element5['productId']['measurementUnit']
                      ['measurementUnit'],
                );

                products.add(productInBox);
              }

              Box box = Box(
                id: element4['boxId']['_id'],
                boxDetails: element4['boxId']['boxDetails'],
                boxName: element4['boxId']['boxName'],
                boxPhoto: element4['boxId']['boxPhoto'],
                boxPrice: element4['boxId']['boxPrice'],
                boxQuantity: element4['boxId']['stockQuantity'],
                boughtQuantity: element['boxId']['quantity'],
                produtos: products,
              );
              boxes.add({
                "box": box,
                "quantity": element4['quantity'],
              });
              products = [];
            }

            if (element['userId']['_id'] == id) {
              Sell sell = Sell(
                address: endereco,
                products: produtos,
                boxes: boxes,
                sellId: element['_id'],
                status: element['status'],
                sellDate: element['sellDate'],
                deliveryDate: element['deliveryDate'],
                deliveryType: element['deliveryType'],
                cooperatives: cooperatives,
              );
              _sells.add(sell);
            }
            produtos = [];
            cooperatives = [];
            boxes = [];
          }
        } catch (e, stackTrace) {
          print("erro: $e, stackTrace: $stackTrace");
        }
      }
      return _sells;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _sells;
    }
  }

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

  void setDefaultAddress(String addressId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      String? token = prefs.getString('userToken');
      var response = await Dio().put(
        "$_userUrl/set_default_address/$id",
        data: {
          "addressId": addressId,
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

  Future<List<Products>> getAllProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      var response = await Dio().get(
        "$_productsUrl/products",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<String> userDiets = await getUserDiet();
      try {
        if (response.data.containsKey('products')) {
          for (var element in response.data['products']) {
            if (element['active'] == true && element['stockQuantity'] > 0) {
              List<String> categories = [];
              List<String> productDiets = [];
              int categoryQuantity = 0;
              for (var e in element['categories']) {
                categories.add(e['categoryName']);
                categoryQuantity++;
                for (var diet in e['diets']) {
                  productDiets.add(diet);
                }
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
                measurementUnit: element['measurementUnit']['measurementUnit'],
              );
              int matchingDiets = 0;
              for (var diet in productDiets) {
                if (userDiets.contains(diet)) {
                  matchingDiets++;
                }
              }

              if (matchingDiets >= categoryQuantity) {
                _productList.add(products);
              }
            }
          }
        }
      } catch (e, stackTrace) {
        print(stackTrace);
      }
      return _productList;
    } catch (e, stackTrace) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e, stackTrace: $stackTrace');
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
}
