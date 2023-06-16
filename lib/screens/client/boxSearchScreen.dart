import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

class BoxSearchScreen extends StatefulWidget {
  const BoxSearchScreen({Key? key}) : super(key: key);

  @override
  State<BoxSearchScreen> createState() => _BoxSearchScreenState();
}

class _BoxSearchScreenState extends State<BoxSearchScreen> {
  List<Box> _boxes = [];
  List<Box> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_filterItems);
    UserController controller = UserController();
    controller.getAllBoxes().then((value) {
      for (var element in value) {
        if (element.boxQuantity > 0) {
          setState(() {
            _boxes.add(element);
            isLoading = false;
          });
        }
      }
      setState(() {
        _filteredItems = _boxes;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  String truncateString(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength - 3) + '...';
    }
    return text;
  }

  void _filterItems() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _boxes
          .where((item) => item.boxName.toLowerCase().contains(searchText))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.shopping_bag,
                text: "Boxes",
              ),
              SizedBox(height: constraints.maxHeight * .03),
              SizedBox(
                height: constraints.maxHeight * .08,
                width: constraints.maxWidth * .95,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: constraints.maxWidth * .03),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color.fromRGBO(108, 168, 129, 0.7),
                    ),
                    hintText: "Busca",
                    hintStyle: TextStyle(
                      fontSize: constraints.maxHeight * .02,
                    ),
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * .03),
              isLoading
                  ? Column(
                      children: [
                        SizedBox(height: constraints.maxHeight * .3),
                        Center(
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(113, 227, 154, 1),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: constraints.maxHeight * .7,
                      width: constraints.maxWidth,
                      child: ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          Box item = _filteredItems[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.BOXSCREEN,
                                arguments: item,
                              );
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * .02),
                              child: Container(
                                height: constraints.maxHeight * .3,
                                width: constraints.maxWidth * .9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height:
                                                  constraints.maxHeight * .24,
                                              width: constraints.maxWidth * .45,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  bottomLeft:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    constraints.maxHeight *
                                                        .02),
                                                child: Container(
                                                  height:
                                                      constraints.maxHeight *
                                                          .3,
                                                  width:
                                                      constraints.maxWidth * .4,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: item.boxPhoto != ""
                                                      ? Image.network(
                                                          item.boxPhoto,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Center(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: constraints.maxHeight *
                                                    .001),
                                          ],
                                        ),
                                        SizedBox(
                                            height: constraints.maxWidth * .05),
                                        Container(
                                          height: constraints.maxHeight * .24,
                                          width: constraints.maxWidth * .4,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: constraints.maxHeight * .025,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.boxName,
                                                  style: TextStyle(
                                                    fontSize:
                                                        constraints.maxHeight *
                                                            .02,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  item.boxDetails,
                                                  style: TextStyle(
                                                    fontSize:
                                                        constraints.maxHeight *
                                                            .019,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.68),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      constraints.maxHeight *
                                                          .03,
                                                ),
                                                SizedBox(
                                                  height:
                                                      constraints.maxHeight *
                                                          .10,
                                                  width: constraints.maxWidth,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        item.produtos.length < 3
                                                            ? item
                                                                .produtos.length
                                                            : 3,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var products =
                                                          item.produtos[index];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: constraints
                                                                  .maxWidth *
                                                              .001,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              size: constraints
                                                                      .maxHeight *
                                                                  .01,
                                                            ),
                                                            SizedBox(
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .02),
                                                            Text(
                                                              "${truncateString(products.product.productName, 14)} ",
                                                            ),
                                                            Text(
                                                              "${products.quantity.toString()}${products.product.measurementUnit}",
                                                            ),
                                                            SizedBox(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    .02),
                                                            item.produtos
                                                                        .length >
                                                                    3
                                                                ? Text(
                                                                    "Mostrar mais...",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          constraints.maxHeight *
                                                                              .02,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                              .fromRGBO(
                                                                          113,
                                                                          227,
                                                                          154,
                                                                          1),
                                                                    ),
                                                                  )
                                                                : Center()
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      constraints.maxHeight *
                                                          .01,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              constraints.maxWidth * .12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${item.boxQuantity} unidades",
                                            style: TextStyle(
                                              fontSize:
                                                  constraints.maxHeight * .02,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  constraints.maxHeight * .01),
                                          Text(
                                            "R\$${item.boxPrice}",
                                            style: TextStyle(
                                              fontSize:
                                                  constraints.maxHeight * .02,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromRGBO(
                                                  113, 227, 154, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
