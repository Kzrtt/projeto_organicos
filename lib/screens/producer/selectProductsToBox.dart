import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/productInBox.dart';
import 'package:projeto_organicos/model/products.dart';

import '../../model/category.dart';

class SelectProductsToBox extends StatefulWidget {
  const SelectProductsToBox({Key? key}) : super(key: key);

  @override
  State<SelectProductsToBox> createState() => _SelectProductsToBoxState();
}

class _SelectProductsToBoxState extends State<SelectProductsToBox> {
  List<Products> _produtos = [];
  List<Category> _categorias = [];
  List<double> _quantidades = [];
  List<Products> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductController productController = ProductController();
    _searchController.addListener(_filterItems);
    productController.getAllCategorys().then((value) {
      setState(() {
        _categorias = value;
      });
    });
    productController.getAllProducts().then((value) {
      setState(() {
        _produtos = value;
        _filteredProducts = value;
        _quantidades = List.generate(_produtos.length, (index) => 0);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _produtos
          .where((item) => item.productName.toLowerCase().contains(searchText))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(108, 168, 129, 0.7),
          ),
        ),
        actions: [
          Row(
            children: const [
              Icon(Icons.favorite, color: Color.fromRGBO(108, 168, 129, 0.7)),
              SizedBox(width: 10),
              Text(
                "Produtos para a Box",
                style: TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(constraints.maxHeight * .025),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Digite sua busca',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .02),
                SizedBox(
                  height: constraints.maxHeight * .5,
                  child: ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      var item = _filteredProducts[index];
                      return ListTile(
                        isThreeLine: true,
                        title: Text(item.productName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantidade: ${item.stockQuantity} ${item.measuremntUnit}',
                            ),
                            Text("Preço: \$${item.productPrice}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (_quantidades[index] > 0) {
                                  setState(() {
                                    _quantidades[index] =
                                        _quantidades[index] - item.unitValue;
                                  });
                                }
                              },
                            ),
                            Text(_quantidades[index].toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                if (_produtos[index].stockQuantity >
                                    _quantidades[index]) {
                                  setState(() {
                                    _quantidades[index] =
                                        _quantidades[index] + item.unitValue;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .03),
                InkWell(
                  onTap: () {
                    List<ProductInBox> produtosNaBox = [];
                    for (var i = 0; i < _produtos.length; i++) {
                      if (_quantidades[i] != 0) {
                        ProductInBox productInBox = ProductInBox(
                          product: _produtos[i],
                          quantity: _quantidades[i],
                          measurementUnity: _produtos[i].measuremntUnit,
                        );
                        produtosNaBox.add(productInBox);
                      }
                    }
                    Navigator.pop(context, produtosNaBox);
                  },
                  child: CommonButton(
                    constraints: constraints,
                    text: "Adicionar Produtos",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
