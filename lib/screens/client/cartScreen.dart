import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/model/products.dart';
import 'package:projeto_organicos/utils/cartProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/adress.dart';
import '../../utils/appRoutes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Adress> addresses = [];
  List<String> addressesId = [];
  List<Map<String, dynamic>> cartMongodb = [];
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

  Widget thinDivider(BoxConstraints constraints) {
    return Center(
      child: Container(
        height: 0.8,
        width: constraints.maxWidth * .7,
        color: Color.fromRGBO(83, 242, 166, 1),
      ),
    );
  }

  void loadAdresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserController userController = UserController();
    String? userId = prefs.getString("userId");
    List<Adress> temp = await userController.getAllAdresses(userId!);
    setState(() {
      addresses = temp;
      defaultAddress = temp.singleWhere((element) => element.isDefault == true);
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
    cartController.getAllProductsInfo().then((value) {
      cartMongodb = value;
      final provider = Provider.of<CartProvider>(context, listen: false);
      List<int> temp = [];
      for (var element in value) {
        temp.add(element['quantity']);
      }
      provider.setQuantity(temp);
    });
    loadAdresses();
  }

  @override
  Widget build(BuildContext context) {
    String _selectedItem = defaultAddress.nickname;
    String _selectedDate = "";
    List<Products> cart = Provider.of<CartProvider>(context).getCart;
    List<int> quantity = Provider.of<CartProvider>(context).getQuantity;
    List<String> items = addresses.map((e) => e.nickname).toList();
    num subTotal = 0;
    for (var i = 0; i < cartMongodb.length; i++) {
      subTotal += cartMongodb[i]['product'].productPrice * quantity[i];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            height: constraints.maxHeight * 1.2,
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
                cartMongodb.isNotEmpty
                    ? SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: constraints.maxHeight *
                                      cartMongodb.length /
                                      10 +
                                  50,
                              width: constraints.maxWidth,
                              child: ListView.builder(
                                itemCount: cartMongodb.length,
                                itemBuilder: (context, index) {
                                  var item = cartMongodb[index]['product'];
                                  var quantia = quantity[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        AppRoutes.PRODUCTSCREEN,
                                        arguments: item,
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          constraints.maxHeight * .02),
                                      child: Container(
                                        height: constraints.maxHeight * .14,
                                        width: constraints.maxWidth * .9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height:
                                                  constraints.maxHeight * .14,
                                              width: constraints.maxWidth * .25,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  bottomLeft:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    constraints.maxHeight *
                                                        .02),
                                                child: Container(
                                                  height:
                                                      constraints.maxHeight *
                                                          .14,
                                                  width: constraints.maxWidth *
                                                      .15,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.grey,
                                                  ),
                                                  child: item.productPhoto != ""
                                                      ? Image.network(
                                                          item.productPhoto,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Center(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    constraints.maxWidth * .05),
                                            Container(
                                              height:
                                                  constraints.maxHeight * .14,
                                              width: constraints.maxWidth * .3,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(20.0),
                                                  bottomRight:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: constraints.maxHeight *
                                                      .025,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.productName,
                                                      style: TextStyle(
                                                        fontSize: constraints
                                                                .maxHeight *
                                                            .02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: constraints
                                                              .maxHeight *
                                                          .002,
                                                    ),
                                                    Text(
                                                      item.productDetails,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: constraints
                                                                .maxHeight *
                                                            .019,
                                                        color: const Color
                                                                .fromRGBO(
                                                            0, 0, 0, 0.68),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: constraints
                                                              .maxHeight *
                                                          .009,
                                                    ),
                                                    Text(
                                                      "R\$${item.productPrice}",
                                                      style: TextStyle(
                                                        fontSize: constraints
                                                                .maxHeight *
                                                            .02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color
                                                                .fromRGBO(
                                                            113, 227, 154, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height:
                                                  constraints.maxHeight * .1,
                                              width: constraints.maxWidth * .35,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if (quantity[index] > 0) {
                                                        setState(() {
                                                          quantity[index] =
                                                              quantity[index] -
                                                                  1;
                                                          subTotal = subTotal -
                                                              item.productPrice;
                                                          CartController
                                                              controller =
                                                              CartController();
                                                          controller
                                                              .incrementOrSubtractQuantity(
                                                            item,
                                                            "-",
                                                          );
                                                        });
                                                        if (quantity[index] ==
                                                            0) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Deseja Remover o produto do carrinho?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child:
                                                                        const Text(
                                                                      'Remover',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Lógica para remover o produto
                                                                      CartController
                                                                          controller =
                                                                          CartController();
                                                                      controller
                                                                          .removeProductFromCart(
                                                                        item.productId,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        cartMongodb
                                                                            .removeWhere((element) {
                                                                          quantity.removeWhere((element) =>
                                                                              element ==
                                                                              0);
                                                                          return element['product'].productId ==
                                                                              item.productId;
                                                                        });
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Provider.of<
                                                                              CartProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child:
                                                                        const Text(
                                                                      'Cancelar',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      setState(
                                                                          () {
                                                                        quantity[
                                                                            index] = quantity[
                                                                                index] +
                                                                            1;
                                                                        subTotal =
                                                                            subTotal +
                                                                                item.productPrice;
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
                                                    icon: const Icon(
                                                      Icons.remove,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${quantia}${item.measuremntUnit}",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (item.stockQuantity >
                                                            quantity[index]) {
                                                          quantity[index] =
                                                              quantity[index] +
                                                                  1;
                                                          CartController
                                                              controller =
                                                              CartController();
                                                          controller
                                                              .incrementOrSubtractQuantity(
                                                            item,
                                                            "+",
                                                          );
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(Icons.add),
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
                            SizedBox(height: constraints.maxHeight * .03),
                            thinDivider(constraints),
                            SizedBox(height: constraints.maxHeight * .05),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Endereço para entrega:",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, .81),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .02),
                                  SizedBox(
                                    width: constraints.maxWidth * .9,
                                    child: DropdownButtonFormField<String>(
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
                                                  constraints.maxWidth * .03),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                      hint: const Text(
                                          "Escolher endereço para entrega"),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedItem = value.toString();
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
                                  SizedBox(height: constraints.maxHeight * .04),
                                  const Text(
                                    "Data e Horário da entrega:",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, .81),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .02),
                                  SizedBox(
                                    width: constraints.maxWidth * .9,
                                    child: DropdownButtonFormField<String>(
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
                                                  constraints.maxWidth * .03),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                      hint: const Text(
                                        "Escolha o horário para entrega",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDate = value.toString();
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Resumo dos Valores: ",
                                    style: TextStyle(
                                      fontSize: constraints.maxHeight * .02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: constraints.maxHeight * .02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "SubTotal: ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, .81),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "R\$${subTotal.toString()}",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, .81),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: constraints.maxHeight * .01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Taxa de Entrega: ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, .51),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "R\$10.00",
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, .51),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: constraints.maxHeight * .01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Total: ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, .81),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "R\$${subTotal + 10}",
                                        style: const TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, .81),
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
                                final provider = Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                );
                                provider.setCart(cart);
                                provider.setQuantity(quantity);
                                int index = items.indexOf(_selectedItem);
                                CartController controller = CartController();
                                controller.createSell(addressesId[index]);
                                Navigator.of(context).pushNamed(
                                  AppRoutes.PAYMENTSCREEN,
                                );
                              },
                              child: CommonButton(
                                constraints: constraints,
                                text: "Efetuar Pagamento",
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
                              "Seu Carrinho está vaizo :(",
                              style: TextStyle(
                                fontSize: constraints.maxHeight * .025,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * .015),
                            SizedBox(
                              width: constraints.maxWidth * .65,
                              child: Text(
                                "Adicione produtos ao seu carrinho e retorne para está página",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * .02,
                                  color: const Color.fromRGBO(0, 0, 0, 0.7),
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
