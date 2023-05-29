import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_organicos/model/measurementUnit.dart';

class MeasuremntUnitController {
  String _baseUrl = "http://192.168.1.159:27017/measurementUnit";
  List<Measurement> _list = [];

  Future<List<Measurement>> getAllMeasuremntUnits() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().get(
        _baseUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('measurementUnits')) {
        for (var element in response.data['measurementUnits']) {
          Measurement measuremntUnit = Measurement(
            id: element['_id'],
            measurementUnit: element['measurementUnit'],
          );
          _list.add(measuremntUnit);
        }
      }
      return _list;
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
      }
      return _list;
    }
  }
}
