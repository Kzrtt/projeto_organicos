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
    measurementUnitController unityController = measurementUnitController();
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
      if (element.id == product.measurementUnit) {
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
                        onPressed: () {},
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
        steps: [],
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
