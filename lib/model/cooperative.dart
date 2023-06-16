import 'package:projeto_organicos/model/cooperativeAdress.dart';

class Cooperative {
  final String cooperativeId;
  final String cooperativeName;
  final String cooperativeEmail;
  final String cooperativeCnpj;
  final String cooperativePhone;
  final CooperativeAdress cooperativeAdress;
  final String password;
  final String cooperativeProfilePhoto;

  Cooperative({
    required this.cooperativeId,
    required this.cooperativeEmail,
    required this.password,
    required this.cooperativeName,
    required this.cooperativeCnpj,
    required this.cooperativeAdress,
    required this.cooperativeProfilePhoto,
    required this.cooperativePhone,
  });

  static Cooperative fromJson(Map<String, dynamic> json) {
    return Cooperative(
      cooperativeId: json['cooperativeId'],
      cooperativeEmail: json['cooperativeEmail'],
      password: json['password'],
      cooperativeName: json['cooperativeName'],
      cooperativeCnpj: json['cooperativeCnpj'],
      cooperativeAdress: CooperativeAdress.fromJson(json['cooperativeAdress']),
      cooperativeProfilePhoto: json['cooperativeProfilePhoto'],
      cooperativePhone: json['cooperativePhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cooperativeId': cooperativeId,
      'cooperativeEmail': cooperativeEmail,
      'password': password,
      'cooperativeName': cooperativeName,
      'cooperativeCnpj': cooperativeCnpj,
      'cooperativeAdress': cooperativeAdress.toJson(),
      'cooperativeProfilePhoto': cooperativeProfilePhoto,
      'cooperativePhone': cooperativePhone,
    };
  }
}
