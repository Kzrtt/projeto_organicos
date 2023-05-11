import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/screens/producer/openSells.dart';
import 'package:projeto_organicos/screens/producer/producerHomeScreen.dart';
import 'package:projeto_organicos/screens/producer/producerProfileScreen.dart';
import 'package:projeto_organicos/screens/producer/productListScreen.dart';
import 'package:projeto_organicos/utils/globalVariable.dart';

class ProducerHomeTab extends StatefulWidget {
  const ProducerHomeTab({Key? key}) : super(key: key);

  @override
  State<ProducerHomeTab> createState() => _ProducerHomeTabState();
}

class _ProducerHomeTabState extends State<ProducerHomeTab> {
  int _currentIndex = 0;
  final GlobalVariable globalVariable = GlobalVariable();

  void changePage(int tabIndex) {
    setState(() {
      globalVariable.tabProducerValue = tabIndex;
    });
  }

  late final List<Widget> _baseProducerScreens = [
    ProducerHomeScreen(callbackFunction: changePage),
    ProductListScreen(),
    ProducerProfileScreen(),
    OpenSells(),
  ];

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
        onTap: (index) => setState((() {
          _currentIndex = index;
          globalVariable.tabProducerValue = index;
        })),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      bottomNavigationBar: bottomNavigationBar,
      body: _baseProducerScreens[globalVariable.getProducerTabValue],
    );
  }
}
