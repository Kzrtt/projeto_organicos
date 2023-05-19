import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/producers.dart';
import 'package:projeto_organicos/utils/validators.dart';

class AddProducerScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  const AddProducerScreen({
    Key? key,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<AddProducerScreen> createState() => _AddProducerScreenState();
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

class _AddProducerScreenState extends State<AddProducerScreen> {
  Validators validators = Validators();
  final _addProducerForm = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cellController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  var maskFormatterBirth = MaskTextInputFormatter(
      mask: '####-##-##', filter: {'#': RegExp(r'[0-9]')});
  var maskFormatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
  var maskFormatterPhone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {'#': RegExp(r'[0-9]')});

  Widget _textField2(
    double height,
    double width,
    BoxConstraints constraints,
    String text,
    TextEditingController controller,
    String? Function(String?) validator,
    MaskTextInputFormatter formatter,
  ) {
    return SizedBox(
      height: constraints.maxHeight * height,
      width: constraints.maxWidth * width,
      child: TextFormField(
        inputFormatters: [formatter],
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.person,
                text: "Adicionar Produtor",
              ),
              SizedBox(height: constraints.maxHeight * .07),
              Form(
                key: _addProducerForm,
                child: Column(
                  children: [
                    _textField1(
                      .09,
                      .9,
                      constraints,
                      "Nome do Produtor",
                      _nameController,
                      validators.nameValidator,
                    ),
                    SizedBox(height: constraints.maxHeight * .03),
                    _textField2(
                      .09,
                      .9,
                      constraints,
                      "Cpf",
                      _cpfController,
                      validators.cpfValidate,
                      maskFormatterCpf,
                    ),
                    SizedBox(height: constraints.maxHeight * .03),
                    _textField2(
                      .09,
                      .9,
                      constraints,
                      "Telefone",
                      _cellController,
                      validators.phoneValidator,
                      maskFormatterPhone,
                    ),
                    SizedBox(height: constraints.maxHeight * .03),
                    _textField2(
                      .09,
                      .9,
                      constraints,
                      "Data de Nascimento",
                      _birthDateController,
                      validators.birthDateValidator,
                      maskFormatterBirth,
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraints.maxHeight * .06),
              InkWell(
                onTap: () async {
                  if (_addProducerForm.currentState!.validate()) {
                    CooperativeController cooperativeController =
                        CooperativeController();
                    Producers producer = Producers(
                      producerId: "",
                      producerName: _nameController.text,
                      producerCell: _cellController.text,
                      producerCpf: _cpfController.text,
                      birthDate: _birthDateController.text,
                    );
                    cooperativeController.createProducer(
                      producer,
                      context,
                    );
                    widget.callbackFunction(2);
                  }
                },
                child: CommonButton(
                  constraints: constraints,
                  text: "Salvar Produtor",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
