import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxProducerEdition.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/sell.dart';

class OpenSells extends StatefulWidget {
  const OpenSells({Key? key}) : super(key: key);

  @override
  State<OpenSells> createState() => _OpenSellsState();
}

class _OpenSellsState extends State<OpenSells> {
  List<Sell> _sells = [];
  List<Products> _products = [];
  List<Map<String, dynamic>> neededProduts = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CooperativeController controller = CooperativeController();
    ProductController productController = ProductController();
    productController.getAllProducts().then((value) {
      setState(() {
        _products = value;
      });
    });
    controller.getAllSells().then((value) {
      setState(() {
        _sells = value;
        isLoading = false;
      });
    });
    controller.getAllNeededProducts().then((value) {
      setState(() {
        neededProduts = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            NameAndIcon(
              constraints: constraints,
              icon: Icons.star,
              text: "Pedidos Abertos",
            ),
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
                    height: constraints.maxHeight * .9,
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      itemCount: neededProduts.length,
                      itemBuilder: (context, index) {
                        var item = neededProduts[index];
                        return Padding(
                          padding: EdgeInsets.all(constraints.maxHeight * .02),
                          child: Container(
                            height: constraints.maxHeight *
                                neededProduts[index]['products'].length /
                                10,
                            width: constraints.maxWidth * .8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SizedBox(
                              height: constraints.maxHeight *
                                  neededProduts[index]['products'].length /
                                  10,
                              width: constraints.maxWidth * .8,
                              child: Column(
                                children: [
                                  Container(
                                    height: constraints.maxHeight * .08,
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: constraints.maxWidth * .05,
                                        vertical: constraints.maxHeight * .02,
                                      ),
                                      child: Text(
                                        "Data para Entrega: ${item['date']}",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.58),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .04),
                                  SizedBox(
                                    height: constraints.maxHeight *
                                        neededProduts[index]['products']
                                            .length /
                                        20,
                                    width: constraints.maxWidth * .8,
                                    child: ListView.builder(
                                      itemCount: item['products'].length,
                                      itemBuilder: (context, index) {
                                        var i = item['products'][index];
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${i['product'].productName}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        constraints.maxHeight *
                                                            .023,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.58),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  "${i['quantity'] * i['product'].unitValue}${i['product'].measurementUnit}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        constraints.maxHeight *
                                                            .023,
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.58),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: constraints.maxHeight *
                                                    .025),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}
