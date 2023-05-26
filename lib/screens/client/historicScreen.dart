import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxClientEdition.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/cooperativeAdress.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/sell.dart';

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
  List<Sell> _sells = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserController controller = UserController();
    controller.getAllHistoric().then((value) {
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
              icon: Icons.receipt,
              text: "Meus Pedidos",
            ),
            SizedBox(height: constraints.maxHeight * .03),
            //Caixa do histórico
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
                                AppRoutes.SELLDETAILS,
                                arguments: list,
                              );
                            },
                            child: SellBoxClientEdition(
                              constraints: constraints,
                              sell: item,
                              index: index,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(),
          ],
        );
      },
    );
  }
}
