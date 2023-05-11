import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxClientEdition.dart';

class HistoricScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  const HistoricScreen({
    Key? key,
    required this.callbackFunction,
  }) : super(key: key);

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
            InkWell(
              onTap: () => widget.callbackFunction(6),
              child: SellBoxClientEdition(constraints: constraints),
            ),
          ],
        );
      },
    );
  }
}
