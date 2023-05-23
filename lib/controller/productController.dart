import 'package:dio/dio.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/productInBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/products.dart';

class ProductController {
  String _productUrl = "http://localhost:27017/product";
  String _categoryUrl = "http://localhost:27017/category";
  List<Category> _categoryList = [];
  List<Products> _productList = [];
  List<Box> _boxList = [];

  void deleteBox(String id, String boxName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      var response = await Dio().put(
        "$_productUrl/$id",
        data: {
          "boxName": boxName,
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
      String? token = prefs.getString('cooperativeToken');
      var response = await Dio().get(
        "$_productUrl/boxes",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('boxes')) {
        for (var element in response.data['boxes']) {
          List<ProductInBox> products = [];
          for (var element2 in element['products']) {
            List<String> categorias = [];
            for (var element3 in element2['product']['categories']) {
              categorias.add(element3);
            }

            Products product = Products(
              productId: element2['product']['_id'],
              productName: element2['product']['productName'],
              category: categorias,
              productPhoto: element2['product']['productPhoto'],
              productPrice: element2['product']['productPrice'],
              stockQuantity: element2['product']['stockQuantity'],
              unitValue: element2['product']['unitValue'],
              productDetails: element2['product']['productDetails'],
              cooperativeId: element2['product']['cooperativeId'],
              producerId: element2['product']['producerId'],
              measuremntUnit: element2['product']['measurementUnit'],
            );
            ProductInBox productInBox = ProductInBox(
              product: product,
              quantity: element2['quantity'],
              measurementUnity: element2['product']['measurementUnit'],
            );
            products.add(productInBox);
          }

          Box box = Box(
            id: element['_id'],
            boxDetails: element['boxDetails'],
            boxName: element['boxName'],
            boxPhoto: element['boxPhoto'],
            boxPrice: element['boxPrice'],
            boxQuantity: element['stockQuantity'],
            produtos: products,
          );
          if (element['active'] == true) {
            _boxList.add(box);
          }
        }
        return _boxList;
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

  void createBox(Box box) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      Map<String, dynamic> produtos = {};

      List<Map<String, dynamic>> productsList = [];

      for (var produto in box.produtos) {
        Map<String, dynamic> productMap = {
          'product': produto.product.productId,
          'quantity': produto.quantity,
        };
        productsList.add(productMap);
      }

      var response = await Dio().post(
        _productUrl,
        data: {
          "boxName": box.boxName,
          "boxDetails": box.boxDetails,
          "boxPrice": box.boxPrice,
          "boxPhoto": "",
          "stockQuantity": box.boxQuantity,
          "products": productsList,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('box')) {
        for (var element in box.produtos) {
          var response2 = await Dio().put(
            "$_productUrl/${element.product.productId}",
            data: {
              "stockQuantity": element.product.stockQuantity - element.quantity
            },
            options: Options(
              headers: {'Authorization': 'Bearer $token'},
            ),
          );
        }
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
    }
  }

  void updateProduct(String id, Products product, Products oldProduct) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().put(
        "$_productUrl/$id",
        data: {
          "productName": product.productName.isNotEmpty
              ? product.productName
              : oldProduct.productName,
          "productDetails": product.productDetails.isNotEmpty
              ? product.productDetails
              : oldProduct.productDetails,
          "productPhoto": product.productPhoto.isNotEmpty
              ? product.productPhoto
              : oldProduct.productPhoto,
          "productPrice": product.productPrice,
          "categories": [...product.category],
          "stockQuantity": product.stockQuantity != 0
              ? product.stockQuantity
              : oldProduct.stockQuantity,
          "unitValue":
              product.unitValue != 0 ? product.unitValue : oldProduct.unitValue,
          "measurementUnit": product.measuremntUnit.isNotEmpty
              ? product.measuremntUnit
              : oldProduct.measuremntUnit,
          "producerId": product.producerId.isNotEmpty
              ? product.producerId
              : oldProduct.producerId,
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
        print(StackTrace.current);
      }
    }
  }

  void deleteProduct(String productId, String productName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().put(
        "$_productUrl/$productId",
        data: {
          "productName": productName,
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
        print(StackTrace.current);
      }
    }
  }

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
          if (element['cooperativeId'] == id && element['active'] == true) {
            List<String> categories = [];
            for (var e in element['categories']) {
              categories.add(e['categoryName']);
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
              measuremntUnit: element['measurementUnit']['measurementUnit'],
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
