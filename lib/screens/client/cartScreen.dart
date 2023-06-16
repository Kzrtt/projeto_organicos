import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:projeto_organicos/components/boxAlertDialog.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/myDialog.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/model/productInBox.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/cartProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/adress.dart';
import '../../utils/appRoutes.dart';
import '../../utils/quantityProvider.dart';

class CartScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  const CartScreen({
    Key? key,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  num subTotal = 0;
  double taxa = 1.00;
  bool isLoadingSell = false;
  final DateFormat _dateFormat = DateFormat('YYYY/MM/DD');
  String _selectedDate = "";
  String _selectedItem = "";
  String _selectedDelivery = "";
  List<Adress> addresses = [];
  List<String> addressesId = [];
  List<Map<String, dynamic>> cartMongodb = [];
  List<Map<String, dynamic>> boxCartMongodb = [];
  List<Map<String, dynamic>> boxCartWithRightQuantities = [];
  Adress defaultAddress = Adress(
    adressId: "",
    nickname: "",
    complement: "",
    street: "",
    city: "",
    state: "",
    zipCode: "",
    isDefault: false,
  );
  bool isLoading = true;

  Widget thinDivider(BoxConstraints constraints) {
    return Center(
      child: Container(
        height: 0.8,
        width: constraints.maxWidth * .7,
        color: Color.fromRGBO(83, 242, 166, 1),
      ),
    );
  }

  Future<void> loadAdresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserController userController = UserController();
    String? userId = prefs.getString("userId");
    List<Adress> temp = await userController.getAllAdresses(userId!);
    setState(() {
      addresses = temp;
      if (temp.any((element) => element.isDefault == true)) {
        defaultAddress =
            temp.singleWhere((element) => element.isDefault == true);
      }
      for (var element in temp) {
        addressesId.add(element.adressId);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CartController cartController = CartController();
    cartController.getAllBoxesFromCart().then((value) {
      setState(() {
        boxCartWithRightQuantities = value;
      });
    });
    cartController.getAllProductsInfo().then((value) {
      cartMongodb = value;
      final provider = Provider.of<CartProvider>(context, listen: false);
      List<int> temp = [];
      for (var element in value) {
        print(element['quantity']);
        temp.add(element['quantity']);
      }
      provider.setQuantity(temp);
      for (var i = 0; i < cartMongodb.length; i++) {
        setState(() {
          subTotal += cartMongodb[i]['product'].productPrice *
              cartMongodb[i]['quantity'];
        });
      }
    });
    cartController.getAllBoxesInfo().then((value) {
      setState(() {
        boxCartMongodb = value;
      });
      for (var i = 0; i < boxCartMongodb.length; i++) {
        setState(() {
          subTotal +=
              boxCartMongodb[i]['box'].boxPrice * boxCartMongodb[i]['quantity'];
        });
      }
    });
    loadAdresses().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Products> cart = Provider.of<CartProvider>(context).getCart;
    List<int> quantity = Provider.of<CartProvider>(context).getQuantity;
    List<String> items = addresses.map((e) => e.nickname).toList();
    List<String> dias = ['Terça', 'Sexta'];
    List<String> deliveryType = [
      'Receber na minha sala (1R\$)',
      'Buscar no bloco R (grátis)'
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: const Color.fromRGBO(113, 227, 154, 1),
              ))
            : SingleChildScrollView(
                child: Container(
                  height: constraints.maxHeight * 1.8,
                  width: constraints.maxWidth,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  child: Column(
                    children: [
                      NameAndIcon(
                        constraints: constraints,
                        icon: Icons.shopping_cart,
                        text: "Carrinho",
                      ),
                      SizedBox(height: constraints.maxHeight * .03),
                      cartMongodb.isNotEmpty || boxCartMongodb.isNotEmpty
                          ? SizedBox(
                              height: constraints.maxHeight * 1.5,
                              width: constraints.maxWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  cartMongodb.isNotEmpty
                                      ? Container(
                                          height: constraints.maxHeight *
                                                  cartMongodb.length /
                                                  10 +
                                              80,
                                          width: constraints.maxWidth,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: constraints.maxWidth *
                                                      .05,
                                                ),
                                                child: const Text(
                                                  "Produtos:",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, .81),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    constraints.maxHeight * .03,
                                              ),
                                              SizedBox(
                                                height: constraints.maxHeight *
                                                        cartMongodb.length /
                                                        10 +
                                                    40,
                                                child: ListView.builder(
                                                  itemCount: cartMongodb.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var item =
                                                        cartMongodb[index]
                                                            ['product'];
                                                    var quantia =
                                                        quantity[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                          AppRoutes
                                                              .PRODUCTSCREEN,
                                                          arguments: item,
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            constraints
                                                                    .maxHeight *
                                                                .02),
                                                        child: Container(
                                                          height: constraints
                                                                  .maxHeight *
                                                              .14,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .9,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    .14,
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .25,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                      constraints
                                                                              .maxHeight *
                                                                          .02),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        constraints.maxHeight *
                                                                            .14,
                                                                    width: constraints
                                                                            .maxWidth *
                                                                        .15,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    child: item.productPhoto !=
                                                                            ""
                                                                        ? Image
                                                                            .network(
                                                                            item.productPhoto,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : Center(),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: constraints
                                                                          .maxWidth *
                                                                      .05),
                                                              Container(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    .14,
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .3,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: constraints
                                                                            .maxHeight *
                                                                        .025,
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        item.productName,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              constraints.maxHeight * .02,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: constraints.maxHeight *
                                                                            .002,
                                                                      ),
                                                                      Text(
                                                                        item.productDetails,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              constraints.maxHeight * .019,
                                                                          color: const Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.68),
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: constraints.maxHeight *
                                                                            .009,
                                                                      ),
                                                                      Text(
                                                                        "R\$${item.productPrice}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              constraints.maxHeight * .02,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: const Color.fromRGBO(
                                                                              113,
                                                                              227,
                                                                              154,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    .1,
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .35,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (quantity[index] >
                                                                            0) {
                                                                          setState(
                                                                              () {
                                                                            quantity[index] =
                                                                                quantity[index] - 1;
                                                                            subTotal =
                                                                                item.productPrice * quantity[index];
                                                                            CartController
                                                                                controller =
                                                                                CartController();
                                                                            controller.incrementOrSubtractQuantity(
                                                                              item,
                                                                              "-",
                                                                            );
                                                                          });
                                                                          if (quantity[index] ==
                                                                              0) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Text('Deseja Remover o produto do carrinho?'),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                      child: const Text(
                                                                                        'Remover',
                                                                                        style: TextStyle(color: Colors.red),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        // Lógica para remover o produto
                                                                                        CartController controller = CartController();
                                                                                        controller.removeProductFromCart(
                                                                                          item.productId,
                                                                                        );
                                                                                        setState(() {
                                                                                          cartMongodb.removeWhere((element) {
                                                                                            quantity.removeWhere((element) => element == 0);
                                                                                            return element['product'].productId == item.productId;
                                                                                          });
                                                                                        });
                                                                                        Navigator.of(context).pop();
                                                                                        Provider.of<CartProvider>(context, listen: false);
                                                                                      },
                                                                                    ),
                                                                                    TextButton(
                                                                                      child: const Text(
                                                                                        'Cancelar',
                                                                                        style: TextStyle(color: Colors.grey),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        CartController controller = CartController();
                                                                                        controller.incrementOrSubtractQuantity(
                                                                                          item,
                                                                                          "+",
                                                                                        );
                                                                                        Navigator.of(context).pop();
                                                                                        setState(() {
                                                                                          quantity[index] = quantity[index] + 1;
                                                                                          subTotal = subTotal + item.productPrice;
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${quantia * item.unitValue}${item.measurementUnit}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (item.stockQuantity >
                                                                              quantity[index]) {
                                                                            quantity[index] =
                                                                                quantity[index] + 1;
                                                                            print(quantity[index]);
                                                                            print(quantity[index] *
                                                                                item.productPrice);
                                                                            subTotal =
                                                                                item.productPrice * quantity[index];
                                                                            CartController
                                                                                controller =
                                                                                CartController();
                                                                            controller.incrementOrSubtractQuantity(
                                                                              item,
                                                                              "+",
                                                                            );
                                                                          }
                                                                        });
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .add),
                                                                    ),
                                                                  ],
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
                                            ],
                                          ),
                                        )
                                      : Center(),
                                  boxCartMongodb.isNotEmpty
                                      ? Container(
                                          height: constraints.maxHeight *
                                                  boxCartMongodb.length /
                                                  10 +
                                              80,
                                          width: constraints.maxWidth,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: constraints.maxWidth *
                                                      .05,
                                                ),
                                                child: const Text(
                                                  "Boxes:",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, .81),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    constraints.maxHeight * .03,
                                              ),
                                              SizedBox(
                                                height: constraints.maxHeight *
                                                        boxCartMongodb.length /
                                                        10 +
                                                    40,
                                                width: constraints.maxWidth,
                                                child: ListView.builder(
                                                  itemCount:
                                                      boxCartMongodb.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var item =
                                                        boxCartMongodb[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        List<int> quantidades =
                                                            [];
                                                        for (var element
                                                            in boxCartWithRightQuantities[
                                                                    index][
                                                                'boxProducts']) {
                                                          quantidades.add(
                                                              element['quantity']
                                                                  as int);
                                                        }
                                                        item['box'];
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return BoxAlertDialog(
                                                              box: item['box'],
                                                              constraints:
                                                                  constraints,
                                                              quantidades:
                                                                  quantidades,
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            constraints
                                                                    .maxHeight *
                                                                .02),
                                                        child: Container(
                                                          height: constraints
                                                                  .maxHeight *
                                                              .14,
                                                          width: constraints
                                                                  .maxWidth *
                                                              .9,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    .14,
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .25,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                      constraints
                                                                              .maxHeight *
                                                                          .02),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        constraints.maxHeight *
                                                                            .14,
                                                                    width: constraints
                                                                            .maxWidth *
                                                                        .15,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    child: item['box'].boxPhoto !=
                                                                            ""
                                                                        ? Image
                                                                            .network(
                                                                            item['box'].boxPhoto,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : Center(),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: constraints
                                                                          .maxWidth *
                                                                      .05),
                                                              Container(
                                                                height: constraints
                                                                        .maxHeight *
                                                                    .14,
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .3,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: constraints
                                                                            .maxHeight *
                                                                        .025,
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        item['box']
                                                                            .boxName,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              constraints.maxHeight * .02,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: constraints.maxHeight *
                                                                            .002,
                                                                      ),
                                                                      Text(
                                                                        item['box']
                                                                            .boxDetails,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              constraints.maxHeight * .019,
                                                                          color: const Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.68),
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: constraints.maxHeight *
                                                                            .009,
                                                                      ),
                                                                      Text(
                                                                        "R\$${item['box'].boxPrice}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              constraints.maxHeight * .02,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: const Color.fromRGBO(
                                                                              113,
                                                                              227,
                                                                              154,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: constraints
                                                                        .maxWidth *
                                                                    .21,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  CartController
                                                                      controller =
                                                                      CartController();
                                                                  controller
                                                                      .removeBoxFromCart(
                                                                    item['box']
                                                                        .id,
                                                                  );
                                                                  setState(() {
                                                                    boxCartMongodb
                                                                        .removeWhere(
                                                                      (element) =>
                                                                          element['box']
                                                                              .id ==
                                                                          item['box']
                                                                              .id,
                                                                    );
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
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
                                            ],
                                          ),
                                        )
                                      : Center(),
                                  SizedBox(height: constraints.maxHeight * .03),
                                  thinDivider(constraints),
                                  SizedBox(height: constraints.maxHeight * .05),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Endereço para entrega:",
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, .81),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .02),
                                        SizedBox(
                                          width: constraints.maxWidth * .9,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedItem.isNotEmpty
                                                ? _selectedItem
                                                : null,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width:
                                                        constraints.maxWidth *
                                                            .03),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                            hint: const Text(
                                                "Escolher endereço para entrega"),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedItem =
                                                    value.toString();
                                              });
                                            },
                                            items: items
                                                .map(
                                                  (item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .04),
                                        const Text(
                                          "Data e Horário da entrega:",
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, .81),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .02),
                                        SizedBox(
                                          width: constraints.maxWidth * .9,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedDate.isNotEmpty
                                                ? _selectedDate
                                                : null,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width:
                                                        constraints.maxWidth *
                                                            .03),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                            hint: const Text(
                                              "Escolha o dia para entrega",
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedDate =
                                                    value.toString();
                                              });
                                            },
                                            items: dias
                                                .map(
                                                  (item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .04),
                                        const Text(
                                          "Método de Entrega:",
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, .81),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .02),
                                        SizedBox(
                                          width: constraints.maxWidth * .9,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedDelivery.isNotEmpty
                                                ? _selectedDelivery
                                                : null,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width:
                                                        constraints.maxWidth *
                                                            .03),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                            hint: const Text(
                                              "Escolha o modo de entrega",
                                            ),
                                            onChanged: (value) {
                                              if (value ==
                                                  'Buscar no bloco R (grátis)') {
                                                setState(() {
                                                  taxa = 0;
                                                });
                                              } else {
                                                setState(() {
                                                  taxa = 1;
                                                });
                                              }
                                              setState(() {
                                                _selectedDelivery =
                                                    value.toString();
                                              });
                                            },
                                            items: deliveryType
                                                .map(
                                                  (item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .04),
                                  thinDivider(constraints),
                                  SizedBox(height: constraints.maxHeight * .03),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: constraints.maxWidth * .07,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Resumo dos Valores: ",
                                          style: TextStyle(
                                            fontSize:
                                                constraints.maxHeight * .02,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "SubTotal: ",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .81),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "R\$${subTotal.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .81),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Taxa de Entrega: ",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .51),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "R\$${taxa.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .51),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .01),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Total: ",
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .81),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "R\$${(subTotal + taxa).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .81),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .05),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isLoadingSell = true;
                                      });
                                      final provider =
                                          Provider.of<CartProvider>(
                                        context,
                                        listen: false,
                                      );
                                      provider.setCart(cart);
                                      provider.setQuantity(quantity);
                                      int index = items.indexOf(_selectedItem);
                                      CartController controller =
                                          CartController();
                                      DateTime nextDay = DateTime.now();
                                      print(_selectedItem);
                                      if (_selectedDate == "Terça") {
                                        DateTime now = DateTime.now();
                                        int daysUntilNextDay =
                                            (DateTime.tuesday -
                                                    now.weekday +
                                                    7) %
                                                7;
                                        nextDay = now.add(
                                            Duration(days: daysUntilNextDay));
                                      } else if (_selectedDate == "Sexta") {
                                        DateTime now = DateTime.now();
                                        int daysUntilNextDay =
                                            (DateTime.friday -
                                                    now.weekday +
                                                    7) %
                                                7;
                                        nextDay = now.add(
                                            Duration(days: daysUntilNextDay));
                                      }

                                      String date = nextDay
                                          .toIso8601String()
                                          .split('T')[0];

                                      if (nextDay != DateTime.now()) {
                                        controller
                                            .createSell(
                                          addressesId[index],
                                          date,
                                          _selectedDelivery,
                                          context,
                                        )
                                            .then((value) {
                                          if (value) {
                                            setState(() {
                                              isLoadingSell = false;
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Pedido cadastrado com sucesso!",
                                                  ),
                                                );
                                              },
                                            );
                                            setState(() {
                                              boxCartMongodb = [];
                                              cartMongodb = [];
                                            });
                                            widget.callbackFunction(3);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Erro ao realizar o pedido",
                                                  ),
                                                );
                                              },
                                            );
                                            setState(() {
                                              boxCartMongodb = [];
                                              cartMongodb = [];
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: isLoadingSell
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: const Color.fromRGBO(
                                                  113, 227, 154, 1),
                                            ),
                                          )
                                        : CommonButton(
                                            constraints: constraints,
                                            text: "Finalizar Pedido",
                                          ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/undraw_shopping_app.svg',
                                    height: constraints.maxHeight * .3,
                                    width: constraints.maxWidth * .3,
                                  ),
                                  SizedBox(height: constraints.maxHeight * .07),
                                  Text(
                                    "Seu Carrinho está vazio :(",
                                    style: TextStyle(
                                      fontSize: constraints.maxHeight * .025,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * .015),
                                  SizedBox(
                                    width: constraints.maxWidth * .65,
                                    child: Text(
                                      "Adicione produtos ao seu carrinho e retorne para está página",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: constraints.maxHeight * .02,
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
