import 'package:flutter/material.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:provider/provider.dart';

import '../utils/cartProvider.dart';

class ProductsInCart extends StatefulWidget {
  final void Function(int, bool) callback;
  final void Function(Products) deleteProduct;
  BoxConstraints constraints;
  List<Map<String, dynamic>> cartMongodb;
  ProductsInCart({
    super.key,
    required this.constraints,
    required this.cartMongodb,
    required this.callback,
    required this.deleteProduct,
  });

  @override
  State<ProductsInCart> createState() => _ProductsInCartState();
}

class _ProductsInCartState extends State<ProductsInCart> {
  @override
  Widget build(BuildContext context) {
    List<int> quantity = Provider.of<CartProvider>(context).getQuantity;

    return Container(
      height:
          widget.constraints.maxHeight * widget.cartMongodb.length / 10 + 80,
      width: widget.constraints.maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: widget.constraints.maxWidth * .05,
            ),
            child: const Text(
              "Produtos:",
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, .81),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: widget.constraints.maxHeight * .03,
          ),
          SizedBox(
            height:
                widget.constraints.maxHeight * widget.cartMongodb.length / 10 +
                    40,
            child: ListView.builder(
              itemCount: widget.cartMongodb.length,
              itemBuilder: (context, index) {
                var item = widget.cartMongodb[index]['product'];
                var quantia = quantity[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.PRODUCTSCREEN,
                      arguments: item,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(widget.constraints.maxHeight * .02),
                    child: Container(
                      height: widget.constraints.maxHeight * .14,
                      width: widget.constraints.maxWidth * .9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: widget.constraints.maxHeight * .14,
                            width: widget.constraints.maxWidth * .25,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(
                                widget.constraints.maxHeight * .02,
                              ),
                              child: Container(
                                height: widget.constraints.maxHeight * .14,
                                width: widget.constraints.maxWidth * .15,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: item.productPhoto != ""
                                    ? Image.network(
                                        item.productPhoto,
                                        fit: BoxFit.cover,
                                      )
                                    : Center(),
                              ),
                            ),
                          ),
                          SizedBox(height: widget.constraints.maxWidth * .05),
                          Container(
                            height: widget.constraints.maxHeight * .14,
                            width: widget.constraints.maxWidth * .3,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: widget.constraints.maxHeight * .025,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: TextStyle(
                                      fontSize:
                                          widget.constraints.maxHeight * .02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: widget.constraints.maxHeight * .002,
                                  ),
                                  Text(
                                    item.productDetails,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          widget.constraints.maxHeight * .019,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.68),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: widget.constraints.maxHeight * .009,
                                  ),
                                  Text(
                                    "R\$${item.productPrice}",
                                    style: TextStyle(
                                      fontSize:
                                          widget.constraints.maxHeight * .02,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromRGBO(
                                          113, 227, 154, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: widget.constraints.maxHeight * .1,
                            width: widget.constraints.maxWidth * .35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity[index] > 0) {
                                      setState(() {
                                        quantity[index] = quantity[index] - 1;

                                        widget.callback(
                                          item.productPrice,
                                          false,
                                        );

                                        CartController controller =
                                            CartController();
                                        controller.incrementOrSubtractQuantity(
                                          item,
                                          "-",
                                        );
                                      });
                                      if (quantity[index] == 0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Deseja Remover o produto do carrinho?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text(
                                                    'Remover',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    // Lógica para remover o produto
                                                    CartController controller =
                                                        CartController();
                                                    controller
                                                        .removeProductFromCart(
                                                      item.productId,
                                                    );
                                                    widget.deleteProduct(item);
                                                    Navigator.of(context).pop();
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  onPressed: () {
                                                    CartController controller =
                                                        CartController();
                                                    controller
                                                        .incrementOrSubtractQuantity(
                                                      item,
                                                      "+",
                                                    );
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      quantity[index] =
                                                          quantity[index] + 1;

                                                      widget.callback(
                                                        item.productPrice,
                                                        true,
                                                      );
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                  ),
                                ),
                                Text(
                                  "${quantia * item.unitValue}${item.measurementUnit}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (item.stockQuantity >
                                          quantity[index]) {
                                        quantity[index] = quantity[index] + 1;

                                        widget.callback(
                                          item.productPrice,
                                          true,
                                        );
                                        CartController controller =
                                            CartController();
                                        controller.incrementOrSubtractQuantity(
                                          item,
                                          "+",
                                        );
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.add),
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
          ),
        ],
      ),
    );
  }
}
