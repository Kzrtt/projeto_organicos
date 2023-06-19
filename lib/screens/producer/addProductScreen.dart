// ignore_for_file: unused_field

import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/measurementUnitController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/measurementUnit.dart';
import 'package:projeto_organicos/model/producers.dart';
import 'package:projeto_organicos/model/productInBox.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/validators.dart';

class AddProductScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  const AddProductScreen({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

Widget _textField1(
  double height,
  double width,
  BoxConstraints constraints,
  String text,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return SizedBox(
    height: constraints.maxHeight * height,
    width: constraints.maxWidth * width,
    child: TextFormField(
      maxLines: null,
      expands: true,
      validator: validator,
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

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  //Variaveis para o Produto
  bool isSelected = false;
  final Validators validators = Validators();
  final _firstFormKey = GlobalKey<FormState>();
  final _secondFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  final TextEditingController _unitValueController = TextEditingController();
  final TextEditingController _measurementUnityController =
      TextEditingController();
  final TextEditingController _recommendedPriceController =
      TextEditingController();
  String _selectedProducer = "";
  String _selectedUnit = "";
  List<String> _unitList = [];
  List<String> _categoryList = [];
  List<String> _producerList = [];
  List<bool> _categoryBoolList = [];
  List<Category> _categorias = [];
  List<Producers> _p = [];
  List<Products> _products = [];
  List<String> _productsNames = [];
  List<Measurement> _measurementList = [];
  TabController? _tabController;
  ProductController pcontroller = ProductController();
  int _step = 0;
  //Variaveis para a box
  int _stepBox = 0;
  List<ProductInBox> _produtosNaBox = [];
  final basicInfoBoxKey = GlobalKey<FormState>();
  final TextEditingController _boxNameController = TextEditingController();
  final TextEditingController _boxDetailsController = TextEditingController();
  final TextEditingController _boxStockQuantity = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  XFile? _storagedImage;
  XFile? _storagedImageBox;

  Future<XFile?> getImage(String wich) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (wich == "product") {
      setState(() {
        _storagedImage = image;
      });
    } else if (wich == "box") {
      setState(() {
        _storagedImageBox = image;
      });
    }
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
    _tabController = TabController(length: 2, vsync: this);
    CooperativeController coopController = CooperativeController();
    MeasurementUnitController unityController = MeasurementUnitController();
    ProductController productController = ProductController();
    productController.getAllProducts().then((value) {
      List<String> nomesProdutos = value.map((e) => e.productName).toList();
      _products = value;
      _productsNames = nomesProdutos;
    });
    coopController.getAllProducers().then((value) {
      List<String> nomesProdutores = value.map((e) => e.producerName).toList();
      setState(() {
        _p = value;
        _producerList = nomesProdutores;
      });
      print(_p.length);
      print(_producerList.length);
    });
    pcontroller.getAllCategorys().then((value) {
      List<String> nomesCategorias = value.map((e) => e.categoryName).toList();
      setState(() {
        _categorias = value;
        _categoryList = nomesCategorias;
        _categoryBoolList =
            List.generate(_categoryList.length, (index) => false);
      });
    });
    unityController.getAllmeasurementUnits().then((value) {
      List<String> nomesUnidadesDeMedida =
          value.map((e) => e.measurementUnit).toList();
      setState(() {
        _unitList = nomesUnidadesDeMedida;
        _measurementList = value;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
  }

  double getRecommendedValue() {
    double total = 0;
    for (var i = 0; i < _produtosNaBox.length; i++) {
      total = total +
          _produtosNaBox[i].quantity * _produtosNaBox[i].product.productPrice;
    }
    return total;
  }

  Widget addBoxForm(BoxConstraints constraints, BuildContext context) {
    return Stepper(
      currentStep: _stepBox,
      onStepTapped: (int index) {
        setState(() {
          _stepBox = index;
        });
      },
      controlsBuilder: (context, details) {
        return Column(
          children: [
            SizedBox(height: constraints.maxHeight * .03),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(83, 242, 166, 0.69),
                        ),
                      ),
                      onPressed: () async {
                        if (_stepBox == 0) {
                          if (basicInfoBoxKey.currentState!.validate()) {
                            setState(() {
                              _stepBox = _stepBox + 1;
                            });
                          }
                        } else if (_stepBox == 1) {
                          if (_produtosNaBox.length > 1) {
                            setState(() {
                              _stepBox = _stepBox + 1;
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return const AlertDialog(
                                  title: Text(
                                    "A box deve conter mais que dois items",
                                  ),
                                );
                              },
                            );
                          }
                        } else if (_stepBox == 2 && _storagedImageBox != null) {
                          ProductController controller = ProductController();
                          print('criou controller');

                          String photoUrl = await uploadImage(
                            _storagedImageBox!.path,
                            _boxNameController.text.trim(),
                            "boxPhotos",
                          );

                          Box box = Box(
                            id: "",
                            boxDetails: _boxDetailsController.text,
                            boxName: _boxNameController.text,
                            boxPhoto: photoUrl,
                            boxPrice:
                                double.parse(_recommendedPriceController.text),
                            boxQuantity: int.parse(_boxStockQuantity.text),
                            boughtQuantity: 0,
                            produtos: _produtosNaBox,
                          );
                          controller.createBox(box).then((value) {
                            if (value) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text("Box Criada com sucesso"),
                                  );
                                },
                              ).then((value) {
                                widget.callbackFunction(2);
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text("Erro ao criar a box"),
                                  );
                                },
                              ).then((value) {
                                widget.callbackFunction(2);
                              });
                            }
                          });
                        }
                      },
                      child: Text(
                        _stepBox <= 1 ? "Continuar" : "Finalizar",
                      ),
                    ),
                  ),
                  SizedBox(width: constraints.maxWidth * .05),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_step != 0) {
                            _step = _step - 1;
                          }
                        });
                      },
                      child: const Text(
                        "Voltar",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      steps: [
        Step(
          title: Text("Informações Básicas"),
          content: Form(
            key: basicInfoBoxKey,
            child: Column(
              children: [
                _textField1(
                  .09,
                  .9,
                  constraints,
                  "Nome da Box",
                  _boxNameController,
                  (p0) => null,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  .25,
                  .9,
                  constraints,
                  "Detalhes da Box",
                  _boxDetailsController,
                  (p0) => null,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  .09,
                  .9,
                  constraints,
                  "Quantidade de Box disponiveis",
                  _boxStockQuantity,
                  (p0) => null,
                ),
              ],
            ),
          ),
        ),
        Step(
          title: const Text("Produtos da Box"),
          content: Column(
            children: [
              _produtosNaBox.isNotEmpty
                  ? SizedBox(
                      height:
                          constraints.maxHeight * _produtosNaBox.length / 10,
                      width: constraints.maxWidth,
                      child: ListView.builder(
                        itemCount: _produtosNaBox.length,
                        itemBuilder: (context, index) {
                          var item = _produtosNaBox[index];
                          return ListTile(
                            title: Text(item.product.productName),
                            subtitle: Text(
                              "Quantidade: ${item.quantity * item.product.unitValue} ${item.measurementUnity}",
                            ),
                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  _produtosNaBox.removeWhere(
                                    (element) =>
                                        element.product.productName ==
                                        item.product.productName,
                                  );
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(),
              SizedBox(height: constraints.maxHeight * .05),
              InkWell(
                onTap: () async {
                  var response = await Navigator.of(context)
                          .pushNamed(ProducerAppRoutes.SEARCHPRODUCTS)
                      as List<ProductInBox>;
                  setState(() {
                    _produtosNaBox = response;
                  });
                },
                child: CommonButton(
                  constraints: constraints,
                  text: "Selecionar Produtos",
                ),
              ),
              SizedBox(height: constraints.maxHeight * .03),
              _textField1(
                .1,
                .9,
                constraints,
                "Preço sugerido: ${getRecommendedValue()} reais",
                _recommendedPriceController,
                (p0) => null,
              ),
              SizedBox(height: constraints.maxHeight * .03),
            ],
          ),
        ),
        Step(
          title: const Text("Foto"),
          content: Column(
            children: [
              SizedBox(height: constraints.maxHeight * .03),
              Row(
                children: [
                  Container(
                    height: constraints.maxHeight * .2,
                    width: constraints.maxWidth * .3,
                    color: Colors.grey,
                    child: _storagedImageBox != null
                        ? Image.file(
                            File(_storagedImageBox!.path),
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.camera_alt_rounded),
                  ),
                  SizedBox(width: constraints.maxWidth * .05),
                  InkWell(
                    onTap: () => getImage("box"),
                    child: Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined),
                        SizedBox(width: constraints.maxWidth * .01),
                        const Text(
                          "Escolher Foto",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: constraints.maxHeight * .03)
            ],
          ),
        ),
      ],
    );
  }

  Widget addProductForm(BoxConstraints constraints, BuildContext context) {
    return Stepper(
      currentStep: _step,
      onStepTapped: (int index) {
        setState(() {
          _step = index;
        });
      },
      controlsBuilder: (context, details) {
        return Column(
          children: [
            SizedBox(height: constraints.maxHeight * .03),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(83, 242, 166, 0.69),
                        ),
                      ),
                      onPressed: () async {
                        if (_step == 0) {
                          if (_firstFormKey.currentState!.validate()) {
                            setState(() {
                              _step = _step + 1;
                            });
                          }
                        } else if (_step == 1) {
                          if (_categoryBoolList
                              .any((element) => element == true)) {
                            setState(() {
                              _step = _step + 1;
                            });
                          }
                        } else if (_step == 2 && _selectedUnit != "") {
                          if (_secondFormKey.currentState!.validate()) {
                            setState(() {
                              _step = _step + 1;
                            });
                          }
                        } else if (_step == 3 && _storagedImage != null) {
                          List<String> listaDeId = [];
                          for (var i = 0; i < _categoryList.length; i++) {
                            if (_categoryBoolList[i]) {
                              listaDeId.add(_categorias[i].categoryId);
                            }
                          }
                          int index = _producerList.indexOf(_selectedProducer);
                          int index2 = _unitList.indexOf(_selectedUnit);
                          String photoUrl = await uploadImage(
                            _storagedImage!.path,
                            "${_nameController.text.trim()}${_p[index].producerId}",
                            "productsPhotos",
                          );
                          double stockQuantity =
                              double.parse(_stockQuantityController.text);
                          double unitValue =
                              double.parse(_unitValueController.text);
                          ProductController controller = ProductController();
                          Products product = Products(
                            productId: "",
                            productName: _nameController.text,
                            category: listaDeId,
                            productPhoto: photoUrl,
                            productPrice: double.parse(_priceController.text),
                            stockQuantity: stockQuantity / unitValue,
                            unitValue: int.parse(_unitValueController.text),
                            productDetails: _detailsController.text,
                            cooperativeId: "",
                            producerId: _p[index].producerId,
                            measurementUnit: _measurementList[index2].id,
                          );
                          controller.createProduct(product, context).then(
                            (value) async {
                              if (value) {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text("Produto Criado com sucesso"),
                                    );
                                  },
                                ).then((value) {
                                  widget.callbackFunction(2);
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text("Erro ao criar o produto"),
                                    );
                                  },
                                ).then((value) {
                                  widget.callbackFunction(2);
                                });
                              }
                            },
                          );
                        }
                      },
                      child: Text(
                        _step <= 2 ? "Continuar" : "Finalizar",
                      ),
                    ),
                  ),
                  SizedBox(width: constraints.maxWidth * .05),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_step != 0) {
                            _step = _step - 1;
                          }
                        });
                      },
                      child: const Text(
                        "Voltar",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      steps: [
        Step(
          isActive: _step == 0,
          state: _step > 0 ? StepState.complete : StepState.indexed,
          title: const Text("Informações do Produto"),
          content: Form(
            key: _firstFormKey,
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  .09,
                  .9,
                  constraints,
                  'Nome do Produto',
                  _nameController,
                  validators.nameValidator,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  .2,
                  .9,
                  constraints,
                  'Detalhes do Produto',
                  _detailsController,
                  validators.nameValidator,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                SizedBox(
                  width: constraints.maxWidth * .9,
                  child: DropdownButtonFormField<String>(
                    itemHeight: constraints.maxHeight * .09,
                    value:
                        _selectedProducer.isNotEmpty ? _selectedProducer : null,
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
                    items: _producerList
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
              ],
            ),
          ),
        ),
        Step(
          isActive: _step == 1,
          state: _step > 1 ? StepState.complete : StepState.indexed,
          title: const Text("Categorias"),
          content: Column(
            children: [
              SizedBox(height: constraints.maxHeight * .02),
              Text(
                "Selecione as categorias que se aplicam ao seu produto",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                  fontSize: constraints.maxHeight * .024,
                ),
              ),
              SizedBox(height: constraints.maxHeight * .05),
              Center(
                child: SizedBox(
                  height: constraints.maxHeight * .25,
                  width: constraints.maxWidth,
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(_categoryList.length, (index) {
                      return ChoiceChip(
                        label: Text(_categoryList[index]),
                        selected: _categoryBoolList[index],
                        selectedColor: const Color.fromRGBO(83, 242, 166, 0.69),
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
            ],
          ),
        ),
        Step(
          isActive: _step == 2,
          state: _step > 2 ? StepState.complete : StepState.indexed,
          title: const Text("Valores e Estoque"),
          content: Form(
            key: _secondFormKey,
            child: Column(
              children: [
                _textField1(
                  .09,
                  .9,
                  constraints,
                  'Preço',
                  _priceController,
                  validators.precoValidate,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  .09,
                  .9,
                  constraints,
                  'Estoque',
                  _stockQuantityController,
                  validators.precoValidate,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  .095,
                  .9,
                  constraints,
                  'Unidade de Valor',
                  _unitValueController,
                  validators.precoValidate,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                SizedBox(
                  width: constraints.maxWidth * .9,
                  child: DropdownButtonFormField<String>(
                    itemHeight: constraints.maxHeight * .09,
                    value: _selectedUnit.isNotEmpty ? _selectedUnit : null,
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
                        _selectedUnit = value!;
                      });
                    },
                    items: _unitList
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
              ],
            ),
          ),
        ),
        Step(
          title: const Text("Foto"),
          content: Column(
            children: [
              SizedBox(height: constraints.maxHeight * .03),
              Row(
                children: [
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
                  SizedBox(width: constraints.maxWidth * .05),
                  InkWell(
                    onTap: () => getImage("product"),
                    child: Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined),
                        SizedBox(width: constraints.maxWidth * .01),
                        const Text(
                          "Escolher Foto",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: constraints.maxHeight * .03)
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.4,
            child: Column(
              children: [
                NameAndIcon(
                  constraints: constraints,
                  icon: Icons.favorite,
                  text: 'Adicionar Produto',
                ),
                SizedBox(height: constraints.maxHeight * .02),
                SizedBox(
                  height: constraints.maxHeight * .1,
                  width: constraints.maxWidth,
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "Produto"),
                      Tab(text: "Box"),
                    ],
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .02),
                SizedBox(
                  height: constraints.maxHeight * 1,
                  width: constraints.maxWidth,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      addProductForm(constraints, context),
                      addBoxForm(constraints, context),
                    ],
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .05),
              ],
            ),
          ),
        );
      },
    );
  }
}
