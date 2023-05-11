import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final BoxConstraints constraints;
  final String text;
  const CommonButton({
    required this.constraints,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: constraints.maxHeight * .06,
        width: constraints.maxWidth * .6,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(83, 242, 166, 0.69),
          borderRadius: BorderRadius.all(Radius.circular(30)),
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
