// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/producerController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/producers.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/nameAndIcon.dart';
import '../../model/box.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  List<Products> _productList = [];
  List<Box> _boxList = [];
  Validators validators = Validators();
  final _updateFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  final TextEditingController _unitValueController = TextEditingController();
  final TextEditingController _measurementUnityController =
      TextEditingController();
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ProductController controller = ProductController();
    controller.getAllProducts().then((value) {
      setState(() {
        _productList = value;
      });
    });
    controller.getAllBoxes().then((value) {
      setState(() {
        _boxList = value;
      });
    });
  }

  Widget boxList(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: _boxList.length,
      itemBuilder: (context, index) {
        var item = _boxList[index];
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(constraints.maxHeight * .01),
              child: Card(
                child: ListTile(
                  leading: InkWell(
                    onTap: () async {},
                    child: const Icon(
                      Icons.edit,
                      color: Color.fromRGBO(108, 168, 129, 0.7),
                    ),
                  ),
                  title: Text(item.boxName),
                  trailing: InkWell(
                    onTap: () {
                      ProductController controller = ProductController();
                      controller.deleteProduct(item.id, item.boxName);
                      setState(() {
                        _boxList
                            .removeWhere((element) => element.id == item.id);
                      });
                    },
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Quantidade em Estoque:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 0.58),
                          ),
                        ),
                        TextSpan(
                          text: ' ${item.boxQuantity}',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.58),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget productList(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: _productList.length,
      itemBuilder: (context, index) {
        var item = _productList[index];
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(constraints.maxHeight * .01),
              child: Card(
                child: ListTile(
                  leading: InkWell(
                    onTap: () async {
                      var response = await Navigator.of(context).pushNamed(
                        ProducerAppRoutes.UPDATEPRODUCT,
                        arguments: item,
                      ) as Products;
                      for (var element in _productList) {
                        if (element.productId == response.productId) {
                          setState(() {
                            _productList[_productList.indexOf(element)] =
                                response;
                          });
                          break;
                        }
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Color.fromRGBO(108, 168, 129, 0.7),
                    ),
                  ),
                  title: Text(item.productName),
                  trailing: InkWell(
                    onTap: () {
                      ProductController controller = ProductController();
                      controller.deleteProduct(
                          item.productId, item.productName);
                      setState(() {
                        _productList.removeWhere(
                            (element) => element.productId == item.productId);
                      });
                    },
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Quantidade em Estoque:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 0.58),
                          ),
                        ),
                        TextSpan(
                          text: ' ${item.stockQuantity}',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.58),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
              SizedBox(height: constraints.maxHeight * .02),
              SizedBox(
                height: constraints.maxHeight * .1,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Produtos"),
                    Tab(text: "Boxes"),
                  ],
                ),
              ),
              SizedBox(height: constraints.maxHeight * .02),
              SizedBox(
                height: constraints.maxHeight * .7,
                width: constraints.maxWidth,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    productList(constraints),
                    boxList(constraints),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
