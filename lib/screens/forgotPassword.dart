import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/smallButton.dart';
import 'package:projeto_organicos/controller/passwordController.dart';
import 'package:projeto_organicos/utils/validators.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
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
    height: height,
    width: width,
    child: TextFormField(
      controller: controller,
      validator: validator,
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

Widget thinDivider(BoxConstraints constraints) {
  return Center(
    child: Container(
      height: 0.8,
      width: constraints.maxWidth * .7,
      color: Color.fromRGBO(83, 242, 166, 1),
    ),
  );
}

class _ForgotPasswordState extends State<ForgotPassword> {
  Validators validators = Validators();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final passwordsKey = GlobalKey<FormState>();
  bool isEmailSent = false;
  String token = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          Row(
            children: [
              Icon(Icons.star, color: Color.fromRGBO(108, 168, 129, 0.7)),
              SizedBox(width: 10),
              Text(
                "Esqueceu a Senha",
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
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                !isEmailSent
                    ? Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * .05),
                          Form(
                            key: emailFormKey,
                            child: _textField1(
                              55,
                              350,
                              constraints,
                              'E-mail',
                              emailController,
                              validators.emailValidator,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Escreva o email da conta",
                                style: TextStyle(
                                  color: Color.fromRGBO(18, 18, 18, 0.58),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (emailFormKey.currentState!.validate()) {
                                    PasswordController controller =
                                        PasswordController();
                                    controller.forgotPassword(
                                      emailController.text,
                                      context,
                                    );
                                    setState(() {
                                      isEmailSent = true;
                                    });
                                  }
                                },
                                child: SmallButton(
                                  constraints: constraints,
                                  text: "Enviar Email",
                                  color: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: constraints.maxHeight * .05),
                        ],
                      )
                    : Center(),
                isEmailSent
                    ? Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * .05),
                          const Text(
                            "Escreva o token que recebeu pelo email abaixo: ",
                            style: TextStyle(
                              color: Color.fromRGBO(18, 18, 18, 0.58),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .05),
                          SizedBox(
                            height: constraints.maxHeight * .1,
                            width: constraints.maxWidth * .75,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                              ),
                              onChanged: (value) {},
                              onCompleted: (value) {
                                setState(() {
                                  token = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .05),
                          Form(
                            key: passwordsKey,
                            child: Column(
                              children: [
                                _textField1(
                                  55,
                                  350,
                                  constraints,
                                  'Nova Senha',
                                  passwordController,
                                  validators.passwordValidator,
                                ),
                                SizedBox(height: constraints.maxHeight * .03),
                                _textField1(
                                  55,
                                  350,
                                  constraints,
                                  'Confirmar Senha',
                                  confirmPasswordController,
                                  validators.passwordValidator,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .08),
                          InkWell(
                            onTap: () {
                              if (passwordsKey.currentState!.validate()) {
                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  PasswordController controller =
                                      PasswordController();
                                  controller.resetPassword(
                                    emailController.text,
                                    token.toUpperCase(),
                                    passwordController.text,
                                    context,
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const AlertDialog(
                                        title: Text("As senhas não batem"),
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: CommonButton(
                                constraints: constraints, text: "Confirmar"),
                          ),
                        ],
                      )
                    : Center(),
              ],
            ),
          );
        },
      ),
    );
  }
}
