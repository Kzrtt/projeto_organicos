import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final void Function() callback;
  final BoxConstraints constraints;
  final IconData icon;
  final String text;
  final IconData secondIcon;
  final Color secondIconColor;
  // ignore: use_key_in_widget_constructors
  const CustomAppBar({
    required this.constraints,
    required this.icon,
    required this.text,
    required this.callback,
    required this.secondIcon,
    required this.secondIconColor,
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
                    Row(
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
                    SizedBox(width: constraints.maxWidth * .55),
                    InkWell(
                      onTap: () => callback(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * .05,
                        ),
                        child: Icon(
                          secondIcon,
                          color: secondIconColor,
                        ),
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
