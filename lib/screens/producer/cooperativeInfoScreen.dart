import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/model/cooperativeAdress.dart';
import 'package:projeto_organicos/providers/cooperativeProvider.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cooperative.dart';

class CooperativeInfoScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  CooperativeInfoScreen({
    Key? key,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<CooperativeInfoScreen> createState() => _CooperativeInfoScreenState();
}

Widget _textField1(double height, double width, BoxConstraints constraints,
    String text, TextEditingController controller) {
  return SizedBox(
    height: height,
    width: width,
    child: TextField(
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

class _CooperativeInfoScreenState extends State<CooperativeInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cooperativeState = Provider.of<CooperativeState>(context);
    Cooperative? cooperative = cooperativeState.getCooperative;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.3,
            child: Column(
              children: [
                NameAndIcon(
                  constraints: constraints,
                  icon: Icons.people,
                  text: "Dados do Perfil",
                ),
                SizedBox(height: constraints.maxHeight * .04),
                Text(
                  "Preencha somente os campos que você deseja alterar",
                  style: TextStyle(
                    color: const Color.fromRGBO(18, 18, 18, 0.58),
                    fontWeight: FontWeight.bold,
                    fontSize: constraints.maxHeight * .017,
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .04),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative!.cooperativeName,
                  _nameController,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative.cooperativePhone,
                  _phoneController,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative.cooperativeAdress.complement,
                  _complementController,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative.cooperativeAdress.street,
                  _streetController,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative.cooperativeAdress.city,
                  _cityController,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative.cooperativeAdress.state,
                  _stateController,
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  55,
                  330,
                  constraints,
                  cooperative.cooperativeAdress.zipCode,
                  _zipCodeController,
                ),
                SizedBox(height: constraints.maxHeight * .05),
                InkWell(
                  onTap: () async {
                    final cooperativeState = Provider.of<CooperativeState>(
                      context,
                      listen: false,
                    );
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? id = prefs.getString("cooperativeId");
                    Cooperative newCooperative = Cooperative(
                      cooperativeEmail: "",
                      password: "",
                      cooperativeName: _nameController.text,
                      cooperativeCnpj: "",
                      cooperativeAdress: CooperativeAdress(
                        complement: _complementController.text,
                        street: _streetController.text,
                        city: _cityController.text,
                        state: _stateController.text,
                        zipCode: _zipCodeController.text,
                      ),
                      cooperativeProfilePhoto: "",
                      cooperativePhone: _phoneController.text,
                    );
                    CooperativeProvider cprovider = CooperativeProvider();
                    cprovider.updateCooperativa(
                      id,
                      newCooperative,
                      cooperative,
                    );
                    cooperativeState.setCooperative(newCooperative);
                    widget.callbackFunction(2);
                  },
                  child: CommonButton(
                    constraints: constraints,
                    text: "Salvar Alterações",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
