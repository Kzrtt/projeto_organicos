import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/productInBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/products.dart';

class ProductController {
  String _productUrl = "https://api-production-696d.up.railway.app/product";
  String _categoryUrl = "https://api-production-696d.up.railway.app/category";
  String _dietsUrl = "https://api-production-696d.up.railway.app/diet";
  List<Category> _categoryList = [];
  List<Products> _productList = [];
  List<Box> _boxList = [];
  List<Reference> refs = [];
  List<String> arquivos = [];

  Future<String> getPhotoUrl(String id) async {
    List<String> _urlsFotos = await loadImages();
    for (String url in _urlsFotos) {
      // Extrair o ID da URL
      int inicioId = url.indexOf("%2F") + "%2F".length;
      int fimId = url.lastIndexOf(".jpg");
      String idUrl = url.substring(inicioId, fimId);
      // Comparar com a string de comparação
      if (idUrl == id) {
        return url;
      }
    }
    return "";
  }

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> uploadImage(String path, String string) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    File file = File(path);
    try {
      String ref = 'productsPhotos/$string.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  pickAndUploadImage(String string) async {
    XFile? file = await getImage();
    if (file != null) {
      await uploadImage(file.path, string);
    }
  }

  Future<List<String>> loadImages() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    refs = (await storage.ref('productsPhotos').listAll()).items;
    for (var element in refs) {
      arquivos.add(await element.getDownloadURL());
    }
    return arquivos;
  }

  Future<List<String>> getAllDiets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      List<String> diets = [];
      var response = await Dio().get(
        _dietsUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('diets')) {
        for (var element in response.data['diets']) {
          diets.add(element['_id']);
        }
      }
      return diets;
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

  void updateBox(Box newBox, Box oldBox) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      var response = await Dio().put(
        "$_productUrl/${newBox.id}",
        data: {
          "boxName": newBox.boxName,
          "boxDetails": newBox.boxDetails,
          "boxPrice": newBox.boxPrice,
          "stockQuantity": newBox.boxQuantity,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (newBox.boxPhoto != "") {
        FirebaseStorage storage = FirebaseStorage.instance;
        String photoPath = "boxPhotos/${oldBox.boxName}.jpg";
        Reference photoRef = storage.ref().child(photoPath);
        await photoRef.delete();
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

  void deleteBox(String id, String boxName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      var response = await Dio().put(
        "$_productUrl/$id",
        data: {
          "boxName": boxName,
          "active": "false",
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('box')) {
        print('sucesso');
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
            for (var element3 in element2['productId']['categories']) {
              categorias.add(element3['categoryName']);
            }

            Products product = Products(
              productId: element2['productId']['_id'],
              productName: element2['productId']['productName'],
              category: categorias,
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
            products.add(productInBox);
          }

          Box box = Box(
            id: element['_id'],
            boxDetails: element['boxDetails'],
            boxName: element['boxName'],
            boxPhoto: element['boxPhoto'],
            boxPrice: element['boxPrice'],
            boxQuantity: element['stockQuantity'],
            boughtQuantity: 0,
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

  Future<bool> createBox(Box box) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('cooperativeToken');
      Map<String, dynamic> produtos = {};

      List<Map<String, dynamic>> productsList = [];

      for (var produto in box.produtos) {
        Map<String, dynamic> productMap = {
          'productId': produto.product.productId,
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
          "boxPhoto": box.boxPhoto,
          "stockQuantity": box.boxQuantity,
          "products": [...productsList],
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('box')) {
        return true;
      } else {
        return false;
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
      throw Exception(e);
    }
  }

  Future<void> updateQuantity(Products product, int newQuantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      num q = newQuantity + product.stockQuantity;
      var response = await Dio().put(
        "$_productUrl/${product.productId}",
        data: {
          "productName": product.productName,
          "stockQuantity": q,
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

  void clearStock(Products product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().put(
        "$_productUrl/${product.productId}",
        data: {
          "productName": product.productName,
          "stockQuantity": 0,
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

  Future<void> updateProduct(
    String id,
    Products product,
    Products oldProduct,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().put(
        "$_productUrl/$id",
        data: {
          "productName": product.productName != ""
              ? product.productName
              : oldProduct.productName,
          "productDetails": product.productDetails != ""
              ? product.productDetails
              : oldProduct.productDetails,
          "productPhoto": product.productPhoto != ""
              ? product.productPhoto
              : oldProduct.productPhoto,
          "productPrice": product.productPrice != 0
              ? product.productPrice
              : oldProduct.productPrice,
          "categories": product.category != []
              ? [...product.category]
              : [...oldProduct.category],
          "stockQuantity": product.stockQuantity != 0
              ? product.stockQuantity
              : oldProduct.stockQuantity,
          "unitValue":
              product.unitValue != 0 ? product.unitValue : oldProduct.unitValue,
          "measurementUnit": product.measurementUnit != ""
              ? product.measurementUnit
              : oldProduct.measurementUnit,
          "producerId": product.producerId != ""
              ? product.producerId
              : oldProduct.producerId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (product.productPhoto != oldProduct.productPhoto) {
        FirebaseStorage storage = FirebaseStorage.instance;
        String photoPath =
            "productsPhotos/${oldProduct.productName}${oldProduct.producerId}.jpg";
        Reference photoRef = storage.ref().child(photoPath);
        await photoRef.delete();
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

  void deleteProduct(Products product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("cooperativeToken");
      var response = await Dio().put(
        "$_productUrl/${product.productId}",
        data: {
          "productName": product.productName,
          "active": false,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data['product']) {
        FirebaseStorage storage = FirebaseStorage.instance;
        String photoPath =
            "productsPhotos/${product.productName}${product.producerId}.jpg";
        Reference photoRef = storage.ref().child(photoPath);
        await photoRef.delete();
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
              measurementUnit: element['measurementUnit']['measurementUnit'],
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

  Future<bool> createProduct(Products product, BuildContext context) async {
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
          "measurementUnit": product.measurementUnit,
          "producerId": product.producerId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.data.containsKey('product')) {
        return true;
      } else {
        return false;
      }
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
