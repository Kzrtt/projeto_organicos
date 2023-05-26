import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/components/sellBoxClientEdition.dart';
import 'package:projeto_organicos/model/sell.dart';

class SellDetails extends StatefulWidget {
  const SellDetails({Key? key}) : super(key: key);

  @override
  State<SellDetails> createState() => _SellDetailsState();
}

class _SellDetailsState extends State<SellDetails> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> sell =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String year = sell[0].sellDate.substring(0, 4);
    String month = sell[0].sellDate.substring(5, 7);
    String day = sell[0].sellDate.substring(8, 10);

    String formattedDate = '$day-$month-$year';

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
              Icon(Icons.receipt, color: Color.fromRGBO(108, 168, 129, 0.7)),
              SizedBox(width: 10),
              Text(
                "Detalhes da Venda",
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
          return SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight * 1.2,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .03),
                  Text(
                    "Data do pedido: $formattedDate",
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, .68),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .04),
                  //Caixa do pedido
                  SellBoxClientEdition(
                    constraints: constraints,
                    sell: sell[0],
                    index: sell[1],
                  ),
                  SizedBox(height: constraints.maxHeight * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Entrega: ",
                        style: TextStyle(
                          color: const Color.fromRGBO(0, 0, 0, .58),
                          fontWeight: FontWeight.w600,
                          fontSize: constraints.maxHeight * .025,
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * .03),
                      Padding(
                        padding:
                            EdgeInsets.only(top: constraints.maxHeight * .02),
                        child: const Text(
                          "aguardando liberação do pedido \n(55) 11 94578-8944",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, .4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * .04),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: constraints.maxHeight * .06,
                        width: constraints.maxWidth * .6,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(251, 126, 126, 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text(
                            "Cancelar Pedido",
                            style: TextStyle(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxHeight * .024,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
