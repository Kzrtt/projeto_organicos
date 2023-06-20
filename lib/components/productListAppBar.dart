import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductListAppBar extends StatefulWidget {
  final Future<void> Function() callback;
  final BoxConstraints constraints;
  final IconData icon;
  final String text;
  final IconData secondIcon;
  final Color secondIconColor;
  // ignore: use_key_in_widget_constructors
  const ProductListAppBar({
    required this.constraints,
    required this.icon,
    required this.text,
    required this.callback,
    required this.secondIcon,
    required this.secondIconColor,
  });

  @override
  State<ProductListAppBar> createState() => _ProductListAppBarState();
}

class _ProductListAppBarState extends State<ProductListAppBar> {
  bool isClearingStock = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: widget.constraints.maxHeight * .025),
        Padding(
          padding: EdgeInsets.all(widget.constraints.maxHeight * .015),
          child: SizedBox(
            width: widget.constraints.maxWidth,
            child: Padding(
              padding: EdgeInsets.only(left: widget.constraints.maxWidth * .02),
              child: SizedBox(
                width: widget.constraints.maxWidth,
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.icon,
                          color: const Color.fromRGBO(108, 168, 129, 0.7),
                        ),
                        SizedBox(width: widget.constraints.maxWidth * .01),
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: Color.fromRGBO(18, 18, 18, 0.58),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: widget.constraints.maxWidth * .54),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Limpar Estoque'),
                              content:
                                  Text('Deseja mesmo limpar todo o estoque?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  child: Text('Confirmar'),
                                  onPressed: () {
                                    setState(() {
                                      isClearingStock = true;
                                    });
                                    widget.callback().then((value) {
                                      setState(() {
                                        isClearingStock = false;
                                      });
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.constraints.maxWidth * .01,
                        ),
                        child: isClearingStock
                            ? CircularProgressIndicator(
                                color: const Color.fromRGBO(113, 227, 154, 1),
                              )
                            : Icon(
                                widget.secondIcon,
                                color: widget.secondIconColor,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
