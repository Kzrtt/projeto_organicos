import 'package:dio/dio.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/products.dart';

class ProductController {
  String _productUrl = "http://localhost:27017/product";
  String _categoryUrl = "http://localhost:27017/category";
  List<Category> _categoryList = [];
  List<Products> _productList = [];

  Future<List<Products>> getAllProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      String? id = prefs.getString("cooperativeId");
      var response = await Dio().get(
        "$_productUrl/products",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('products')) {
        for (var element in response.data['products']) {
          if (element['cooperativeId'] == id) {
            List<String> categories = [];
            for (var e in element['categories']) {
              categories.add(e['_id']);
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
              measuremntUnit: element['measurementUnit']['_id'],
            );
            _productList.add(products);
          }
        }
        return _productList;
      } else {
        print("erro");
        return _productList;
      }
    } catch (e) {
      if (e is DioError) {
        print('Erro de requisição:');
        print('Status code: ${e.response?.statusCode}');
        print('Mensagem: ${e.response?.data}');
      } else {
        print('Erro inesperado: $e');
        print(StackTrace.current);
      }
      return _productList;
    }
  }

  void createProduct(Products product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().post(
        _productUrl,
        data: {
          "productName": product.productName,
          "productDetails": product.productDetails,
          "productPhoto": product.productPhoto,
          "productPrice": product.productPrice,
          "categories": [...product.category],
          "stockQuantity": product.stockQuantity,
          "unitValue": product.unitValue,
          "measurementUnit": product.measuremntUnit,
          "producerId": product.producerId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (!response.data.containsKey('product')) {
        print("erro");
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

  Future<List<Category>> getAllCategorys() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
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
}
