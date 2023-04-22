import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
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
                          Text(
                            "cadastre-se",
                            style: TextStyle(
                              fontSize: constraints.maxHeight * .02,
                              color: const Color.fromRGBO(83, 242, 166, 0.85),
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                SizedBox(height: constraints.maxHeight * .03),
                Container(
                  height: constraints.maxHeight * .5,
                  width: constraints.maxWidth * .83,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .04),
                Text.rich(
                  TextSpan(
                    text: "Fazer login com ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: constraints.maxHeight * .02,
                      color: const Color.fromRGBO(0, 0, 0, 0.42),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "google",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                          fontSize: constraints.maxHeight * .02,
                          color: const Color.fromRGBO(0, 0, 0, 0.42),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
