import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:provider/provider.dart';

import '../controller/cartController.dart';
import '../model/box.dart';
import '../utils/quantityProvider.dart';

class BoxAlertDialog extends StatefulWidget {
  Box box;
  BoxConstraints constraints;
  List<int> quantidades;
  BoxAlertDialog({
    super.key,
    required this.box,
    required this.constraints,
    required this.quantidades,
  });

  @override
  State<BoxAlertDialog> createState() => _BoxAlertDialogState();
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  } else {
    String truncatedText = text.substring(0, maxLength);
    truncatedText += '...';
    return truncatedText;
  }
}

class _BoxAlertDialogState extends State<BoxAlertDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuantityProvider(
        initialQuantity: widget.quantidades,
        initialBoxQuantity: widget.box.boughtQuantity,
      ),
      child: Consumer<QuantityProvider>(
        builder: (context, quantityProvider, _) {
          return AlertDialog(
            title: Text(widget.box.boxName),
            content: SizedBox(
              height: widget.constraints.maxHeight * .54,
              width: widget.constraints.maxWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.constraints.maxHeight * .03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Produtos: ",
                      style: TextStyle(
                        fontSize: widget.constraints.maxHeight * .024,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: widget.constraints.maxHeight *
                              widget.box.produtos.length /
                              10 +
                          35,
                      width: widget.constraints.maxWidth,
                      child: ListView.builder(
                        itemCount: widget.box.produtos.length,
                        itemBuilder: (context, index) {
                          var item = widget.box.produtos[index];
                          return Column(
                            children: [
                              Container(
                                height: widget.constraints.maxHeight * .1,
                                width: widget.constraints.maxWidth,
                                child: Row(
                                  children: [
                                    Container(
                                      height: widget.constraints.maxHeight * .1,
                                      width: widget.constraints.maxWidth * .32,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(truncateText(
                                            item.product.productName,
                                            10,
                                          )),
                                          Text(
                                            "Máximo: ${item.product.unitValue * item.quantity}${item.product.measurementUnit}",
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
                                              quantityProvider
                                                  .decreaseQuantity(index);
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text(
                                            "${quantityProvider.quantity[index] * item.product.unitValue}${item.measurementUnity}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (quantityProvider.boxQuantity <
                                                  widget.box.boxQuantity) {
                                                quantityProvider
                                                    .increaseQuantity(
                                                  index,
                                                  item.quantity,
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
                              SizedBox(
                                height: widget.constraints.maxHeight * .02,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: widget.constraints.maxHeight * .05),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: const Color.fromRGBO(113, 227, 154, 1),
                            ),
                          )
                        : Center(),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: const Color.fromRGBO(113, 227, 154, 1),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  CartController controller = CartController();
                  List<Map<String, dynamic>> produtos = [];
                  List<int> newQuantities = [];
                  for (var i = 0; i < widget.box.produtos.length; i++) {
                    final provider = Provider.of<QuantityProvider>(
                      context,
                      listen: false,
                    );
                    produtos.add({
                      "productId": widget.box.produtos[i].product.productId,
                      "quantity": provider.quantity[i],
                    });
                    newQuantities.add(provider.quantity[i]);
                  }

                  if (quantityProvider.boxQuantity !=
                      widget.box.boughtQuantity) {
                    controller.increaseQuantity(
                      widget.box,
                      quantityProvider.boxQuantity,
                    );
                  }

                  await controller
                      .updateBoxValues(
                    widget.box,
                    produtos,
                    widget.box.boughtQuantity,
                    context,
                  )
                      .then(
                    (value) {
                      Navigator.of(context).pop(true);
                    },
                  ).whenComplete(() {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
              ),
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
