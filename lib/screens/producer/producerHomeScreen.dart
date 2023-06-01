import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/bar_graph/bar_graph.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:provider/provider.dart';

import '../../components/nameAndIcon.dart';
import '../../model/cooperative.dart';

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

  List<double> monthSummary = [
    4.40,
    2.50,
    42.42,
    10.50,
    100.20,
    88.99,
    90.10,
  ];

  @override
  Widget build(BuildContext context) {
    final cooperativeState = Provider.of<CooperativeState>(context);
    Cooperative? cooperative = cooperativeState.getCooperative;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            NameAndIcon(
              constraints: constraints,
              icon: Icons.star,
              text: "Bem vindo ${cooperative!.cooperativeName}",
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
                      () => widget.callbackFunction(11),
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
                  height: constraints.maxHeight * .3,
                  width: constraints.maxWidth * .85,
                  child: MyBarGraph(
                    weeklySummary: monthSummary,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
