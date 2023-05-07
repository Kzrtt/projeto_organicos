import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCartEmpty = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              stops: [0.8, 1],
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(238, 238, 238, 1),
                Color.fromRGBO(83, 242, 166, 1),
              ],
            ),
          ),
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.shopping_cart,
                text: "Carrinho",
              ),
              SizedBox(height: constraints.maxHeight * .13),
              isCartEmpty
                  ? Center()
                  : Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/undraw_shopping_app.svg',
                            height: constraints.maxHeight * .3,
                            width: constraints.maxWidth * .3,
                          ),
                          SizedBox(height: constraints.maxHeight * .07),
                          Text(
                            "Seu Carrinho está vaizo :(",
                            style: TextStyle(
                              fontSize: constraints.maxHeight * .025,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .015),
                          SizedBox(
                            width: constraints.maxWidth * .65,
                            child: Text(
                              "Adicione produtos ao seu carrinho e retorne para está página",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .02,
                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
