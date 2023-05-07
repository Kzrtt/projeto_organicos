import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class AdressScreen extends StatefulWidget {
  const AdressScreen({Key? key}) : super(key: key);

  @override
  State<AdressScreen> createState() => _AdressScreenState();
}

class _AdressScreenState extends State<AdressScreen> {
  String _selectedItem = "";
  final List<String> items = ["item1", "item2", "item3", "item4"];

  @override
  Widget build(BuildContext context) {
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
                /*
                SizedBox(height: constraints.maxHeight * .03),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedItem.isEmpty
                            ? "Endereço principal"
                            : _selectedItem,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: constraints.maxHeight * .06,
                          width: constraints.maxWidth * .4,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(83, 242, 166, 0.69),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Center(
                            child: Text(
                              "Salvar",
                              style: TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: constraints.maxHeight * .024,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                */
                SizedBox(height: constraints.maxHeight * .05),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .03),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.map,
                        size: constraints.maxHeight * .06,
                        color: const Color.fromRGBO(108, 168, 129, 0.7),
                      ),
                      title: const Text('Casa'),
                      subtitle: const Text('Rua Alagoas, n°1392'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .02),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .03),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.map,
                        size: constraints.maxHeight * .06,
                        color: const Color.fromRGBO(108, 168, 129, 0.7),
                      ),
                      title: const Text('Faculdade'),
                      subtitle: const Text(
                        'Linha Santa Bárbara, s/n - Francisco Beltrão',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 75.0,
              right: 15.0,
              child: FloatingActionButton(
                backgroundColor: const Color.fromRGBO(83, 242, 166, 0.69),
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
