import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/controller/measurementUnitController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/products.dart';

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

class _UpdateProductScreenState extends State<UpdateProductScreen>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;
  final Validators validators = Validators();
  final _firstFormKey = GlobalKey<FormState>();
  final _secondFormKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    Products product = ModalRoute.of(context)?.settings.arguments as Products;
    Producers producer = Producers(
      producerId: "producerId",
      producerName: "producerName",
      producerCell: "producerCell",
      producerCpf: "producerCpf",
      birthDate: "birthDate",
    );
    Measurement measurement = const Measurement(
      id: "id",
      measurementUnit: "measurementUnit",
    );

    for (var element in _p) {
      if (element.producerId == product.producerId) {
        producer = element;
        break;
      }
    }

    for (var element in _measurementList) {
      if (element.id == product.measuremntUnit) {
        measurement = element;
        break;
      }
    }

    String _selectedProducer = "";
    String _selectedUnit = "";
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _detailsController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _stockQuantityController =
        TextEditingController();
    final TextEditingController _unitValueController = TextEditingController();

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

                            int index =
                                _producerList.indexOf(_selectedProducer);
                            int index2 = _unitList.indexOf(_selectedUnit);
                            ProductController controller = ProductController();
                            Products newProduct = Products(
                              productId: "",
                              productName: _nameController.text.isNotEmpty
                                  ? _nameController.text
                                  : "",
                              category: listaDeId,
                              productPhoto: "",
                              productPrice: _priceController.text.isNotEmpty
                                  ? double.parse(_priceController.text)
                                  : 0,
                              stockQuantity: _stockQuantityController
                                      .text.isNotEmpty
                                  ? double.parse(_stockQuantityController.text)
                                  : 0,
                              unitValue: _unitValueController.text.isNotEmpty
                                  ? int.parse(_unitValueController.text)
                                  : 0,
                              productDetails: _detailsController.text.isNotEmpty
                                  ? _detailsController.text
                                  : "",
                              cooperativeId: "",
                              producerId: _p[index].producerId,
                              measuremntUnit: _measurementList[index2].id,
                            );
                            controller.updateProduct(
                              product.productId,
                              newProduct,
                              product,
                            );
                            Navigator.pop(context, newProduct);
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
                    product.productName,
                    _nameController,
                    validators.nameValidator2,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    .2,
                    .9,
                    constraints,
                    product.productDetails,
                    _detailsController,
                    validators.nameValidator2,
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
                        producer.producerName,
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
                  _textField2(
                    .09,
                    .9,
                    constraints,
                    product.productPrice.toString(),
                    _priceController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField2(
                    .09,
                    .9,
                    constraints,
                    product.stockQuantity.toString(),
                    _stockQuantityController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField2(
                    .095,
                    .9,
                    constraints,
                    product.unitValue.toString(),
                    _unitValueController,
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
              height: constraints.maxHeight * 1.3,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .02),
                  SizedBox(
                    height: constraints.maxHeight * 1,
                    width: constraints.maxWidth,
                    child: addProductForm(constraints, context),
                  ),
                  SizedBox(height: constraints.maxHeight * .05),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
