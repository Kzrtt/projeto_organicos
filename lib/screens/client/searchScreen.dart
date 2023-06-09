import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';

import '../../model/products.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Category> _categorias = [];
  List<Products> _produtos = [];
  List<Products> _filteredItems = [];
  List<bool> _choiceChips = [];
  List<Category> selectedCategories = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_filterItems);
    UserController controller = UserController();
    ProductController pcontroller = ProductController();
    controller.getAllProducts().then((value) {
      setState(() {
        _produtos = value;
        _filteredItems = value;
      });
    });
    controller.getAllCategories().then((value) {
      setState(() {
        _choiceChips = List.generate(value.length, (index) => false);
        _categorias = value;
        isLoading = false;
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
      _filteredItems = _produtos
          .where((item) => item.productName.toLowerCase().contains(searchText))
          .toList();
    });
  }

  void _filterByChoiceChip(List<Category> categories) {
    setState(() {
      _filteredItems = _produtos.where((item) {
        return categories
            .every((category) => item.category.contains(category.categoryName));
      }).toList();

      _choiceChips = List<bool>.filled(_categorias.length, false);
      categories.forEach((category) {
        int index = _categorias.indexOf(category);
        if (index != -1) {
          _choiceChips[index] = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
        ),
        child: Column(children: [
          NameAndIcon(
            constraints: constraints,
            icon: Icons.search,
            text: "Busca",
          ),
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
                      color: Colors.white, width: constraints.maxWidth * .03),
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
          SizedBox(height: constraints.maxHeight * .015),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * .045,
            ),
            child: SizedBox(
              height: constraints.maxHeight * .08,
              width: constraints.maxWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categorias.length,
                itemBuilder: (context, index) {
                  var item = _categorias[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .01,
                    ),
                    child: ChoiceChip(
                      label: Text(item.categoryName),
                      selected: _choiceChips[index],
                      selectedColor: const Color.fromRGBO(113, 227, 154, 1),
                      onSelected: (value) {
                        setState(() {
                          _choiceChips[index] = !_choiceChips[index];
                        });
                        List<Category> selectedCategories = _categorias
                            .where((category) =>
                                _choiceChips[_categorias.indexOf(category)])
                            .toList();
                        if (selectedCategories.isNotEmpty) {
                          _filterByChoiceChip(selectedCategories);
                        } else {
                          setState(() {
                            _filteredItems = _produtos;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: const Color.fromRGBO(113, 227, 154, 1)))
              : SizedBox(
                  height: constraints.maxHeight * .7,
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
                                      child: item.productPhoto.isNotEmpty
                                          ? Image.network(
                                              item.productPhoto,
                                              fit: BoxFit.cover,
                                            )
                                          : Center(),
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
                                          overflow: TextOverflow.ellipsis,
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
                                              "${item.unitValue}${item.measurementUnit}",
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
                ),
        ]),
      );
    });
  }
}
