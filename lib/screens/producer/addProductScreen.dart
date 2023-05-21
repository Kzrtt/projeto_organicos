// ignore_for_file: unused_field

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/measurementUnitController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/measurementUnit.dart';
import 'package:projeto_organicos/model/producers.dart';
import 'package:projeto_organicos/model/products.dart';
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
  String _selectedProducer = "";
  String _selectedUnit = "";
  List<String> _unitList = [];
  List<String> _categoryList = [];
  List<String> _producerList = [];
  List<bool> _categoryBoolList = [];
  List<Category> _categorias = [];
  List<Producers> _p = [];
  List<Measurement> _measurementList = [];
  TabController? _tabController;
  ProductController pcontroller = ProductController();
  int _step = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    CooperativeController coopController = CooperativeController();
    MeasuremntUnitController unityController = MeasuremntUnitController();
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
    unityController.getAllMeasuremntUnits().then((value) {
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
                      onPressed: () {
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
                        } else if (_step == 3) {
                          List<String> listaDeId = [];
                          for (var i = 0; i < _categoryList.length; i++) {
                            if (_categoryBoolList[i]) {
                              listaDeId.add(_categorias[i].categoryId);
                            }
                          }
                          int index = _producerList.indexOf(_selectedProducer);
                          int index2 = _unitList.indexOf(_selectedUnit);
                          ProductController controller = ProductController();
                          Products product = Products(
                            productId: "",
                            productName: _nameController.text,
                            category: listaDeId,
                            productPhoto: "",
                            productPrice: double.parse(_priceController.text),
                            stockQuantity:
                                int.parse(_stockQuantityController.text),
                            unitValue: _unitValueController.text,
                            productDetails: _detailsController.text,
                            cooperativeId: "",
                            producerId: _p[index].producerId,
                            measuremntUnit: _measurementList[index2].id,
                          );
                          controller.createProduct(product);
                          widget.callbackFunction(2);
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
          isActive: _step == 3,
          state: _step > 3 ? StepState.complete : StepState.indexed,
          title: const Text("Foto do Produto"),
          content: Column(
            children: [
              SizedBox(height: constraints.maxHeight * .03),
              Row(
                children: [
                  Container(
                    height: constraints.maxHeight * .2,
                    width: constraints.maxWidth * .3,
                    color: Colors.grey,
                    child: const Icon(Icons.camera_alt_rounded),
                  ),
                  SizedBox(width: constraints.maxWidth * .05),
                  InkWell(
                    onTap: () {},
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
            height: constraints.maxHeight * 1.3,
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
                      Center(),
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
