import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class WhiteRoundedCornersBox extends StatelessWidget {
  final String text;
  const WhiteRoundedCornersBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.58)),
        ),
      ),
    );
  }
}
