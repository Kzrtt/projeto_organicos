import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class ProducerHomeScreen extends StatefulWidget {
  const ProducerHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProducerHomeScreen> createState() => _ProducerHomeScreenState();
}

class _ProducerHomeScreenState extends State<ProducerHomeScreen> {
  int _currentIndex = 0;

  Widget simpleBox(BoxConstraints constraints, Color color, String text,
      Function() function) {
    return InkWell(
      onTap: function,
      child: Container(
        height: constraints.maxHeight * .22,
        width: constraints.maxWidth * .4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      ),
      child: BottomNavigationBar(
        elevation: 6,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(83, 242, 166, 0.58),
        iconSize: 28,
        unselectedItemColor: const Color.fromRGBO(0, 0, 0, 0.58),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState((() => _currentIndex = index)),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                NameAndIcon(
                  constraints: constraints,
                  icon: Icons.star,
                  text: "Bem vindo Cooperativa",
                ),
                SizedBox(height: constraints.maxHeight * .03),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        simpleBox(
                          constraints,
                          const Color.fromRGBO(250, 215, 215, 1),
                          "Pedidos Abertos",
                          () => null,
                        ),
                        simpleBox(
                          constraints,
                          const Color.fromRGBO(245, 220, 190, 1),
                          "Faturamento",
                          () => null,
                        )
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * .04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        simpleBox(
                          constraints,
                          const Color.fromRGBO(255, 253, 211, 1),
                          "Pedidos Finalizados",
                          () => null,
                        ),
                        simpleBox(
                          constraints,
                          const Color.fromRGBO(213, 234, 253, 1),
                          "Editar perfil",
                          () => null,
                        )
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * .05),
                    Container(
                      color: Colors.blueGrey,
                      height: constraints.maxHeight * .3,
                      width: constraints.maxWidth * .6,
                    ),
                  ],
                )
              ],
            );
          },
        );

      case 1:
        return Center();

      case 2:
        return Center();

      default:
        return Center(child: Text("Error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      bottomNavigationBar: bottomNavigationBar,
      body: _buildBody(_currentIndex),
    );
  }
}
