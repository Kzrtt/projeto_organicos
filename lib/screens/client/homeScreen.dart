import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/whiteRoundedCornersBox.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/box.dart';
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
  List<Category> categorias = [];
  List<Box> boxes = [];
  bool isLoading = true;
  late User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserController controller = UserController();
    controller.getAllCategorys().then((value) {
      setState(() {
        categorias = value;
      });
    });

    controller.getAllBoxes().then((value) {
      for (var element in value) {
        if (element.boxQuantity > 0) {
          setState(() {
            boxes.add(element);
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: const Color.fromRGBO(113, 227, 154, 1)))
            : Container(
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
                          padding:
                              EdgeInsets.only(left: constraints.maxWidth * .05),
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
                          child: boxes.isNotEmpty
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemCount: boxes.length,
                                  itemBuilder: (context, index) {
                                    var item = boxes[index];
                                    return Padding(
                                      padding: EdgeInsets.all(
                                          constraints.maxHeight * .01),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.BOXSCREEN,
                                            arguments: item,
                                          );
                                        },
                                        child: WhiteRoundedCornersBox(
                                            text: item.boxName),
                                      ),
                                    );
                                  },
                                  primary: false,
                                  padding:
                                      EdgeInsets.all(constraints.maxWidth * .1),
                                )
                              : Center(
                                  child:
                                      Text("Nenhuma Box disponivel no momento"),
                                ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () => widget.callbackFunction(10),
                                child: CommonButton(
                                  constraints: constraints,
                                  text: "Explorar",
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * .04),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: constraints.maxWidth * .08),
                                child: const Text(
                                  "Explore nossas categorias de produtos: ",
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.71),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * .03),
                              SizedBox(
                                height: constraints.maxHeight * .2,
                                width: constraints.maxWidth,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categorias.length,
                                  itemBuilder: (context, index) {
                                    var item = categorias[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.CATEGORYPRODUCTS,
                                          arguments: item,
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            constraints.maxHeight * .02),
                                        child: Container(
                                          height: constraints.maxHeight * .14,
                                          width: constraints.maxWidth * .28,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            color: Color.fromRGBO(
                                                112, 250, 151, 0.33),
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.categoryName,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
