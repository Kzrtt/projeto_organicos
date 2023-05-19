import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/utils/validators.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

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

class _AddProductScreenState extends State<AddProductScreen> {
  final Validators validators = Validators();
  final _addProductFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantity = TextEditingController();
  final TextEditingController _unitValue = TextEditingController();
  final TextEditingController _measurementUnity = TextEditingController();
  String _categorySelectedItem = "";
  String _selectedProducer = "";
  List<String> _categoryList = [];
  List<String> _producerList = [];

  Widget _comboBox(
    BoxConstraints constraints,
    double height,
    double width,
    double tamanho,
    String selectedItem,
    String text,
    List<String> items,
  ) {
    return SizedBox(
      width: constraints.maxWidth * width,
      child: DropdownButtonFormField<String>(
        itemHeight: constraints.maxHeight * height,
        value: selectedItem.isNotEmpty ? selectedItem : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: constraints.maxWidth * .03),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
        hint: Text(
          text,
          style: TextStyle(
            fontSize: constraints.maxHeight * tamanho,
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedItem = value.toString();
          });
        },
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.1,
            child: Column(
              children: [
                NameAndIcon(
                  constraints: constraints,
                  icon: Icons.favorite,
                  text: 'Adicionar Produto',
                ),
                SizedBox(height: constraints.maxHeight * .05),
                Form(
                  key: _addProductFormKey,
                  child: Column(
                    children: [
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
                        .09,
                        .9,
                        constraints,
                        'Detalhes do Produto',
                        _detailsController,
                        validators.nameValidator,
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _textField1(
                            .09,
                            .40,
                            constraints,
                            'Preço',
                            _priceController,
                            validators.nameValidator,
                          ),
                          SizedBox(width: constraints.maxWidth * .01),
                          _textField1(
                            .09,
                            .40,
                            constraints,
                            'Estoque',
                            _stockQuantity,
                            validators.nameValidator,
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      _comboBox(
                        constraints,
                        .09,
                        .9,
                        .02,
                        _categorySelectedItem,
                        "Categoria",
                        _categoryList,
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _textField1(
                            .095,
                            .40,
                            constraints,
                            'Unidade de Valor',
                            _unitValue,
                            validators.nameValidator,
                          ),
                          SizedBox(width: constraints.maxWidth * .01),
                          _comboBox(
                            constraints,
                            .09,
                            .40,
                            .02,
                            _selectedProducer,
                            "Produtor",
                            _producerList,
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      Padding(
                        padding:
                            EdgeInsets.only(left: constraints.maxWidth * .055),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                color: Color.fromRGBO(18, 18, 18, .58),
                              ),
                              SizedBox(width: constraints.maxWidth * .015),
                              const Text(
                                "Editar Imagens",
                                style: TextStyle(
                                  color: Color.fromRGBO(18, 18, 18, .58),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * .06),
                      InkWell(
                        onTap: () {},
                        child: CommonButton(
                          constraints: constraints,
                          text: "Salvar Produto",
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
