import 'package:flutter/material.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:provider/provider.dart';

import '../model/box.dart';
import '../utils/cartProvider.dart';
import 'boxAlertDialog.dart';

class BoxesInCart extends StatefulWidget {
  final void Function(int, bool) callback;
  final void Function(String) deleteBox;
  final void Function() load;
  BoxConstraints constraints;
  List<Map<String, dynamic>> boxCartMongodb = [];
  List<Map<String, dynamic>> boxCartWithRightQuantities = [];
  BoxesInCart({
    super.key,
    required this.constraints,
    required this.boxCartMongodb,
    required this.boxCartWithRightQuantities,
    required this.callback,
    required this.deleteBox,
    required this.load,
  });

  @override
  State<BoxesInCart> createState() => _BoxesInCartState();
}

class _BoxesInCartState extends State<BoxesInCart> {
  @override
  Widget build(BuildContext context) {
    List<int> boxQuantity = Provider.of<CartProvider>(context).getBoxQuantity;

    return Container(
      height:
          widget.constraints.maxHeight * widget.boxCartMongodb.length / 10 + 80,
      width: widget.constraints.maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: widget.constraints.maxWidth * .05,
            ),
            child: const Text(
              "Boxes:",
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, .81),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: widget.constraints.maxHeight * .01,
          ),
          Container(
            height: widget.constraints.maxHeight *
                    widget.boxCartMongodb.length /
                    10 +
                40,
            width: widget.constraints.maxWidth,
            child: SingleChildScrollView(
              child: Column(
                children: widget.boxCartMongodb.map((item) {
                  int index = widget.boxCartMongodb.indexOf(item);
                  return InkWell(
                    onTap: () {
                      List<int> quantidades = [];
                      for (var element in widget
                          .boxCartWithRightQuantities[index]['boxProducts']) {
                        quantidades.add(element['quantity'] as int);
                      }
                      item['box'];
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BoxAlertDialog(
                            box: item['box'],
                            constraints: widget.constraints,
                            quantidades: quantidades,
                          );
                        },
                      ).then((value) {
                        if (value) {
                          widget.load();
                        }
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.all(widget.constraints.maxHeight * .02),
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
                                    widget.constraints.maxHeight * .02),
                                child: Container(
                                  height: widget.constraints.maxHeight * .14,
                                  width: widget.constraints.maxWidth * .15,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: item['box'].boxPhoto != ""
                                      ? Image.network(
                                          item['box'].boxPhoto,
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
                                      "${item['box'].boxName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            widget.constraints.maxHeight * .02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          widget.constraints.maxHeight * .002,
                                    ),
                                    Text(
                                      item['box'].boxDetails,
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
                                      height:
                                          widget.constraints.maxHeight * .009,
                                    ),
                                    Text(
                                      "R\$${item['box'].boxPrice}",
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
                                      if (boxQuantity[index] > 0) {
                                        print('executou');
                                        setState(() {
                                          boxQuantity[index] =
                                              boxQuantity[index] - 1;
                                        });

                                        CartController controller =
                                            CartController();
                                        controller
                                            .incrementOrSubtractBoxQuantity(
                                          item['box'],
                                          "-",
                                        );
                                        widget.callback(
                                          item['box'].boxPrice,
                                          false,
                                        );
                                      }
                                      if (boxQuantity[index] == 0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Deseja Remover a box do carrinho?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Remover',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  onPressed: () {
                                                    // Lógica para remover o produto
                                                    CartController controller =
                                                        CartController();
                                                    controller
                                                        .removeBoxFromCart(
                                                      item['boxInCartId'],
                                                    );
                                                    widget.deleteBox(
                                                      item['boxInCartId'],
                                                    );
                                                    Navigator.of(context).pop();
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Cancelar',
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      boxQuantity[index] =
                                                          boxQuantity[index] +
                                                              1;
                                                      widget.callback(
                                                        item['box'].boxPrice,
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
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    "${boxQuantity[index] * 1} Uni",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (boxQuantity[index] <
                                          item['box'].boxQuantity) {
                                        setState(() {
                                          boxQuantity[index] =
                                              boxQuantity[index] + 1;
                                        });
                                        CartController controller =
                                            CartController();
                                        controller
                                            .incrementOrSubtractBoxQuantity(
                                          item['box'],
                                          "+",
                                        );
                                        widget.callback(
                                          item['box'].boxPrice,
                                          true,
                                        );
                                      }
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
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
