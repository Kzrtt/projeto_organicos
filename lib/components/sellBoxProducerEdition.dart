import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../model/box.dart';
import '../model/products.dart';
import '../model/sell.dart';

class SellBoxProducerEdition extends StatefulWidget {
  BoxConstraints constraints;
  Sell sell;
  int index;
  SellBoxProducerEdition({
    required this.constraints,
    required this.index,
    required this.sell,
    Key? key,
  }) : super(key: key);

  @override
  State<SellBoxProducerEdition> createState() => _SellBoxProducerEditionState();
}

class _SellBoxProducerEditionState extends State<SellBoxProducerEdition> {
  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var i = 0; i < widget.sell.products.length; i++) {
      total += widget.sell.products[i]['produto'].productPrice *
          widget.sell.products[i]['quantidade'] as int;
    }

    for (var i = 0; i < widget.sell.boxes.length; i++) {
      total += widget.sell.boxes[i]['box'].boxPrice *
          widget.sell.boxes[i]['quantity'] as int;
    }

    return Column(
      children: [
        Container(
          height: widget.constraints.maxHeight *
                  (widget.sell.products.length +
                      (widget.sell.boxes.length * 3.5)) /
                  10 +
              180,
          width: widget.constraints.maxWidth * .9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.constraints.maxWidth * .05,
                    vertical: widget.constraints.maxHeight * .02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pedido N°${widget.index + 1}",
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.58),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "R\$ $total",
                        style: const TextStyle(
                          color: Color.fromRGBO(113, 227, 154, 1),
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: widget.constraints.maxHeight * .02),
              widget.sell.products.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: widget.constraints.maxWidth * .05),
                          child: const Text(
                            "Produtos comprados:",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.58),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: widget.constraints.maxHeight *
                                  widget.sell.products.length /
                                  10 +
                              20,
                          width: widget.constraints.maxWidth,
                          child: ListView.builder(
                            itemCount: widget.sell.products.length,
                            itemBuilder: (context, index) {
                              Products item =
                                  widget.sell.products[index]['produto'];
                              var quantity =
                                  widget.sell.products[index]['quantidade'];
                              return ListTile(
                                title: Text(item.productName),
                                subtitle: Text(
                                    "${quantity * item.unitValue}${item.measurementUnit}"),
                                trailing:
                                    Text("R\$ ${item.productPrice * quantity}"),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(),
              widget.sell.boxes.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: widget.constraints.maxWidth * .05),
                          child: const Text(
                            "Boxes compradas:",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.58),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: widget.constraints.maxHeight * .025),
                        SizedBox(
                          height: widget.constraints.maxHeight *
                                  widget.sell.boxes.length /
                                  10 +
                              150,
                          width: widget.constraints.maxWidth,
                          child: ListView.builder(
                            itemCount: widget.sell.boxes.length,
                            itemBuilder: (context, index) {
                              Box item = widget.sell.boxes[index]['box'];
                              var quantity =
                                  widget.sell.boxes[index]['quantity'];
                              return ListTile(
                                title: Text(item.boxName),
                                subtitle: SizedBox(
                                  height: widget.constraints.maxHeight * .4,
                                  width: widget.constraints.maxWidth,
                                  child: ListView.builder(
                                    itemCount: item.produtos.length,
                                    itemBuilder: (context, index) {
                                      var product =
                                          item.produtos[index].product;
                                      var q = item.produtos[index].quantity;
                                      return ListTile(
                                        title: Text(product.productName),
                                        subtitle: Text(
                                            "${q * product.unitValue}${product.measurementUnit}"),
                                      );
                                    },
                                  ),
                                ),
                                trailing:
                                    Text("R\$ ${item.boxPrice * quantity}"),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(),
              SizedBox(height: widget.constraints.maxHeight * .032),
              Padding(
                padding: EdgeInsets.only(
                  left: widget.constraints.maxWidth * .05,
                  bottom: widget.constraints.maxHeight * .05,
                ),
                child: Row(
                  children: [
                    const Text(
                      "Status: ",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.58),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.sell.status,
                      style: const TextStyle(
                        color: Color.fromRGBO(132, 202, 157, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
