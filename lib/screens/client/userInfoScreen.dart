import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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

  Widget _textField2(double height, double width, BoxConstraints constraints,
      String text, TextEditingController controller) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(
            Icons.visibility,
            color: Color.fromRGBO(83, 242, 166, 0.69),
          ),
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
      return Column(
        children: [
          NameAndIcon(
            constraints: constraints,
            icon: Icons.person,
            text: "Dados do Perfil",
          ),
          SizedBox(height: constraints.maxHeight * .04),
          _textField1(55, 330, constraints, 'Nome', _nameController),
          SizedBox(height: constraints.maxHeight * .03),
          _textField1(55, 330, constraints, 'E-mail', _emailController),
          SizedBox(height: constraints.maxHeight * .03),
          _textField1(55, 330, constraints, 'Cpf', _cpfController),
          SizedBox(height: constraints.maxHeight * .03),
          _textField1(
              55, 330, constraints, 'Data de Nascimento', _birthDateController),
          SizedBox(height: constraints.maxHeight * .03),
          _textField2(55, 330, constraints, 'Senha', _passwordController),
          SizedBox(height: constraints.maxHeight * .03),
          _textField2(55, 330, constraints, 'Confirmar Senha',
              _confirmPasswordController),
          SizedBox(height: constraints.maxHeight * .05),
          CommonButton(constraints: constraints, text: "Salvar Alterações"),
        ],
      );
    });
  }
}
