// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

enum userType { user, seller }

enum register { yes, no }

class _OpeningScreenState extends State<OpeningScreen> {
  int _step = 0;
  userType _character = userType.user;
  register _register = register.no;
  Widget _textField1(
      double height, double width, BoxConstraints constraints, String text) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
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
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              height: constraints.maxHeight * 1.3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  stops: [0.4, 1],
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(238, 238, 238, 1),
                    Color.fromRGBO(83, 242, 166, 1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .03),
                  Row(
                    children: [
                      SizedBox(width: constraints.maxWidth * .03),
                      const Text(
                        "Bem vindo ao Lorem Ipsum",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(55, 330, constraints, 'e-mail'),
                  SizedBox(height: constraints.maxHeight * .022),
                  _textField1(55, 330, constraints, 'senha'),
                  SizedBox(height: constraints.maxHeight * .05),
                  Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth * .075),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Não possui conta?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: constraints.maxHeight * .017,
                                color: const Color.fromRGBO(0, 0, 0, 0.58),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_register == register.no) {
                                  setState(() {
                                    _register = register.yes;
                                  });
                                } else {
                                  setState(() {
                                    _register = register.no;
                                  });
                                }
                              },
                              child: Text(
                                "cadastre-se",
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * .02,
                                  color:
                                      const Color.fromRGBO(83, 242, 166, 0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: constraints.maxWidth * .08),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.HOMETAB),
                          child: Container(
                            height: constraints.maxHeight * .06,
                            width: constraints.maxWidth * .5,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromRGBO(83, 242, 166, 0.47),
                            ),
                            child: Center(
                              child: Text(
                                "Iniciar",
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * .025,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .05),
                  _register == register.yes
                      ? Container(
                          height: constraints.maxHeight * .7,
                          width: constraints.maxWidth * .9,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Theme(
                            data: ThemeData(
                              colorScheme:
                                  Theme.of(context).colorScheme.copyWith(
                                        primary: const Color.fromRGBO(
                                            83, 242, 166, 0.47),
                                        secondary: const Color.fromRGBO(
                                            83, 242, 166, 0.47),
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
                                        _textField2(55, 330, constraints,
                                            'Nome completo'),
                                        SizedBox(
                                          height: constraints.maxHeight * .01,
                                        ),
                                        _textField2(
                                            55, 330, constraints, 'E-mail'),
                                        SizedBox(
                                          height: constraints.maxHeight * .01,
                                        ),
                                        _textField2(
                                            55, 330, constraints, 'Cpf'),
                                      ],
                                    )),
                                Step(
                                  title:
                                      const Text('Criar conta como Vendedor?'),
                                  content: Column(
                                    children: [
                                      Column(
                                        children: [
                                          ListTile(
                                            title: const Text('Usuario comum'),
                                            leading: Radio<userType>(
                                              activeColor: const Color.fromRGBO(
                                                  83, 242, 166, 0.47),
                                              value: userType.user,
                                              groupValue: _character,
                                              onChanged: (userType? value) {
                                                setState(() {
                                                  _character = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Vendedor'),
                                            leading: Radio<userType>(
                                              activeColor: const Color.fromRGBO(
                                                  83, 242, 166, 0.47),
                                              value: userType.seller,
                                              groupValue: _character,
                                              onChanged: (userType? value) {
                                                setState(() {
                                                  _character = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          _character == userType.seller
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                        height: constraints
                                                                .maxHeight *
                                                            .04),
                                                    _textField2(
                                                        55,
                                                        330,
                                                        constraints,
                                                        'Endereço'),
                                                    _textField2(55, 330,
                                                        constraints, 'Cnpj'),
                                                  ],
                                                )
                                              : Center()
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Step(
                                  title: Text('Senha'),
                                  content: Column(
                                    children: [
                                      _textField2(
                                          55, 330, constraints, 'Senha'),
                                      _textField2(55, 330, constraints,
                                          'Confirmar senha'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(height: constraints.maxHeight * .023),
                            SvgPicture.asset(
                              'assets/images/undraw_love_it_5nex.svg',
                              height: constraints.maxHeight * .3,
                              width: constraints.maxWidth * .3,
                            ),
                            SizedBox(height: constraints.maxHeight * .04),
                            Text(
                              "Bem vindo de volta",
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .03,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                            )
                          ],
                        ),
                  SizedBox(height: constraints.maxHeight * .1),
                ],
              ),
            ),
          );
        }));
  }
}
