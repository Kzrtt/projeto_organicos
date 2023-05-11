import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxClientEdition.dart';

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
                SellBoxClientEdition(constraints: constraints),
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
