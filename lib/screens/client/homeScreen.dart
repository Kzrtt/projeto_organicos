import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/whiteRoundedCornersBox.dart';

import '../../model/user.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final void Function(int newValue) callbackFunction;
  const HomeScreen({
    Key? key,
    required this.user,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: const Color.fromRGBO(238, 238, 238, 1),
          child: SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight * 1.2,
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * .024),
                  Center(
                    child: Text(
                      widget.user.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 0.58),
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .01),
                  Padding(
                    padding: EdgeInsets.all(constraints.maxHeight * .015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              color: Color.fromRGBO(108, 168, 129, 0.7),
                            ),
                            SizedBox(width: constraints.maxWidth * .01),
                            const Text(
                              "Home",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.8),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => widget.callbackFunction(1),
                          color: const Color.fromRGBO(108, 168, 129, 0.7),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth * .05),
                    child: const Text(
                      "Escolha sua box aqui: ",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.58),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: GridView.count(
                      primary: false,
                      padding: EdgeInsets.all(constraints.maxWidth * .1),
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      crossAxisCount: 2,
                      children: const [
                        WhiteRoundedCornersBox(text: "Personalizada"),
                        WhiteRoundedCornersBox(text: "Inverno"),
                        WhiteRoundedCornersBox(text: "Verão"),
                        WhiteRoundedCornersBox(text: "Queijos"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonButton(
                            constraints: constraints, text: "Explorar"),
                        SizedBox(height: constraints.maxHeight * .04),
                        Padding(
                          padding:
                              EdgeInsets.only(left: constraints.maxWidth * .08),
                          child: const Text(
                            "Explore nossas categorias de produtos: ",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.71),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: constraints.maxWidth * .05),
                            Container(
                              height: constraints.maxHeight * .14,
                              width: constraints.maxWidth * .28,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromRGBO(255, 23, 23, 0.33),
                              ),
                              child: const Center(child: Text("Carnes")),
                            ),
                            SizedBox(width: constraints.maxWidth * .05),
                            Container(
                              padding: const EdgeInsets.only(left: 16),
                              height: constraints.maxHeight * .14,
                              width: constraints.maxWidth * .28,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromRGBO(112, 250, 151, 0.33),
                              ),
                              child: const Center(
                                  child: Text("Agricultura Familiar")),
                            ),
                            SizedBox(width: constraints.maxWidth * .05),
                            Container(
                              height: constraints.maxHeight * .14,
                              width: constraints.maxWidth * .28,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: Color.fromRGBO(111, 176, 253, 0.33),
                              ),
                              child: const Center(child: Text("Verduras")),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
