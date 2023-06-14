import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/category.dart';
import 'package:projeto_organicos/model/measurementUnit.dart';

import '../model/products.dart';

class ProductsInfoDialog extends StatefulWidget {
  Products product;
  BoxConstraints constraints;
  List<Measurement> measurementList;
  List<Category> categoryList;
  ProductsInfoDialog({
    super.key,
    required this.product,
    required this.constraints,
    required this.measurementList,
    required this.categoryList,
  });

  @override
  State<ProductsInfoDialog> createState() => _ProductsInfoDialogState();
}

class _ProductsInfoDialogState extends State<ProductsInfoDialog> {
  final TextEditingController unitValueController = TextEditingController();
  final TextEditingController stockQuantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Widget _textField1(
    double height,
    double width,
    BoxConstraints constraints,
    String text,
    TextEditingController controller,
    String? Function(String?) validate,
  ) {
    return SizedBox(
      height: constraints.maxHeight * height,
      width: constraints.maxWidth * width,
      child: TextFormField(
        maxLines: null,
        expands: true,
        controller: controller,
        validator: validate,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: constraints.maxWidth * .03),
            borderRadius: const BorderRadius.all(
              Radius.circular(14),
            ),
          ),
          hintText: text,
          hintStyle: TextStyle(
            fontSize: constraints.maxHeight * .02,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      title: Text(
        "${widget.product.productName} (${widget.product.measurementUnit})",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(0, 0, 0, 0.58),
        ),
      ),
      content: SizedBox(
        height: widget.constraints.maxHeight * .7,
        width: widget.constraints.maxWidth * .9,
        child: Column(
          children: [
            _textField1(
              .1,
              .9,
              widget.constraints,
              "Unidade de Valor: ${widget.product.unitValue.toString()}",
              unitValueController,
              (p0) => null,
            ),
            SizedBox(height: widget.constraints.maxHeight * .03),
            _textField1(
              .1,
              .9,
              widget.constraints,
              "Quantidade em Estoque: ${widget.product.stockQuantity.toString()}",
              stockQuantityController,
              (p0) => null,
            ),
            SizedBox(height: widget.constraints.maxHeight * .03),
            _textField1(
              .1,
              .9,
              widget.constraints,
              "Preço: ${widget.product.productPrice.toString()}",
              priceController,
              (p0) => null,
            ),
            SizedBox(height: widget.constraints.maxHeight * .05),
            InkWell(
              onTap: () {
                ProductController controller = ProductController();
                controller.clearStock(widget.product);
                Navigator.of(context).pop();
              },
              child: CommonButton(
                constraints: widget.constraints,
                text: "Limpar Estoque",
              ),
            ),
          ],
        ),
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

            num newQuantity = 0;
            if (stockQuantityController.text != "") {
              num quantityControllerInt =
                  int.parse(stockQuantityController.text);
              newQuantity = quantityControllerInt +
                  (widget.product.stockQuantity * widget.product.unitValue);
            } else {
              newQuantity =
                  widget.product.stockQuantity * widget.product.unitValue;
            }

            num stockQuantity = 0;
            if (unitValueController.text != "") {
              num unitController = int.parse(unitValueController.text);
              stockQuantity = (newQuantity / unitController);
            } else {
              stockQuantity = (newQuantity / widget.product.unitValue);
            }

            String measurementUnitId = "";
            for (var element in widget.measurementList) {
              if (element.measurementUnit == widget.product.measurementUnit) {
                measurementUnitId = element.id;
              }
            }

            List<String> categorias = [];
            for (var element in widget.categoryList) {
              for (var i = 0; i < widget.product.category.length; i++) {
                if (element.categoryName == widget.product.category[i]) {
                  categorias.add(element.categoryId);
                }
              }
            }

            Products newProduct = Products(
              productId: widget.product.productId,
              productName: widget.product.productName,
              category: categorias,
              productPhoto: widget.product.productPhoto,
              productPrice: priceController.text != ""
                  ? int.parse(priceController.text)
                  : widget.product.productPrice,
              stockQuantity: stockQuantity,
              unitValue: unitValueController.text != ""
                  ? int.parse(unitValueController.text)
                  : widget.product.unitValue,
              productDetails: widget.product.productDetails,
              cooperativeId: widget.product.cooperativeId,
              producerId: widget.product.producerId,
              measurementUnit: measurementUnitId,
            );

            controller.updateProduct(
              widget.product.productId,
              newProduct,
              widget.product,
            );
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Color.fromRGBO(108, 168, 129, 0.7),
          ),
        ),
      ],
    );
  }
}
