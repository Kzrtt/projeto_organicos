import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              stops: [0.8, 1],
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(238, 238, 238, 1),
                Color.fromRGBO(83, 242, 166, 1),
              ],
            ),
          ),
          child: Column(
            children: [
              NameAndIcon(
                constraints: constraints,
                icon: Icons.search,
                text: "Busca",
              ),
              SizedBox(height: constraints.maxHeight * .02),
              SizedBox(
                height: constraints.maxHeight * .08,
                width: constraints.maxWidth * .95,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: constraints.maxWidth * .03),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color.fromRGBO(108, 168, 129, 0.7),
                    ),
                    hintText: "Busca",
                    hintStyle: TextStyle(
                      fontSize: constraints.maxHeight * .02,
                    ),
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * .015),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * .012,
                  horizontal: constraints.maxWidth * .04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: constraints.maxHeight * .03,
                      width: constraints.maxWidth * .2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(255, 23, 23, 0.33),
                      ),
                      child: const Center(child: Text("Carnes")),
                    ),
                    Container(
                      height: constraints.maxHeight * .03,
                      width: constraints.maxWidth * .45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(112, 250, 151, 0.33),
                      ),
                      child: const Center(child: Text("Agricultura Familiar")),
                    ),
                    Container(
                      height: constraints.maxHeight * .03,
                      width: constraints.maxWidth * .2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color.fromRGBO(111, 176, 253, 0.33),
                      ),
                      child: const Center(child: Text("Verduras")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
