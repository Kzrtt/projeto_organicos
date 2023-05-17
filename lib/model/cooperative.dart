import 'package:projeto_organicos/model/cooperativeAdress.dart';

class Cooperative {
  final String cooperativeName;
  final String cooperativeEmail;
  final String cooperativeCnpj;
  final String cooperativePhone;
  final CooperativeAdress cooperativeAdress;
  final String password;
  final String cooperativeProfilePhoto;

  Cooperative({
    required this.cooperativeEmail,
    required this.password,
    required this.cooperativeName,
    required this.cooperativeCnpj,
    required this.cooperativeAdress,
    required this.cooperativeProfilePhoto,
    required this.cooperativePhone,
  });
}
