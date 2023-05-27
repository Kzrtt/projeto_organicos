import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxProducerEdition.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/sell.dart';

class FinishedSells extends StatefulWidget {
  const FinishedSells({Key? key}) : super(key: key);

  @override
  State<FinishedSells> createState() => _FinishedSellsState();
}

class _FinishedSellsState extends State<FinishedSells> {
  List<Sell> _sells = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CooperativeController controller = CooperativeController();
    controller.getAllFinishedSells().then((value) {
      setState(() {
        _sells = value;
      });
    });
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
              text: "Pedidos Finalizados ${_sells.length}",
            ),
            SizedBox(height: constraints.maxHeight * .05),
            SizedBox(
              height: constraints.maxHeight * .8,
              width: constraints.maxWidth,
              child: ListView.builder(
                itemCount: _sells.length,
                itemBuilder: (context, index) {
                  var item = _sells[index];
                  return Padding(
                    padding: EdgeInsets.all(constraints.maxHeight * .03),
                    child: InkWell(
                      onTap: () {
                        List<dynamic> list = [item, index];
                        Navigator.of(context).pushNamed(
                          ProducerAppRoutes.OPENSELLDETAILS,
                          arguments: list,
                        );
                      },
                      child: SellBoxProducerEdition(
                        constraints: constraints,
                        sell: item,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
