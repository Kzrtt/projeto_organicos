import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsText extends StatelessWidget {
  final BoxConstraints constraints;
  final String text;
  final bool? isDesativarConta;
  const SettingsText({
    Key? key,
    required this.constraints,
    required this.text,
    this.isDesativarConta = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: constraints.maxHeight * .015),
        Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: isDesativarConta!
                ? Colors.red
                : const Color.fromRGBO(18, 18, 18, .58),
            fontSize: constraints.maxHeight * .025,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
