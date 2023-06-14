import 'package:flutter/material.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/products.dart';

class QuantidadeDialog extends StatefulWidget {
  final Products product;

  const QuantidadeDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _QuantidadeDialogState createState() => _QuantidadeDialogState();
}

class _QuantidadeDialogState extends State<QuantidadeDialog> {
  int quantidade = 1;

  void incrementar() {
    setState(() {
      quantidade++;
    });
  }

  void decrementar() {
    if (quantidade > 0) {
      setState(() {
        quantidade--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.product.productName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.58),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "1 unidade = ${widget.product.unitValue}${widget.product.measurementUnit}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 0, 0, 0.58),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: decrementar,
                icon: Icon(Icons.remove),
              ),
              Text(
                "$quantidade unidades",
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                onPressed: incrementar,
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
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
            ProductController controller = ProductController();
            controller.updateQuantity(widget.product, quantidade);
            Navigator.of(context).pop(quantidade);
          },
          style: TextButton.styleFrom(
            foregroundColor: Color.fromRGBO(108, 168, 129, 0.7),
          ),
        ),
      ],
    );
  }
}
