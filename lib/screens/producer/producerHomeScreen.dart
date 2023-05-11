import 'package:flutter/material.dart';

import '../../components/nameAndIcon.dart';

class ProducerHomeScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  const ProducerHomeScreen({Key? key, required this.callbackFunction})
      : super(key: key);

  @override
  State<ProducerHomeScreen> createState() => _ProducerHomeScreenState();
}

class _ProducerHomeScreenState extends State<ProducerHomeScreen> {
  Widget simpleBox(BoxConstraints constraints, Color color, String text,
      Function() function) {
    return InkWell(
      onTap: function,
      child: Container(
        height: constraints.maxHeight * .22,
        width: constraints.maxWidth * .4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            NameAndIcon(
              constraints: constraints,
              icon: Icons.star,
              text: "Bem vindo Cooperativa",
            ),
            SizedBox(height: constraints.maxHeight * .03),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    simpleBox(
                      constraints,
                      const Color.fromRGBO(250, 215, 215, 1),
                      "Pedidos Abertos",
                      () => widget.callbackFunction(3),
                    ),
                    simpleBox(
                      constraints,
                      const Color.fromRGBO(245, 220, 190, 1),
                      "Faturamento",
                      () => null,
                    )
                  ],
                ),
                SizedBox(height: constraints.maxHeight * .04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    simpleBox(
                      constraints,
                      const Color.fromRGBO(255, 253, 211, 1),
                      "Pedidos Finalizados",
                      () => null,
                    ),
                    simpleBox(
                      constraints,
                      const Color.fromRGBO(213, 234, 253, 1),
                      "Atualizar Lista",
                      () => null,
                    )
                  ],
                ),
                SizedBox(height: constraints.maxHeight * .05),
                Container(
                  color: Colors.blueGrey,
                  height: constraints.maxHeight * .3,
                  width: constraints.maxWidth * .6,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
