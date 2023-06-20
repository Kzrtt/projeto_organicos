import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/controller/producerController.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/cooperativeAdress.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:projeto_organicos/model/sell.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/box.dart';
import '../model/producers.dart';
import '../model/productInBox.dart';
import '../model/products.dart';

class CooperativeController with ChangeNotifier {
  final String _baseUrl = "https://api-production-696d.up.railway.app/auth";
  final String _cooperativeUrl =
      "https://api-production-696d.up.railway.app/cooperative";
  final String _productUrl =
      "https://api-production-696d.up.railway.app/product";
  final String _producerUrl =
      "https://api-production-696d.up.railway.app/producer";
  final String _sellUrl = "https://api-production-696d.up.railway.app/sell";
  List<Producers> _producers = [];
  List<ClientFeedback> _feedbackList = [];
  List<Sell> _sells = [];
  ProducerController producerController = ProducerController();

  CooperativeAdress adress = CooperativeAdress(
    state: "",
    street: "",
    city: "",
    zipCode: "",
    complement: "",
  );
  Cooperative cooperative = Cooperative(
    cooperativeId: "",
    cooperativeEmail: "",
    password: "",
    cooperativeName: "",
    cooperativeCnpj: "",
    cooperativeProfilePhoto: "",
    cooperativePhone: "",
    cooperativeAdress: CooperativeAdress(
      state: "",
      street: "",
      city: "",
      zipCode: "",
      complement: "",
    ),
  );

  void deleteAccount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      String? id = prefs.getString('cooperativeId');
      var response = await Dio().put(
        "$_cooperativeUrl/$id",
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

  Future<void> clearStock() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('cooperativeId');
      String? token = prefs.getString('cooperativeToken');
      var response = await Dio().put(
        "$_productUrl/reset_stock_quantity/$id",
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

  void updateStatus(String sellId, String status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      String? id = prefs.getString('cooperativeId');
      var response = await Dio().put(
        "$_sellUrl/status/$sellId",
        data: {
          "status": status,
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

  Future<List<Map<String, dynamic>>> getAllNeededProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      String? id = prefs.getString('cooperativeId');
      var response = await Dio().get(
        "$_sellUrl/list_products_by_date",
        data: {
          "cooperativeId": id,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      List<Map<String, dynamic>> productsByDate = [];
      if (response.data.containsKey('sellsByDate')) {
        response.data['sellsByDate'].forEach(
          (date, products) {
            String year = date.substring(0, 4);
            String month = date.substring(5, 7);
            String day = date.substring(8, 10);
            List<Map<String, dynamic>> produtos = [];
            print("quantidade de produtos: ${products.length}");
            products.forEach((productId, productData) {
              List<String> categorias = [];
              for (var element in productData['product']['categories']) {
                categorias.add(element['categoryName']);
              }
              Products product = Products(
                productId: productId,
                productName: productData['product']['productName'],
                category: categorias,
                productPhoto: productData['product']['productPhoto'],
                productPrice: productData['product']['productPrice'],
                stockQuantity: productData['product']['stockQuantity'],
                unitValue: productData['product']['unitValue'],
                productDetails: productData['product']['productDetails'],
                cooperativeId: productData['product']['cooperativeId'],
                producerId: productData['product']['producerId'],
                measurementUnit: productData['product']['measurementUnit']
                    ['measurementUnit'],
              );
              produtos.add({
                "product": product,
                "quantity": productData['quantity'],
              });
            });
            productsByDate.add({
              "date": "$day/$month/$year",
              "products": produtos,
            });
          },
        );
      }
      return productsByDate;
    } catch (e, stackTrace) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      throw Exception(stackTrace);
    }
  }

  Future<List<Sell>> getAllSells() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      String? id = prefs.getString('cooperativeId');
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

            List<String> cooperativesId = [];
            for (var element2 in element['cooperatives']) {
              cooperativesId.add(element2['_id']);
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
                boughtQuantity: 0,
                produtos: products,
              );
              boxes.add({
                "box": box,
                "quantity": element4['quantity'],
              });
              products = [];
            }

            if (cooperativesId.any((element) => element == id)) {
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
            cooperativesId = [];
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

  Future<List<ClientFeedback>> getAllFeedbacks(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      var response = await Dio().get(
        "$_cooperativeUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      CooperativeState cooperativeState = CooperativeState();
      if (response.data.containsKey('cooperative')) {
        for (var element in response.data['cooperative']['feedbacks']) {
          ClientFeedback f = ClientFeedback(
            id: element['_id'],
            title: element['titleFeedback'],
            response: element['response'] ?? "aguardando resposta",
            message: element['message'],
            data: element['dataFeedback'],
          );
          cooperativeState.addFeedback(f);
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
      String? token = prefs.getString('cooperativeToken');
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
        "$_cooperativeUrl/$id",
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

  void deleteProducer(String producerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? coopId = prefs.getString("cooperativeId");
      String? token = prefs.getString("cooperativeToken");
      getAllProducers().then((value) async {
        List<String> _listaDeId = value.map((e) => e.producerId).toList();
        _listaDeId.removeWhere((element) => element == producerId);
        var response = await Dio().put(
          "$_cooperativeUrl/$coopId",
          data: {
            "producers": [
              ..._listaDeId,
            ]
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        if (response.data.containsKey('cooperative')) {
          producerController
              .getAllCooperativesFromProducer(producerId)
              .then((value) async {
            List<String> listaDeIdsCooperativas = [];
            value.forEach((element) {
              listaDeIdsCooperativas.add(element.cooperativeId);
            });
            var response2 = await Dio().put(
              "$_producerUrl/$producerId",
              data: {
                "active": false,
                "cooperatives": [
                  ...listaDeIdsCooperativas,
                ]
              },
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ),
            );
            if (!response2.data.containsKey('producer')) {
              print('erro ao atualizar a lista de cooperativas');
            }
          });
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

  Future<List<Producers>> getAllProducers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("cooperativeId");
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().get(
        "$_cooperativeUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('cooperative')) {
        _producers = [];
        for (var element in response.data['cooperative']['producers']) {
          if (element['active'] == true) {
            Producers producer = Producers(
              producerId: element["_id"],
              producerName: element["producerName"],
              producerCell: element["producerCell"],
              producerCpf: element["producerCpf"],
              birthDate: element["producerBirthDate"],
            );
            _producers.add(producer);
          }
        }
        return _producers;
      } else {
        print("cooperativa não existe");
        return _producers;
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _producers;
    }
  }

  void createProducer(Producers producer, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      String? id = prefs.getString("cooperativeId");
      var response = await Dio().post(
        "$_producerUrl",
        data: {
          "producerName": producer.producerName,
          "producerEmail": Random().nextInt(100).toString(),
          "producerCpf": producer.producerCpf,
          "producerCell": producer.producerCell,
          "producerBirthDate": producer.birthDate,
          "cooperatives": id,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.data.containsKey('producer')) {
        getAllProducers().then((value) async {
          print(value.length);
          List<String> _listaDeId = [];
          if (value.isNotEmpty) {
            _listaDeId = value.map((e) => e.producerId).toList();
            print(_listaDeId.length);
          }
          _listaDeId.add(response.data['producer']['_id'].toString());
          var response2 = await Dio().put(
            "$_cooperativeUrl/$id",
            data: {
              "producers": [
                ..._listaDeId,
              ]
            },
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );
          print('atualizou a cooperativa');
        });
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

  Future<Cooperative> updateCooperativa(
    String? id,
    Cooperative newCooperativa,
    Cooperative oldCooperative,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().put(
        "$_cooperativeUrl/$id",
        data: {
          "cooperativeName": cooperative.cooperativeName.isNotEmpty
              ? cooperative.cooperativeName
              : oldCooperative.cooperativeName,
          "cooperativePhone": cooperative.cooperativePhone.isNotEmpty
              ? cooperative.cooperativePhone
              : oldCooperative.cooperativePhone,
          "cooperativeAddress": {
            "complement": cooperative.cooperativeAdress.complement.isNotEmpty
                ? cooperative.cooperativeAdress.complement
                : oldCooperative.cooperativeAdress.complement,
            "street": cooperative.cooperativeAdress.street.isNotEmpty
                ? cooperative.cooperativeAdress.street
                : oldCooperative.cooperativeAdress.street,
            "city": cooperative.cooperativeAdress.city.isNotEmpty
                ? cooperative.cooperativeAdress.city
                : oldCooperative.cooperativeAdress.city,
            "state": cooperative.cooperativeAdress.state.isNotEmpty
                ? cooperative.cooperativeAdress.state
                : oldCooperative.cooperativeAdress.state,
            "zipcode": cooperative.cooperativeAdress.zipCode.isNotEmpty
                ? cooperative.cooperativeAdress.zipCode
                : oldCooperative.cooperativeAdress.zipCode
          },
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return cooperative;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return cooperative;
    }
  }

  Future<Cooperative> getCooperative(String? id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().get(
        "$_cooperativeUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('cooperative')) {
        cooperative = Cooperative(
          cooperativeId: response.data['cooperative']['_id'],
          cooperativeEmail: response.data['cooperative']['cooperativeEmail'],
          password: "",
          cooperativeName: response.data['cooperative']['cooperativeName'],
          cooperativeCnpj: response.data['cooperative']['cooperativeCnpj'],
          cooperativeProfilePhoto: response.data['cooperative']
              ['cooperativeProfilePhoto'],
          cooperativePhone: response.data['cooperative']['cooperativePhone'],
          cooperativeAdress: CooperativeAdress(
            complement: response.data['cooperative']['cooperativeAddress']
                ['complement'],
            street: response.data['cooperative']['cooperativeAddress']
                ['street'],
            city: response.data['cooperative']['cooperativeAddress']['city'],
            state: response.data['cooperative']['cooperativeAddress']['state'],
            zipCode: response.data['cooperative']['cooperativeAddress']
                ['zipcode'],
          ),
        );
        return cooperative;
      } else {
        print("Cooperativa não existe");
        return cooperative;
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return cooperative;
    }
  }

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
          "cooperativeAddress": {
            "complement": adress.complement,
            "street": adress.street,
            "city": adress.city,
            "state": adress.state,
            "zipcode": adress.zipCode
          },
          "cooperativeProfilePhoto": "URL da foto do perfil",
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
