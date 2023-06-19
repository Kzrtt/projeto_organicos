import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/controller/productController.dart';
import 'package:projeto_organicos/model/box.dart';
import 'package:projeto_organicos/utils/validators.dart';

class UpdateBoxScreen extends StatefulWidget {
  const UpdateBoxScreen({super.key});

  @override
  State<UpdateBoxScreen> createState() => _UpdateBoxScreenState();
}

Widget thinDivider(BoxConstraints constraints) {
  return Center(
    child: Container(
      height: 0.8,
      width: constraints.maxWidth * .7,
      color: Color.fromRGBO(83, 242, 166, 1),
    ),
  );
}

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

class _UpdateBoxScreenState extends State<UpdateBoxScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  Validators validators = Validators();
  final FirebaseStorage storage = FirebaseStorage.instance;
  XFile? _storagedImage;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _storagedImage = image;
    });

    return image;
  }

  Future<String> uploadImage(
      String path, String string, String fotoPath) async {
    File file = File(path);
    try {
      String ref = '$fotoPath/$string.jpg';
      UploadTask uploadTask = storage.ref(ref).putFile(file);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception("erro: ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Box box = ModalRoute.of(context)?.settings.arguments as Box;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(108, 168, 129, 0.7),
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.favorite,
                  color: Color.fromRGBO(108, 168, 129, 0.7)),
              const SizedBox(width: 10),
              Text(
                box.boxName,
                style: const TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight * 1.4,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .03),
                  SizedBox(
                    height: constraints.maxHeight * .6,
                    width: constraints.maxWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * .85,
                          child: Text(
                            "Preencha somente os campos que deseja alterar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromRGBO(18, 18, 18, 0.58),
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxHeight * .023,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * .05),
                        _textField1(
                          .1,
                          .9,
                          constraints,
                          box.boxName,
                          nameController,
                          validators.nameValidator,
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        _textField1(
                          .1,
                          .9,
                          constraints,
                          box.boxDetails,
                          detailsController,
                          (p0) => null,
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        _textField1(
                          .1,
                          .9,
                          constraints,
                          "${box.boxPrice}R\$",
                          priceController,
                          (p0) => null,
                        ),
                        SizedBox(height: constraints.maxHeight * .03),
                        _textField1(
                          .1,
                          .9,
                          constraints,
                          "${box.boxQuantity} unidades",
                          quantityController,
                          (p0) => null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * .04),
                  thinDivider(constraints),
                  SizedBox(height: constraints.maxHeight * .04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => getImage(),
                        child: const Text(
                          "Foto",
                          style: TextStyle(
                            color: Color.fromRGBO(18, 18, 18, 0.58),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: constraints.maxHeight * .2,
                        width: constraints.maxWidth * .3,
                        color: Colors.grey,
                        child: _storagedImage != null
                            ? Image.file(
                                File(_storagedImage!.path),
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.camera_alt_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * .08),
                  InkWell(
                    onTap: () async {
                      ProductController controller = ProductController();

                      String photoUrl = "";
                      if (_storagedImage != null) {
                        if (nameController.text != "") {
                          photoUrl = await uploadImage(
                            _storagedImage!.path,
                            "${nameController.text}.jpg",
                            "boxPhotos",
                          );
                        } else {
                          photoUrl = await uploadImage(
                            _storagedImage!.path,
                            "${box.boxName}.jpg",
                            "boxPhotos",
                          );
                        }
                      }

                      Box newBox = Box(
                        id: box.id,
                        boxDetails: detailsController.text != ""
                            ? detailsController.text
                            : box.boxDetails,
                        boxName: nameController.text != ""
                            ? nameController.text
                            : box.boxName,
                        boxPhoto: photoUrl,
                        boxPrice: priceController.text != ""
                            ? double.parse(priceController.text)
                            : box.boxPrice,
                        boxQuantity: quantityController.text != ""
                            ? int.parse(quantityController.text)
                            : box.boxQuantity,
                        boughtQuantity: 0,
                        produtos: box.produtos,
                      );

                      controller.updateBox(newBox, box);

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(newBox);
                    },
                    child: CommonButton(
                      constraints: constraints,
                      text: "Salvar",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
