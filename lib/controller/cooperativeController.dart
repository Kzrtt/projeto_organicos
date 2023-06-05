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
  final String _baseUrl = "http://192.168.1.159:27017/auth";
  final String _cooperativeUrl = "http://192.168.1.159:27017/cooperative";
  final String _producerUrl = "http://192.168.1.159:27017/producer";
  final String _sellUrl = "http://192.168.1.159:27017/sell";
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

  Future<List<Map<String, dynamic>>> getAllProductsFromSells() async {
    try {
      /**
       * "produto": instancia de produto
       * "quantidade": quantidade que tem 
       * "data": unidade de medida
       * ==================================
       * - Verificar todas as vendas
       * - Ver se a produto ja existe na lista
       *    ? aumentar a quantidade 
       *    : adicionar ele na lista
       * - Ver os produtos dentro da box estão dentro da lista
       *    ? aumentar a quantidade
       *    : adicionar na lista
       * -Verificar se os produtos tem a mesma data de entrega
       * ==================================
       * - for(produto in listaDeVendas)
       * - if(produto in newList)
       * - for(boxes in listaDeVendas)
       * - for(products in box)
       * - if(produto in newList) 
      */
      List<Map<String, dynamic>> newList = [];
      List<Sell> sells = await getAllSells();
      for (var venda in sells) {
        if (venda.products.isNotEmpty) {
          for (var product in venda.products) {
            if (newList.any((element) =>
                element['produto'].productId == product['produto'].productId)) {
              if (venda.deliveryDate ==
                  newList.firstWhere((element) =>
                      element['produto'].productId ==
                      product['produto'].productId)['data']) {
                newList.firstWhere((element) =>
                        element['produto'].productId ==
                        product['produto'].productId)['quantidade'] +=
                    product['quantidade'];
              } else {
                newList.add({
                  "produto": product['produto'],
                  "quantidade": product['quantidade'],
                  "data": venda.deliveryDate,
                });
              }
            } else {
              newList.add({
                "produto": product['produto'],
                "quantidade": product['quantidade'],
                "data": venda.deliveryDate,
              });
            }
          }
        } else if (venda.boxes.isNotEmpty) {
          for (var box in venda.boxes) {
            for (var productInBox in box['box'].produtos) {
              if (newList.any((element) =>
                  element['produto'].productId ==
                  productInBox.product.productId)) {
                if (venda.deliveryDate ==
                    newList.firstWhere((element) =>
                        element['produto'].productId ==
                        productInBox.product.productId)['data']) {
                  newList.firstWhere((element) =>
                          element['produto'].productId ==
                          productInBox.product.productId)['quantidade'] +=
                      productInBox.quantity;
                } else {
                  newList.add({
                    "produto": productInBox.product,
                    "quantidade": productInBox.quantity,
                    "data": venda.deliveryDate,
                  });
                }
              } else {
                newList.add({
                  "produto": productInBox.product,
                  "quantidade": productInBox.quantity,
                  "data": venda.deliveryDate,
                });
              }
            }
          }
        }
      }
      /**
       * datas: [{
       *  "data": xx/xx/xxxx,
       *  "produtosNaData": [{"produto": x, "quantidade": y, "data": z}],
       * }]
       */
      List<Map<String, dynamic>> datas = [];
      for (var i = 0; i < newList.length; i++) {
        String currentDate = newList[i]['data'];
        if (newList[i]['data'] == currentDate) {
          List<Map<String, dynamic>> result = [];
          for (var element in newList) {
            if (element['data'] == currentDate) {
              result.add(element);
            }
          }
          if (datas.any((element) => element['data'] == currentDate)) {
            datas
                .firstWhere((element) => element['data'] == currentDate)[
                    'produtosNaData']
                .add(newList[i]);
          } else {
            datas.add({
              "data": currentDate,
              "produtosNaData": result,
            });
          }
        } else {
          String newCurrentDate = newList[i]['data'];
          if (datas.any((element) => element['data'] == newCurrentDate)) {
            datas
                .firstWhere((element) => element['data'] == newCurrentDate)[
                    'produtosNaData']
                .add(newList[i]);
          } else {
            datas.add({
              "data": currentDate,
              "produtosNaData": newCurrentDate,
            });
          }
        }
      }
      return datas;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      throw Exception('erro: $e');
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

            List<String> _cooperatives = [];
            for (var element2 in element['cooperatives']) {
              _cooperatives.add(element2['cooperativeName']);
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
                  measuremntUnit: element5['productId']['measurementUnit']
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
                produtos: products,
              );
              boxes.add({
                "box": box,
                "quantity": element4['quantity'],
              });
              products = [];
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
                measuremntUnit: element3['productId']['measurementUnit']
                    ['measurementUnit'],
              );
              if (product.cooperativeId == id) {
                produtos.add(
                  {
                    "produto": product,
                    "quantidade": element3['quantity'],
                  },
                );
              }
            }
            if (produtos.isNotEmpty) {
              Sell sell = Sell(
                address: endereco,
                products: produtos,
                boxes: boxes,
                sellId: element['_id'],
                status: element['status'],
                sellDate: element['sellDate'],
                deliveryDate: element['deliveryDate'],
                cooperatives: _cooperatives,
              );
              _sells.add(sell);
            }

            _cooperatives = [];
            produtos = [];
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
            complement: response.data['cooperative']['cooperativeAdress']
                ['complement'],
            street: response.data['cooperative']['cooperativeAdress']['street'],
            city: response.data['cooperative']['cooperativeAdress']['city'],
            state: response.data['cooperative']['cooperativeAdress']['state'],
            zipCode: response.data['cooperative']['cooperativeAdress']
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
          "cooperativeAdress": {
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
