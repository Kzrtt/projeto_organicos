import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.warning,
                text: "Aviso",
              ),
              SizedBox(height: constraints.maxHeight * .2),
              SvgPicture.asset(
                'assets/images/undraw_appreciation_r2a1.svg',
                height: constraints.maxHeight * .3,
                width: constraints.maxWidth * .3,
              ),
              SizedBox(height: constraints.maxHeight * .04),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Está funcionalidade não está disponivel na Beta :(",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: constraints.maxHeight * .03,
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
