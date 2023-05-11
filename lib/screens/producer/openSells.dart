import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxProducerEdition.dart';

class OpenSells extends StatefulWidget {
  const OpenSells({Key? key}) : super(key: key);

  @override
  State<OpenSells> createState() => _OpenSellsState();
}

class _OpenSellsState extends State<OpenSells> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            NameAndIcon(
              constraints: constraints,
              icon: Icons.star,
              text: "Pedidos Abertos",
            ),
            SizedBox(height: constraints.maxHeight * .05),
            Column(
              children: [
                SellBoxProducerEdition(constraints: constraints),
              ],
            ),
          ],
        );
      },
    );
  }
}
