import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxClientEdition.dart';
import 'package:projeto_organicos/components/smallButton.dart';

class OpenSellsDetails extends StatefulWidget {
  const OpenSellsDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<OpenSellsDetails> createState() => _OpenSellsDetailsState();
}

class _OpenSellsDetailsState extends State<OpenSellsDetails> {
  String _selectedItem = "";
  List<String> items = ["Preparando", "A Caminho"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Icon(Icons.receipt, color: Color.fromRGBO(108, 168, 129, 0.7)),
              SizedBox(width: 10),
              Text(
                "Pedido N°1",
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
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight * 1.3,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .03),
                  const Text(
                    "Data do Pedido: 04/05/2023",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.58),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .02),
                  //SellBoxClientEdition(constraints: constraints),
                  SizedBox(height: constraints.maxHeight * .05),
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
                      hint: const Text("Alterar status do pedido"),
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * .05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SmallButton(
                          constraints: constraints,
                          text: "Salvar",
                          color: true,
                        ),
                        SizedBox(width: constraints.maxWidth * .2),
                        SmallButton(
                          constraints: constraints,
                          text: "Cancelar",
                          color: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .16),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * .05,
                    ),
                    child: const Text(
                      "Ao cancelar um pedido você deve clicar no botão cancelar e aguardar o contato da nossa equipe",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
