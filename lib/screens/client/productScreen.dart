import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/smallButton.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/cartProvider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int value = 1;

  @override
  Widget build(BuildContext context) {
    Products product = ModalRoute.of(context)?.settings.arguments as Products;

    Widget box(BoxConstraints constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * .12,
            width: constraints.maxWidth * .2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            child: Center(),
          ),
          SizedBox(height: constraints.maxHeight * .03),
          Text(
            product.productName,
            style: TextStyle(
              fontSize: constraints.maxHeight * .02,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: constraints.maxHeight * .01),
          Text(
            "R\$${product.productPrice}",
            style: TextStyle(
              fontSize: constraints.maxHeight * .02,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(113, 227, 154, 1),
            ),
          ),
        ],
      );
    }

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
                product.productName,
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
                  SizedBox(height: constraints.maxHeight * .02),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: constraints.maxHeight * .35,
                        width: constraints.maxWidth * .7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                        child: Center(),
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            product.productName,
                            style: TextStyle(
                              fontSize: constraints.maxHeight * .035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: constraints.maxWidth * .1),
                          Text(
                            "R\$${product.productPrice}",
                            style: TextStyle(
                              fontSize: constraints.maxHeight * .03,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(113, 227, 154, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * .02),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: constraints.maxWidth * .14,
                    ),
                    child: Text(
                      product.productDetails,
                      style: TextStyle(
                        fontSize: constraints.maxHeight * .025,
                        color: const Color.fromRGBO(0, 0, 0, 0.68),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .045),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (value > 1) {
                                setState(() {
                                  value = value - product.unitValue;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            "${value}${product.measuremntUnit}",
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              if (value <= product.stockQuantity) {
                                setState(() {
                                  value = value + product.unitValue;
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      SizedBox(width: constraints.maxWidth * .05),
                      InkWell(
                        onTap: () {
                          CartController controller = CartController();
                          controller.addProductToCart(product.productId, value);
                          Navigator.of(context).pop();
                        },
                        child: SmallButton(
                          constraints: constraints,
                          text: "Adicionar",
                          color: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * .06),
                  Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth * .05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Produtos Recomendados: ",
                          style: TextStyle(
                            fontSize: constraints.maxHeight * .026,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        Padding(
                          padding: EdgeInsets.only(
                            left: constraints.maxWidth * .05,
                          ),
                          child: Row(
                            children: [
                              box(constraints),
                              SizedBox(width: constraints.maxWidth * .05),
                              box(constraints),
                              SizedBox(width: constraints.maxWidth * .05),
                              box(constraints),
                            ],
                          ),
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