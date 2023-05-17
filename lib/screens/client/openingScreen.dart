// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/providers/cooperativeProvider.dart';
import 'package:projeto_organicos/providers/userProvider.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/userState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  _textField1(55, 330, constraints, 'e-mail', emailController),
                  SizedBox(height: constraints.maxHeight * .022),
                  _textField1(
                      55, 330, constraints, 'senha', passwordController),
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
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoutes.SIGNUPSCREEN),
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
                          onTap: () async {
                            if (emailController.text == "produtor") {
                              Navigator.of(context).pushReplacementNamed(
                                  ProducerAppRoutes.PRODUCERHOMETAB);
                            } else {
                              UserProvider _provider = UserProvider();
                              CooperativeProvider _cprovider =
                                  CooperativeProvider();
                              String response = await _provider.login(
                                emailController.text,
                                passwordController.text,
                                context,
                              );
                              if (response == "telaCliente") {
                                final userState = Provider.of<UserState>(
                                  context,
                                  listen: false,
                                );
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                String? userId = _prefs.getString('userId');
                                _provider.getClient(userId).then((value) {
                                  User user = value;
                                  userState.setUser(user);
                                  Navigator.of(context).pushReplacementNamed(
                                    AppRoutes.HOMETAB,
                                  );
                                });
                              } else {
                                final cooperativeState =
                                    Provider.of<CooperativeState>(
                                  context,
                                  listen: false,
                                );
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                String? cooperativeId =
                                    _prefs.getString("cooperativeId");
                                _cprovider
                                    .getCooperative(cooperativeId)
                                    .then((value) {
                                  Cooperative cooperative = value;
                                  cooperativeState.setCooperative(cooperative);
                                  Navigator.of(context).pushReplacementNamed(
                                    ProducerAppRoutes.PRODUCERHOMETAB,
                                  );
                                });
                              }
                            }
                          },
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
                  Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * .023),
                      SvgPicture.asset(
                        'assets/images/undraw_appreciation_r2a1.svg',
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
                      ),
                      SizedBox(height: constraints.maxHeight * .1),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(ProducerAppRoutes.PRODUCERSIGNUP),
                        child: Text(
                          "Cadastre-se como Cooperativa e venda conosco",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: constraints.maxHeight * .02,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ),
                      ),
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
