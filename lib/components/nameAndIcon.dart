import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NameAndIcon extends StatelessWidget {
  final BoxConstraints constraints;
  final IconData icon;
  final String text;
  // ignore: use_key_in_widget_constructors
  const NameAndIcon({
    required this.constraints,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: constraints.maxHeight * .025),
        Padding(
          padding: EdgeInsets.all(constraints.maxHeight * .015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth * .02),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: const Color.fromRGBO(108, 168, 129, 0.7),
                    ),
                    SizedBox(width: constraints.maxWidth * .01),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Color.fromRGBO(18, 18, 18, 0.58),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
