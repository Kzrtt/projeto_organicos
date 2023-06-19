import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/controller/cartController.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/utils/quantityProvider.dart';
import 'package:provider/provider.dart';

import '../../components/smallButton.dart';

class BoxScreen extends StatefulWidget {
  const BoxScreen({Key? key}) : super(key: key);

  @override
  State<BoxScreen> createState() => _BoxScreenState();
}

Widget thinDivider(BoxConstraints constraints) {
  return Center(
    child: Container(
      height: 0.8,
      width: constraints.maxWidth * .7,
      color: Color.fromRGBO(83, 242, 166, 1),
    ),
  );
}

class _BoxScreenState extends State<BoxScreen> {
  bool isLoadingAddToCart = false;
  int value = 1;

  @override
  Widget build(BuildContext context) {
    Box box = ModalRoute.of(context)?.settings.arguments as Box;

    return ChangeNotifierProvider(
      create: (_) => QuantityProvider(
        initialQuantity: List.generate(box.produtos.length, (index) => 1),
      ),
      child: Scaffold(
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
                  box.boxName,
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
            return SingleChildScrollView(
              child: SizedBox(
                height: constraints.maxHeight * 2,
                width: constraints.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * .03),
                        Container(
                          height: constraints.maxHeight * .2,
                          width: constraints.maxWidth * .85,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: box.boxPhoto != ""
                              ? Image.network(
                                  box.boxPhoto,
                                  fit: BoxFit.cover,
                                )
                              : Center(),
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * .11,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                box.boxName,
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * .025,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "R\$${box.boxPrice}",
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * .025,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(113, 227, 154, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * .03),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * .11,
                      ),
                      child: Text(
                        box.boxDetails,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: constraints.maxHeight * .025,
                          color: const Color.fromRGBO(0, 0, 0, 0.68),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * .05),
                    thinDivider(constraints),
                    SizedBox(height: constraints.maxHeight * .03),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxHeight * .06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Produtos: ",
                            style: TextStyle(
                              fontSize: constraints.maxHeight * .024,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight *
                                box.produtos.length /
                                15,
                            width: constraints.maxWidth,
                            child: ListView.builder(
                              itemCount: box.produtos.length,
                              itemBuilder: (context, index) {
                                var item = box.produtos[index];
                                return Consumer<QuantityProvider>(
                                  builder: (context, quantityProvider, _) {
                                    return Column(
                                      children: [
                                        Container(
                                          height: constraints.maxHeight * .1,
                                          width: constraints.maxWidth * .9,
                                          child: Row(
                                            children: [
                                              Container(
                                                height:
                                                    constraints.maxHeight * .1,
                                                width:
                                                    constraints.maxWidth * .44,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(item
                                                        .product.productName),
                                                    Text(
                                                      "Quantidade Max: ${item.product.unitValue * item.quantity}${item.product.measurementUnit}",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height:
                                                    constraints.maxHeight * .1,
                                                width:
                                                    constraints.maxWidth * .35,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        quantityProvider
                                                            .decreaseQuantity(
                                                                index);
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove),
                                                    ),
                                                    Text(
                                                      "${quantityProvider.quantity[index] * item.product.unitValue}${item.measurementUnity}",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        quantityProvider
                                                            .increaseQuantity(
                                                          index,
                                                          item.quantity,
                                                        );
                                                      },
                                                      icon:
                                                          const Icon(Icons.add),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                constraints.maxHeight * .02),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .05),
                          thinDivider(constraints),
                          SizedBox(height: constraints.maxHeight * .05),
                          Text(
                            "Fotos dos produtos: ",
                            style: TextStyle(
                              fontSize: constraints.maxHeight * .024,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .03),
                          SizedBox(
                            height: constraints.maxHeight * .2,
                            width: constraints.maxWidth,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: box.produtos.length,
                              itemBuilder: (context, index) {
                                var item = box.produtos[index];
                                return Row(
                                  children: [
                                    SizedBox(width: constraints.maxWidth * .05),
                                    Container(
                                      height: constraints.maxHeight * .4,
                                      width: constraints.maxWidth * .3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey,
                                      ),
                                      child: item.product.productPhoto != ""
                                          ? Image.network(
                                              item.product.productPhoto,
                                              fit: BoxFit.cover,
                                            )
                                          : Center(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * .05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (value > 0) {
                                        setState(() {
                                          value--;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    "$value Uni",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (value < box.boxQuantity) {
                                        setState(() {
                                          value++;
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              title: Text(
                                                "Temos apenas ${box.boxQuantity} unidades da ${box.boxName} em estoque",
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                              SizedBox(width: constraints.maxWidth * .05),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isLoadingAddToCart = true;
                                  });
                                  CartController controller = CartController();
                                  List<Map<String, dynamic>> produtos = [];
                                  for (var i = 0;
                                      i < box.produtos.length;
                                      i++) {
                                    final provider =
                                        Provider.of<QuantityProvider>(
                                      context,
                                      listen: false,
                                    );
                                    produtos.add({
                                      "productId":
                                          box.produtos[i].product.productId,
                                      "quantity": provider.quantity[i],
                                    });
                                  }
                                  controller
                                      .addBoxToCart(
                                    box,
                                    produtos,
                                    value,
                                    context,
                                  )
                                      .then(
                                    (value) {
                                      setState(() {
                                        isLoadingAddToCart = false;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                child: isLoadingAddToCart
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: const Color.fromRGBO(
                                              113, 227, 154, 1),
                                        ),
                                      )
                                    : SmallButton(
                                        constraints: constraints,
                                        text: "Adicionar",
                                        color: true,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
