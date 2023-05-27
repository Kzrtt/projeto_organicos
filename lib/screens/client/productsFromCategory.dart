import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/category.dart';

import '../../model/products.dart';
import '../../utils/appRoutes.dart';

class ProductsFromCategory extends StatefulWidget {
  const ProductsFromCategory({Key? key}) : super(key: key);

  @override
  State<ProductsFromCategory> createState() => _ProductsFromCategoryState();
}

class _ProductsFromCategoryState extends State<ProductsFromCategory> {
  List<Products> _produtos = [];
  List<Products> _filteredItems = [];
  List<Products> _listaFiltradaPorCategoria = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_filterItems);
    UserController controller = UserController();
    controller.getAllProducts().then((value) {
      setState(() {
        _produtos = value;
        _filteredItems = _listaFiltradaPorCategoria;
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
      _filteredItems = _listaFiltradaPorCategoria.where((item) {
        return item.productName.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Category category = ModalRoute.of(context)?.settings.arguments as Category;

    _listaFiltradaPorCategoria = _produtos.where((element) {
      return element.category.contains(category.categoryName);
    }).toList();

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
            children: [
              const Icon(
                Icons.shopping_bag,
                color: Color.fromRGBO(108, 168, 129, 0.7),
              ),
              const SizedBox(width: 10),
              Text(
                category.categoryName,
                style: const TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * .02),
                SizedBox(
                  height: constraints.maxHeight * .08,
                  width: constraints.maxWidth * .95,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: constraints.maxWidth * .03),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Color.fromRGBO(108, 168, 129, 0.7),
                      ),
                      hintText: "Busca",
                      hintStyle: TextStyle(
                        fontSize: constraints.maxHeight * .02,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .03),
                SizedBox(
                  height: constraints.maxHeight * .8,
                  width: constraints.maxWidth,
                  child: ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      var item = _filteredItems[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.PRODUCTSCREEN,
                            arguments: item,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(constraints.maxHeight * .02),
                          child: Container(
                            height: constraints.maxHeight * .2,
                            width: constraints.maxWidth * .9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: constraints.maxHeight * .2,
                                  width: constraints.maxWidth * .4,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        constraints.maxHeight * .02),
                                    child: Container(
                                      height: constraints.maxHeight * .2,
                                      width: constraints.maxWidth * .3,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: constraints.maxWidth * .05),
                                Container(
                                  height: constraints.maxHeight * .2,
                                  width: constraints.maxWidth * .5,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: constraints.maxHeight * .025,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: TextStyle(
                                            fontSize:
                                                constraints.maxHeight * .02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.productDetails,
                                          style: TextStyle(
                                            fontSize:
                                                constraints.maxHeight * .019,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.68),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: constraints.maxHeight * .06,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${item.unitValue}${item.measuremntUnit}",
                                              style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight * .02,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    constraints.maxWidth * .14),
                                            Text(
                                              "R\$${item.productPrice}",
                                              style: TextStyle(
                                                fontSize:
                                                    constraints.maxHeight * .02,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromRGBO(
                                                    113, 227, 154, 1),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
