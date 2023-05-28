import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxProducerEdition.dart';
import 'package:projeto_organicos/model/sell.dart';

import '../../controller/cooperativeController.dart';
import '../../utils/appRoutes.dart';

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
    controller.getAllSells().then((value) {
      for (var i = 0; i < value.length; i++) {
        if (value[i].status == "Entregue") {
          setState(() {
            _sells.add(value[i]);
          });
        }
      }
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
              text: "Pedidos Finalizados",
            ),
            SizedBox(height: constraints.maxHeight * .05),
            _sells.isNotEmpty
                ? SizedBox(
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
                  )
                : Center()
          ],
        );
      },
    );
  }
}
