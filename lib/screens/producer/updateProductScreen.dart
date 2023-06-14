import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_organicos/components/smallButton.dart';
import 'package:projeto_organicos/controller/measurementUnitController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../components/nameAndIcon.dart';
import '../../controller/cooperativeController.dart';
import '../../model/measurementUnit.dart';
import '../../model/producers.dart';
import '../../utils/validators.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

Widget _textField1(
  double height,
  double width,
  BoxConstraints constraints,
  String text,
  TextEditingController controller,
  String? Function(String?) validate,
) {
  return SizedBox(
    height: constraints.maxHeight * height,
    width: constraints.maxWidth * width,
    child: TextFormField(
      maxLines: null,
      expands: true,
      controller: controller,
      validator: validate,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white, width: constraints.maxWidth * .03),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: constraints.maxHeight * .02,
        ),
      ),
    ),
  );
}

Widget _textField2(
  double height,
  double width,
  BoxConstraints constraints,
  String text,
  TextEditingController controller,
) {
  return SizedBox(
    height: constraints.maxHeight * height,
    width: constraints.maxWidth * width,
    child: TextFormField(
      maxLines: null,
      expands: true,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white, width: constraints.maxWidth * .03),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: constraints.maxHeight * .02,
        ),
      ),
    ),
  );
}

Widget thinDivider(BoxConstraints constraints) {
  return Center(
    child: Container(
      height: 0.8,
      width: constraints.maxWidth * .7,
      color: Color.fromRGBO(83, 242, 166, 1),
    ),
  );
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  Validators validators = Validators();
  String _selectedProducer = "";
  String _selectedMeasurementUnit = "";
  List<Producers> _producerList = [];
  List<Measurement> _measurementList = [];
  List<Category> _categoryList = [];
  List<bool> _categoryBoolList = [];
  List<String> _producerNameList = [];
  List<String> _measurementNameList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  XFile? _storagedImage;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _storagedImage = image;
    });

    return image;
  }

  Future<String> uploadImage(
      String path, String string, String fotoPath) async {
    File file = File(path);
    try {
      String ref = '$fotoPath/$string.jpg';
      UploadTask uploadTask = storage.ref(ref).putFile(file);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception("erro: ${e.code}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductController productController = ProductController();
    CooperativeController cooperativeController = CooperativeController();
    MeasurementUnitController measurementUnitController =
        MeasurementUnitController();
    cooperativeController.getAllProducers().then((value) {
      List<String> t = value.map((e) => e.producerName).toList();
      setState(() {
        _producerList = value;
        _producerNameList = t;
      });
    });
    measurementUnitController.getAllmeasurementUnits().then((value) {
      List<String> t = value.map((e) => e.measurementUnit).toList();
      setState(() {
        _measurementList = value;
        _measurementNameList = t;
      });
    });
    productController.getAllCategorys().then((value) {
      setState(() {
        _categoryList = value;
        _categoryBoolList = List.generate(value.length, (index) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Products product = ModalRoute.of(context)?.settings.arguments as Products;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(108, 168, 129, 0.7),
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.favorite,
                  color: Color.fromRGBO(108, 168, 129, 0.7)),
              const SizedBox(width: 10),
              Text(
                product.productName,
                style: const TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight * 1.6,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .03),
                  SizedBox(
                    height: constraints.maxHeight * 1.4,
                    width: constraints.maxWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * .85,
                          child: Text(
                            "Obrigatoriamente preencha as categorias, produtor e unidade de medida",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromRGBO(18, 18, 18, 0.58),
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxHeight * .023,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .05),
                        _textField1(
                          .1,
                          .9,
                          constraints,
                          product.productName,
                          nameController,
                          validators.nameValidator,
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        _textField1(
                          .2,
                          .9,
                          constraints,
                          product.productDetails,
                          detailsController,
                          (p0) => null,
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        SizedBox(
                          width: constraints.maxWidth * .9,
                          child: DropdownButtonFormField<String>(
                            itemHeight: constraints.maxHeight * .09,
                            value: _selectedProducer.isNotEmpty
                                ? _selectedProducer
                                : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: constraints.maxWidth * .03),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            hint: Text(
                              "Produtor",
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .02,
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedProducer = value!;
                              });
                            },
                            items: _producerNameList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        SizedBox(
                          width: constraints.maxWidth * .9,
                          child: DropdownButtonFormField<String>(
                            itemHeight: constraints.maxHeight * .09,
                            value: _selectedMeasurementUnit.isNotEmpty
                                ? _selectedMeasurementUnit
                                : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width: constraints.maxWidth * .03),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            hint: Text(
                              "Unidade de Medida",
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .02,
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedMeasurementUnit = value!;
                              });
                            },
                            items: _measurementNameList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .04),
                        thinDivider(constraints),
                        SizedBox(height: constraints.maxHeight * .04),
                        Text(
                          "Categorias",
                          style: TextStyle(
                            color: const Color.fromRGBO(18, 18, 18, 0.58),
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxHeight * .024,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        Center(
                          child: SizedBox(
                            width: constraints.maxWidth * .85,
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children:
                                  List.generate(_categoryList.length, (index) {
                                return ChoiceChip(
                                  label:
                                      Text(_categoryList[index].categoryName),
                                  selected: _categoryBoolList[index],
                                  selectedColor:
                                      const Color.fromRGBO(83, 242, 166, 0.69),
                                  onSelected: (newState) {
                                    setState(() {
                                      _categoryBoolList[index] = newState;
                                    });
                                  },
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .04),
                        thinDivider(constraints),
                        SizedBox(height: constraints.maxHeight * .04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => getImage(),
                              child: const Text(
                                "Foto",
                                style: TextStyle(
                                  color: Color.fromRGBO(18, 18, 18, 0.58),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: constraints.maxHeight * .2,
                              width: constraints.maxWidth * .3,
                              color: Colors.grey,
                              child: _storagedImage != null
                                  ? Image.file(
                                      File(_storagedImage!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.camera_alt_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          ProductController controller = ProductController();

                          List<String> listaDeId = [];
                          for (var i = 0; i < _categoryList.length; i++) {
                            if (_categoryBoolList[i]) {
                              listaDeId.add(_categoryList[i].categoryId);
                            }
                          }

                          int index =
                              _producerNameList.indexOf(_selectedProducer);
                          int index2 = _measurementNameList
                              .indexOf(_selectedMeasurementUnit);

                          String photoUrl = "";
                          if (_storagedImage != null) {
                            if (nameController.text != "" &&
                                _selectedProducer != "") {
                              photoUrl = await uploadImage(
                                _storagedImage!.path,
                                "${nameController.text}${_producerList[index].producerId}",
                                "productsPhotos",
                              );
                            } else {
                              if (nameController.text == "") {
                                photoUrl = await uploadImage(
                                  _storagedImage!.path,
                                  "${product.productName}${_producerList[index].producerId}",
                                  "productsPhotos",
                                );
                              } else {
                                photoUrl = await uploadImage(
                                  _storagedImage!.path,
                                  "${product.productName}${product.producerId}",
                                  "productsPhotos",
                                );
                              }
                            }
                          }

                          Products newProduct = Products(
                            productId: product.productId,
                            productName: nameController.text != ""
                                ? nameController.text
                                : product.productName,
                            category: listaDeId,
                            productPhoto: photoUrl,
                            productPrice: product.productPrice,
                            stockQuantity: product.stockQuantity,
                            unitValue: product.unitValue,
                            productDetails: detailsController.text != ""
                                ? detailsController.text
                                : product.productDetails,
                            cooperativeId: product.cooperativeId,
                            producerId: _producerList[index].producerId,
                            measurementUnit: _measurementList[index2].id,
                          );

                          controller.updateProduct(
                            product.productId,
                            newProduct,
                            product,
                          );

                          Navigator.of(context).pop(newProduct);
                        },
                        child: SmallButton(
                          constraints: constraints,
                          text: "Salvar",
                          color: true,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    'Deseja mesmo deletar o Produto?'),
                                content: const Text('Essa ação é irreversivel'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                  ),
                                  TextButton(
                                    child: Text('Confirmar'),
                                    onPressed: () {
                                      // Lógica para confirmar a exclusão da conta
                                      ProductController controller =
                                          ProductController();
                                      controller.deleteProduct(
                                        product.productId,
                                        product.productName,
                                      );
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        ProducerAppRoutes.PRODUCERHOMETAB,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: SmallButton(
                          constraints: constraints,
                          text: "Excluir",
                          color: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
