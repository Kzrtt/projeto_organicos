// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
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

  void loadAdresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserController userController = UserController();
    String? userId = prefs.getString("userId");
    List<Adress> temp = await userController.getAllAdresses(userId!);
    UserState userState = UserState();
    userState.setAdressList(temp);
    print(userState.adressList.length);
    setState(() {
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
            Column(
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
                                  color:
                                      const Color.fromRGBO(108, 168, 129, 0.7),
                                ),
                                title: Text(adress[index].nickname),
                                subtitle:
                                    Text('${adress[index].street}, n°1392'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () async {
                                    UserState userState = UserState();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? userId = prefs.getString("userId");
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
