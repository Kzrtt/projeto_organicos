// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/model/adress.dart';
import 'package:projeto_organicos/utils/userState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/userController.dart';

class AddAdressScreen extends StatefulWidget {
  const AddAdressScreen({Key? key}) : super(key: key);

  @override
  State<AddAdressScreen> createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
            children: const [
              Icon(Icons.map, color: Color.fromRGBO(108, 168, 129, 0.7)),
              SizedBox(width: 10),
              Text(
                "Cadastro de Endereço",
                style: TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
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
                  SizedBox(height: constraints.maxHeight * .05),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Apelido do Endereço",
                    _nickNameController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Complemento",
                    _complementController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Rua",
                    _streetController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Cidade",
                    _cityController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Estado",
                    _stateController,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Cep",
                    _zipCodeController,
                  ),
                  SizedBox(height: constraints.maxHeight * .05),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      UserController provider = UserController();
                      // ignore: use_build_context_synchronously
                      final userState = Provider.of<UserState>(
                        context,
                        listen: false,
                      );
                      Adress adress = Adress(
                        adressId: "0",
                        nickname: _nickNameController.text,
                        complement: _complementController.text,
                        street: _streetController.text,
                        city: _cityController.text,
                        state: _stateController.text,
                        zipCode: _zipCodeController.text,
                      );
                      String? id = prefs.getString("userId");
                      provider.createAdress(adress, id!);
                      userState.addAdress(adress);
                      Navigator.pop(context, adress);
                    },
                    child: CommonButton(
                      constraints: constraints,
                      text: "Cadastrar",
                    ),
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
