import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';

class SellBoxProducerEdition extends StatefulWidget {
  BoxConstraints constraints;
  //List<SellItem> sellItens = [];
  SellBoxProducerEdition({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  State<SellBoxProducerEdition> createState() => _SellBoxProducerEditionState();
}

class _SellBoxProducerEditionState extends State<SellBoxProducerEdition> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: widget.constraints.maxHeight * .7,
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pedido N°1",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.58),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "R\$ 45,00",
                        style: TextStyle(
                          color: Color.fromRGBO(113, 227, 154, 1),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: widget.constraints.maxWidth * .05),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cooperativa: nome da Cooperativa"),
                      Text("Endereço: endereço"),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.constraints.maxHeight * .3,
                  width: widget.constraints.maxWidth,
                  child: ListView(
                    children: const <ListTile>[
                      ListTile(
                        title: Text("Produto 1"),
                        subtitle: Text("2 unidades"),
                        trailing: Text("R\$ 20.00"),
                      ),
                      ListTile(
                        title: Text("Produto 2"),
                        subtitle: Text("5 unidades"),
                        trailing: Text("R\$ 10.00"),
                      ),
                      ListTile(
                        title: Text("Produto 3"),
                        subtitle: Text("10 unidades"),
                        trailing: Text("R\$ 15.00"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: widget.constraints.maxHeight * .05),
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.constraints.maxWidth * .05,
                    bottom: widget.constraints.maxHeight * .05,
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "Status: ",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.58),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Pago!",
                        style: TextStyle(
                          color: Color.fromRGBO(132, 202, 157, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                CommonButton(constraints: widget.constraints, text: "Detalhes"),
              ],
            )),
      ],
    );
  }
}
