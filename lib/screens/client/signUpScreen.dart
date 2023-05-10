import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum UserType { user, seller }

enum DietType { vegan, carnivore, vegetarian }

class _SignUpScreenState extends State<SignUpScreen> {
  int _step = 0;
  UserType _character = UserType.user;
  DietType _type = DietType.vegan;

  Widget _dietOption(String text, DietType type) {
    return ListTile(
      title: Text(text),
      leading: Radio<DietType>(
        activeColor: const Color.fromRGBO(83, 242, 166, 0.47),
        value: type,
        groupValue: _type,
        onChanged: (DietType? value) {
          setState(() {
            _type = value!;
          });
        },
      ),
    );
  }

  Widget _textField2(
      double height, double width, BoxConstraints constraints, String text) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromRGBO(83, 242, 166, 1),
              width: constraints.maxWidth * .01,
            ),
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
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(83, 242, 166, 0.69),
          ),
        ),
        actions: [
          Row(
            children: const [
              Icon(Icons.people, color: Color.fromRGBO(83, 242, 166, 0.69)),
              SizedBox(width: 10),
              Text(
                "Cadastro",
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
          return Column(
            children: [
              SizedBox(height: constraints.maxHeight * .03),
              Container(
                height: constraints.maxHeight * .8,
                width: constraints.maxWidth * .9,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: const Color.fromRGBO(83, 242, 166, 0.47),
                          secondary: const Color.fromRGBO(83, 242, 166, 0.47),
                        ),
                  ),
                  child: Stepper(
                    currentStep: _step,
                    onStepCancel: () {
                      if (_step > 0) {
                        setState(() {
                          _step -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (_step <= 0) {
                        setState(() {
                          _step += 1;
                        });
                      }
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        _step = index;
                      });
                    },
                    steps: <Step>[
                      Step(
                          title: const Text('Informações Pessoais'),
                          content: Column(
                            children: [
                              _textField2(
                                  55, 330, constraints, 'Nome completo'),
                              SizedBox(
                                height: constraints.maxHeight * .01,
                              ),
                              _textField2(55, 330, constraints, 'E-mail'),
                              SizedBox(
                                height: constraints.maxHeight * .01,
                              ),
                              _textField2(55, 330, constraints, 'Cpf'),
                              SizedBox(height: constraints.maxHeight * .01),
                              _textField2(
                                  55, 330, constraints, 'Data de Nascimento'),
                            ],
                          )),
                      Step(
                        title: const Text('Criar conta como Vendedor?'),
                        content: Column(
                          children: [
                            Column(
                              children: [
                                ListTile(
                                  title: const Text('Usuario comum'),
                                  leading: Radio<UserType>(
                                    activeColor: const Color.fromRGBO(
                                        83, 242, 166, 0.47),
                                    value: UserType.user,
                                    groupValue: _character,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _character = value!;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Vendedor'),
                                  leading: Radio<UserType>(
                                    activeColor: const Color.fromRGBO(
                                        83, 242, 166, 0.47),
                                    value: UserType.seller,
                                    groupValue: _character,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _character = value!;
                                      });
                                    },
                                  ),
                                ),
                                _character == UserType.seller
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height:
                                                  constraints.maxHeight * .04),
                                          _textField2(
                                              55, 330, constraints, 'Endereço'),
                                          _textField2(
                                              55, 330, constraints, 'Cnpj'),
                                        ],
                                      )
                                    : Center()
                              ],
                            )
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('Dieta'),
                        content: Column(
                          children: [
                            _dietOption("Vegano", DietType.vegan),
                            _dietOption("Carnivoro", DietType.carnivore),
                            _dietOption("Vegetariano", DietType.vegetarian),
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('Senha'),
                        content: Column(
                          children: [
                            _textField2(55, 330, constraints, 'Senha'),
                            _textField2(
                                55, 330, constraints, 'Confirmar senha'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * .05),
              CommonButton(
                  constraints: constraints, text: "Finalizar Cadastro"),
            ],
          );
        },
      ),
    );
  }
}
