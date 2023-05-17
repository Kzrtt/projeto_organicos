import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';
import '../../utils/userState.dart';

class UserInfoScreen extends StatefulWidget {
  User user;
  final void Function(int newValue) callbackFunction;
  UserInfoScreen({
    Key? key,
    required this.user,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _cellController = TextEditingController();

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
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: SizedBox(
          height: constraints.maxHeight * 1.3,
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.person,
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
                widget.user.userName,
                _nameController,
              ),
              SizedBox(height: constraints.maxHeight * .03),
              _textField1(
                55,
                330,
                constraints,
                widget.user.userCpf,
                _cpfController,
              ),
              SizedBox(height: constraints.maxHeight * .03),
              _textField1(
                55,
                330,
                constraints,
                widget.user.userCell,
                _cellController,
              ),
              SizedBox(height: constraints.maxHeight * .03),
              _textField1(
                55,
                330,
                constraints,
                widget.user.birthdate.substring(0, 10),
                _birthDateController,
              ),
              SizedBox(height: constraints.maxHeight * .05),
              InkWell(
                onTap: () async {
                  final userState = Provider.of<UserState>(
                    context,
                    listen: false,
                  );
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? id = prefs.getString('userId');
                  User newUser = User(
                    userName: _nameController.text,
                    userCpf: _cpfController.text,
                    userEmail: '',
                    userCell: _cellController.text,
                    password: "",
                    birthdate: _birthDateController.text,
                    isSubscriber: false,
                    isNutritious: false,
                  );
                  UserController provider = UserController();
                  provider.updateClient(id, newUser, widget.user);
                  userState.setUser(newUser);
                  widget.callbackFunction(3);
                },
                child: CommonButton(
                    constraints: constraints, text: "Salvar Alterações"),
              ),
            ],
          ),
        ),
      );
    });
  }
}
