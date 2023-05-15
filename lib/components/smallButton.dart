import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final BoxConstraints constraints;
  final String text;
  final bool color;
  const SmallButton({
    required this.constraints,
    required this.text,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: constraints.maxHeight * .06,
        width: constraints.maxWidth * .35,
        decoration: BoxDecoration(
          color: color
              ? const Color.fromRGBO(83, 242, 166, 0.69)
              : const Color.fromRGBO(251, 126, 126, 1),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontWeight: FontWeight.bold,
              fontSize: constraints.maxHeight * .024,
            ),
          ),
        ),
      ),
    );
  }
}
