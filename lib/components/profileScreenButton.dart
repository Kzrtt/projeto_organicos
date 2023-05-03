import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileScreenButton extends StatefulWidget {
  final BoxConstraints constraints;
  final String text;
  final String subtext;
  final IconData icon;
  final Function() buttonFunction;
  const ProfileScreenButton({
    Key? key,
    required this.constraints,
    required this.text,
    required this.subtext,
    required this.icon,
    required this.buttonFunction,
  }) : super(key: key);

  @override
  State<ProfileScreenButton> createState() => _ProfileScreenButtonState();
}

class _ProfileScreenButtonState extends State<ProfileScreenButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: widget.constraints.maxHeight * .015),
        SizedBox(
          height: widget.constraints.maxHeight * .1,
          width: widget.constraints.maxWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.constraints.maxWidth * .06,
              vertical: widget.constraints.maxHeight * .02,
            ),
            child: ListTile(
              leading: Icon(
                widget.icon,
                color: const Color.fromRGBO(132, 202, 157, 1),
              ),
              title: Text(widget.text),
              subtitle: Text(widget.subtext),
              onTap: widget.buttonFunction,
            ),
          ),
        ),
      ],
    );
  }
}
