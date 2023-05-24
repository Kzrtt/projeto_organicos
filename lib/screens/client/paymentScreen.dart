import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
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
              Icon(
                Icons.shopping_bag,
                color: Color.fromRGBO(108, 168, 129, 0.7),
              ),
              SizedBox(width: 10),
              Text(
                "Pagamento",
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
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .2),
                  SvgPicture.asset(
                    'assets/images/undraw_shopping_app.svg',
                    height: constraints.maxHeight * .3,
                    width: constraints.maxWidth * .3,
                  ),
                  SizedBox(height: constraints.maxHeight * .07),
                  Text(
                    "Pagamento: ",
                    style: TextStyle(
                      fontSize: constraints.maxHeight * .025,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .015),
                  SizedBox(
                    width: constraints.maxWidth * .65,
                    child: Text(
                      "Copia e Cola",
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
          );
        },
      ),
    );
  }
}
