import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/cooperativeAdress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CooperativeProvider with ChangeNotifier {
  final String _baseUrl = "http://localhost:27017/auth";
  final String _cooperativeUrl = "http://localhost:27017/cooperative";
  CooperativeAdress adress = CooperativeAdress(
    state: "",
    street: "",
    city: "",
    zipCode: "",
    complement: "",
  );
  Cooperative cooperative = Cooperative(
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
          "cooperativeAdress": {
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
