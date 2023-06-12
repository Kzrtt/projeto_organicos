import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:provider/provider.dart';

import '../utils/quantityProvider.dart';

class MyDialog extends StatefulWidget {
  BoxConstraints constraints;
  Box box;
  MyDialog({
    super.key,
    required this.constraints,
    required this.box,
  });

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.box.boxName,
      ),
      content: SizedBox(
        height: widget.constraints.maxHeight * .5,
        width: widget.constraints.maxWidth * 6,
        child: ListView.builder(
          itemCount: widget.box.produtos.length,
          itemBuilder: (context, index) {
            final quantityProvider = Provider.of<QuantityProvider>(
              context,
              listen: false,
            );
            var item2 = widget.box.produtos[index];
            return Column(
              children: [
                Container(
                  height: widget.constraints.maxHeight * .1,
                  width: widget.constraints.maxWidth * .9,
                  child: Row(
                    children: [
                      Container(
                        height: widget.constraints.maxHeight * .1,
                        width: widget.constraints.maxWidth * .44,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item2.product.productName),
                            Text(
                              "Quantidade: ${item2.product.unitValue}${item2.product.measurementUnit}",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: widget.constraints.maxHeight * .1,
                        width: widget.constraints.maxWidth * .34,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                quantityProvider.decreaseQuantity(index);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              "${quantityProvider.quantity[index]} uni",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                quantityProvider.increaseQuantity(
                                  index,
                                  item2.quantity,
                                );
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: widget.constraints.maxHeight * .02),
              ],
            );
          },
        ),
      ),
    );
  }
}
