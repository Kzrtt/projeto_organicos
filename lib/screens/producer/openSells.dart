import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxProducerEdition.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/sell.dart';

class OpenSells extends StatefulWidget {
  const OpenSells({Key? key}) : super(key: key);

  @override
  State<OpenSells> createState() => _OpenSellsState();
}

class _OpenSellsState extends State<OpenSells> {
  List<Sell> _sells = [];
  List<Map<String, dynamic>> produtosNecessarios = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CooperativeController controller = CooperativeController();
    controller.getAllSells().then((value) {
      setState(() {
        _sells = value;
      });
    });
    controller.getAllProductsFromSells().then((value) {
      setState(() {
        produtosNecessarios = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.star,
                text: "Pedidos Abertos",
              ),
              SizedBox(height: constraints.maxHeight * .05),
              SizedBox(
                height: constraints.maxHeight * .85,
                width: constraints.maxWidth * .9,
                child: ListView.builder(
                  itemCount: produtosNecessarios.length,
                  itemBuilder: (context, index) {
                    var item = produtosNecessarios[index]['produtosNaData'];
                    var data = produtosNecessarios[index]['data'];
                    return Column(
                      children: [
                        Container(
                          height: constraints.maxHeight * .3,
                          width: constraints.maxWidth * .9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(data),
                              SizedBox(height: constraints.maxHeight * .03),
                              SizedBox(
                                height: constraints.maxHeight * .2,
                                width: constraints.maxWidth,
                                child: ListView.builder(
                                  itemCount: item.length,
                                  itemBuilder: (context, index) {
                                    var product = item[index]['produto'];
                                    var itemQuantity =
                                        item[index]['quantidade'];
                                    return ListTile(
                                      title: Text(product.productName),
                                      subtitle: Text(
                                          "${itemQuantity * product.unitValue}${product.measuremntUnit}"),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * .03),
                            ],
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .06),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
