// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/productInfosDialog.dart';
import 'package:projeto_organicos/components/productListAppBar.dart';
import 'package:projeto_organicos/components/quantityDialog.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/controller/measurementUnitController.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/validators.dart';

import '../../model/box.dart';
import '../../model/category.dart';
import '../../model/measurementUnit.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  List<Products> _productList = [];
  List<Box> _boxList = [];
  List<Measurement> measurementList = [];
  List<Category> categoryList = [];
  Validators validators = Validators();
  TabController? _tabController;
  int quantidade = 1;
  bool isLoading = true;

  Future<void> clearStock() async {
    CooperativeController controller = CooperativeController();
    controller.clearStock().then((value) => load());
  }

  void load() {
    setState(() {
      isLoading = true;
    });
    ProductController controller = ProductController();
    MeasurementUnitController measurementUnitController =
        MeasurementUnitController();
    measurementUnitController.getAllmeasurementUnits().then((value) {
      setState(() {
        measurementList = value;
      });
    });
    controller.getAllCategorys().then((value) {
      setState(() {
        categoryList = value;
      });
    });
    controller.getAllProducts().then((value) {
      setState(() {
        _productList = value;
      });
    });
    controller.getAllBoxes().then((value) {
      setState(() {
        _boxList = value;
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    load();
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
                    onTap: () async {
                      var response = Navigator.of(context).pushNamed(
                        ProducerAppRoutes.UPDATEBOX,
                        arguments: item,
                      ) as Box;
                      if (response.boxName != "") {
                        for (var element in _boxList) {
                          if (element.id == response.id) {
                            setState(() {
                              _boxList[_boxList.indexOf(element)] = response;
                            });
                            break;
                          }
                        }
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Color.fromRGBO(108, 168, 129, 0.7),
                    ),
                  ),
                  title: Text(item.boxName),
                  trailing: InkWell(
                    onTap: () {
                      ProductController controller = ProductController();
                      controller.deleteBox(item.id, item.boxName);
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
                      if (response.productName != "") {
                        for (var element in _productList) {
                          if (element.productId == response.productId) {
                            setState(() {
                              _productList[_productList.indexOf(element)] =
                                  response;
                            });
                            break;
                          }
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
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SingleChildScrollView(
                            child: ProductsInfoDialog(
                              product: item,
                              constraints: constraints,
                              measurementList: measurementList,
                              categoryList: categoryList,
                            ),
                          );
                        },
                      ).then((value) => load());
                    },
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return QuantidadeDialog(
                            product: item,
                          );
                        },
                      ).then((value) => load());
                    },
                    child: const Icon(
                      Icons.add,
                      color: Color.fromRGBO(108, 168, 129, 0.7),
                    ),
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
          width: constraints.maxWidth,
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * .02),
              ProductListAppBar(
                constraints: constraints,
                icon: Icons.list,
                text: "Seus Produtos",
                callback: clearStock,
                secondIconColor: Colors.red,
                secondIcon: Icons.delete,
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
              isLoading
                  ? Column(
                      children: [
                        SizedBox(height: constraints.maxHeight * .3),
                        Center(
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(113, 227, 154, 1),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
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
