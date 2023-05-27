import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/model/box.dart';

class BoxScreen extends StatefulWidget {
  const BoxScreen({Key? key}) : super(key: key);

  @override
  State<BoxScreen> createState() => _BoxScreenState();
}

class _BoxScreenState extends State<BoxScreen> {
  @override
  Widget build(BuildContext context) {
    Box box = ModalRoute.of(context)?.settings.arguments as Box;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
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
        actions: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag,
                color: Color.fromRGBO(108, 168, 129, 0.7),
              ),
              const SizedBox(width: 10),
              Text(
                box.boxName,
                style: const TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight * 1.2,
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight * .03),
                      Container(
                        height: constraints.maxHeight * .2,
                        width: constraints.maxWidth * .85,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * .11,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              box.boxName,
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .025,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "R\$${box.boxPrice}",
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .025,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(113, 227, 154, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxHeight * .06,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Produtos: ",
                          style: TextStyle(
                            fontSize: constraints.maxHeight * .024,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height:
                              constraints.maxHeight * box.produtos.length / 10 +
                                  50,
                          width: constraints.maxWidth,
                          child: ListView.builder(
                            itemCount: box.produtos.length,
                            itemBuilder: (context, index) {
                              var item = box.produtos[index];
                              return Column(
                                children: [
                                  Container(
                                    height: constraints.maxHeight * .1,
                                    width: constraints.maxWidth * .9,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: constraints.maxHeight * .1,
                                          width: constraints.maxWidth * .44,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(item.product.productName),
                                              Text(
                                                "Quantiade: ${item.quantity}${item.product.measuremntUnit}",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: constraints.maxHeight * .1,
                                          width: constraints.maxWidth * .34,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.remove),
                                              ),
                                              Text(
                                                "${item.quantity}${item.product.measuremntUnit}",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .02),
                                ],
                              );
                            },
                          ),
                        ),
                        Text(
                          "Fotos dos produtos: ",
                          style: TextStyle(
                            fontSize: constraints.maxHeight * .024,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        SizedBox(
                          height: constraints.maxHeight * .1,
                          width: constraints.maxWidth,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: box.produtos.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  SizedBox(width: constraints.maxWidth * .05),
                                  Container(
                                    height: constraints.maxHeight * .12,
                                    width: constraints.maxWidth * .2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey,
                                    ),
                                    child: Center(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .05),
                        CommonButton(
                          constraints: constraints,
                          text: "Adicioar ao Carrinho",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}