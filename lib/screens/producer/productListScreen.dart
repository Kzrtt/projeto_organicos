// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/producerController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/producers.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/nameAndIcon.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isExpanded = false;
  List<Products> _productList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductController controller = ProductController();
    controller.getAllProducts().then((value) {
      setState(() {
        _productList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.list,
                text: "Seus Produtos",
              ),
              SizedBox(
                height: constraints.maxHeight * .9,
                child: ListView.builder(
                  itemCount: _productList.length,
                  itemBuilder: (context, index) {
                    var item = _productList[index];
                    return Text(item.productName);
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
