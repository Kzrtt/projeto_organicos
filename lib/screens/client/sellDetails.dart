import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class SellDetails extends StatefulWidget {
  const SellDetails({Key? key}) : super(key: key);

  @override
  State<SellDetails> createState() => _SellDetailsState();
}

class _SellDetailsState extends State<SellDetails> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.2,
            child: Column(
              children: [
                NameAndIcon(
                  constraints: constraints,
                  icon: Icons.receipt,
                  text: "Pedido N°1",
                ),
                SizedBox(height: constraints.maxHeight * .03),
                const Text(
                  "Data do pedido: 04/05/2023",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, .68),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .04),
                //Caixa do pedido
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
                        padding:
                            EdgeInsets.only(left: constraints.maxWidth * .05),
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
                        padding:
                            EdgeInsets.only(left: constraints.maxWidth * .05),
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
                ),
                SizedBox(height: constraints.maxHeight * .01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Entrega: ",
                      style: TextStyle(
                        color: const Color.fromRGBO(0, 0, 0, .58),
                        fontWeight: FontWeight.w600,
                        fontSize: constraints.maxHeight * .025,
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth * .03),
                    Padding(
                      padding:
                          EdgeInsets.only(top: constraints.maxHeight * .02),
                      child: const Text(
                        "aguardando liberação do pedido \n(55) 11 94578-8944",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, .4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: constraints.maxHeight * .04),
                Center(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: constraints.maxHeight * .06,
                      width: constraints.maxWidth * .6,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(251, 126, 126, 1),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: Text(
                          "Cancelar Pedido",
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxHeight * .024,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
