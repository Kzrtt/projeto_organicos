// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/smallButton.dart';
import 'package:projeto_organicos/model/adress.dart';
import 'package:projeto_organicos/controller/userController.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/userState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdressScreen extends StatefulWidget {
  const AdressScreen({Key? key}) : super(key: key);

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  String _selectedItem = "";
  bool isLoading = false;
  UserState userState = UserState();
  List<Adress> adress = [];
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

  void loadAdresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserController userController = UserController();
    String? userId = prefs.getString("userId");
    List<Adress> temp = await userController.getAllAdresses(userId!);
    UserState userState = UserState();
    userState.setAdressList(temp);
    print(userState.adressList.length);
    setState(() {
      defaultAddress = temp.singleWhere((element) => element.isDefault == true);
      adress = temp;
    });
    print(adress.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAdresses();
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = adress.map((e) => e.nickname).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: constraints.maxHeight * 1.1,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    NameAndIcon(
                      constraints: constraints,
                      icon: Icons.map,
                      text: "Endereços",
                    ),
                    SizedBox(height: constraints.maxHeight * .035),
                    SizedBox(
                      width: constraints.maxWidth * .9,
                      child: DropdownButtonFormField<String>(
                        value: _selectedItem.isNotEmpty ? _selectedItem : null,
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
                        ),
                        hint: const Text("Escolher endereço padrão"),
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
                    SizedBox(height: constraints.maxHeight * .03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          defaultAddress.nickname != ""
                              ? "Padrão: ${defaultAddress.nickname}"
                              : "Endereço padrão",
                          style: const TextStyle(
                            color: Color.fromRGBO(18, 18, 18, 0.58),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            UserController controller = UserController();
                            Adress a = adress.singleWhere(
                                (element) => element.nickname == _selectedItem);
                            controller.setDefaultAddress(a.adressId);
                            setState(() {
                              defaultAddress = a;
                            });
                          },
                          child: Container(
                            height: constraints.maxHeight * .06,
                            width: constraints.maxWidth * .5,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color.fromRGBO(83, 242, 166, 0.47),
                            ),
                            child: Center(
                              child: Text(
                                "Definir Padrão",
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * .025,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * .05),
                    SizedBox(
                      height: constraints.maxHeight * .7,
                      child: ListView.builder(
                        itemCount: adress.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * .03),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.map,
                                      size: constraints.maxHeight * .06,
                                      color: const Color.fromRGBO(
                                          108, 168, 129, 0.7),
                                    ),
                                    title: Text(adress[index].nickname),
                                    subtitle: Text('${adress[index].street}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () async {
                                        UserState userState = UserState();
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        String? userId =
                                            prefs.getString("userId");
                                        UserController userController =
                                            UserController();
                                        userState.removeAdress(
                                          adress[index].adressId,
                                        );
                                        userController.deleteAdress(
                                          userId!,
                                          adress[index].adressId,
                                        );
                                        setState(() {
                                          adress.removeWhere(
                                            (element) =>
                                                element.adressId ==
                                                adress[index].adressId,
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * .02),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * .02),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 75.0,
              right: 15.0,
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(83, 242, 166, 0.69),
                onPressed: () async {
                  var result = await Navigator.of(context)
                      .pushNamed(AppRoutes.ADDADRESS) as Adress;
                  setState(() {
                    adress.add(result);
                  });
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
