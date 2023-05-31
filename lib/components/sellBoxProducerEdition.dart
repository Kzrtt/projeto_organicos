import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

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

    return Column(
      children: [
        Container(
          height:
              widget.constraints.maxHeight * widget.sell.products.length / 10 +
                  150,
          width: widget.constraints.maxWidth * .9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: widget.constraints.maxHeight * .02),
              Padding(
                padding:
                    EdgeInsets.only(left: widget.constraints.maxWidth * .05),
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
                    Products item = widget.sell.products[index]['produto'];
                    var quantity = widget.sell.products[index]['quantidade'];
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text(
                          "${quantity * item.unitValue}${item.measuremntUnit}"),
                      trailing: Text("R\$ ${item.productPrice * quantity}"),
                    );
                  },
                ),
              ),
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
