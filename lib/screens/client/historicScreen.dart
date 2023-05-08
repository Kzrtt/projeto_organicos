import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class HistoricScreen extends StatefulWidget {
  const HistoricScreen({Key? key}) : super(key: key);

  @override
  State<HistoricScreen> createState() => _HistoricScreenState();
}

class _HistoricScreenState extends State<HistoricScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            NameAndIcon(
              constraints: constraints,
              icon: Icons.receipt,
              text: "Meus Pedidos",
            ),
            SizedBox(height: constraints.maxHeight * .03),
            //Caixa do histórico
            Container(
              height: constraints.maxHeight * .6,
              width: constraints.maxWidth * .9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .05,
                      vertical: constraints.maxHeight * .02,
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
                    padding: EdgeInsets.only(left: constraints.maxWidth * .05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Cooperativa: nome da Cooperativa"),
                        Text("Endereço: endereço"),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .02),
                  Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth * .05),
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
                      left: constraints.maxWidth * .05,
                      bottom: constraints.maxHeight * .05,
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
            )
          ],
        );
      },
    );
  }
}
