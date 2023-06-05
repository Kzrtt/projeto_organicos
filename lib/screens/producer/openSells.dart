import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxProducerEdition.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/sell.dart';

class OpenSells extends StatefulWidget {
  const OpenSells({Key? key}) : super(key: key);

  @override
  State<OpenSells> createState() => _OpenSellsState();
}

class _OpenSellsState extends State<OpenSells> {
  List<Sell> _sells = [];
  List<Products> _products = [];
  List<Map<String, dynamic>> produtosNecessarios = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CooperativeController controller = CooperativeController();
    ProductController productController = ProductController();
    productController.getAllProducts().then((value) {
      setState(() {
        _products = value;
      });
    });
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
            SizedBox(
              height: constraints.maxHeight * .9,
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
