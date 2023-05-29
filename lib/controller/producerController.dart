import 'package:dio/dio.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/cooperativeWithoutAdress.dart';
import 'package:projeto_organicos/model/producers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';

class ProducerController {
  String _producerUrl = "http://192.168.1.159:27017/producer";
  List<CooperativeWithoutAdress> cooperativas = [];

  Future<List<CooperativeWithoutAdress>> getAllCooperativesFromProducer(
      String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().get(
        "$_producerUrl/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('producer')) {
        for (var element in response.data['producer']['cooperatives']) {
          CooperativeWithoutAdress cooperative = CooperativeWithoutAdress(
            cooperativeId: element['_id'],
            cooperativeEmail: element['cooperativeEmail'],
            password: "",
            cooperativeName: element['cooperativeName'],
            cooperativeCnpj: element['cooperativeCnpj'],
            cooperativeProfilePhoto: "",
            cooperativePhone: element['cooperativePhone'],
          );
          cooperativas.add(cooperative);
        }
        return cooperativas;
      } else {
        print("produtor não existe");
        return cooperativas;
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return cooperativas;
    }
  }

  void updateProducer(
    String producerId,
    Producers newProducer,
    Producers oldProducer,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      CooperativeController controller = CooperativeController();
      var response = await Dio().put(
        "$_producerUrl/$producerId",
        data: {
          "producerName": newProducer.producerName != ""
              ? newProducer.producerName
              : oldProducer.producerName,
          "producerCpf": newProducer.producerCpf != ""
              ? newProducer.producerCpf
              : oldProducer.producerCpf,
          "producerCell": newProducer.producerCell != ""
              ? newProducer.producerCell
              : oldProducer.producerCell,
          "producerBirthdate": newProducer.birthDate != ""
              ? newProducer.birthDate
              : oldProducer.birthDate,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.data.containsKey('producer')) {
        controller.getAllProducers();
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
