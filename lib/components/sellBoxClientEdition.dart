import 'package:flutter/material.dart';

class SellBoxClientEdition extends StatefulWidget {
  BoxConstraints constraints;
  SellBoxClientEdition({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  State<SellBoxClientEdition> createState() => _SellBoxClientEditionState();
}

class _SellBoxClientEditionState extends State<SellBoxClientEdition> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.constraints.maxHeight * .6,
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
              children: const [
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
            padding: EdgeInsets.only(left: widget.constraints.maxWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Cooperativa: nome da Cooperativa"),
                Text("Endereço: endereço"),
              ],
            ),
          ),
          SizedBox(height: widget.constraints.maxHeight * .02),
          Padding(
            padding: EdgeInsets.only(left: widget.constraints.maxWidth * .05),
            child: const Text(
              "Produtos comprados:",
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.58),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
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
          Padding(
            padding: EdgeInsets.only(
              left: widget.constraints.maxWidth * .05,
              bottom: widget.constraints.maxHeight * .05,
            ),
            child: Row(
              children: const [
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
          )
        ],
      ),
    );
  }
}
