import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/screens/producer/addProducerScreen.dart';
import 'package:projeto_organicos/screens/producer/addProductScreen.dart';
import 'package:projeto_organicos/screens/producer/cooperativeInfoScreen.dart';
import 'package:projeto_organicos/screens/producer/openSells.dart';
import 'package:projeto_organicos/screens/producer/openSellsDetails.dart';
import 'package:projeto_organicos/screens/producer/producerHomeScreen.dart';
import 'package:projeto_organicos/screens/producer/producerProfileScreen.dart';
import 'package:projeto_organicos/screens/producer/productListScreen.dart';
import 'package:projeto_organicos/screens/producer/teste.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/globalVariable.dart';
import 'package:provider/provider.dart';

import '../../model/cooperative.dart';

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
    final cooperativeState = Provider.of<CooperativeState>(context);
    Cooperative? cooperative = cooperativeState.getCooperative;

    late final List<Widget> _baseProducerScreens = [
      ProducerHomeScreen(callbackFunction: changePage),
      const ProductListScreen(),
      ProducerProfileScreen(
        cooperative: cooperative!,
        callbackFunction: changePage,
      ),
      const OpenSells(),
      OpenSellsDetails(),
      CooperativeInfoScreen(callbackFunction: changePage),
      AddProductScreen(),
      AddProducerScreen(callbackFunction: changePage),
      Teste(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      bottomNavigationBar: bottomNavigationBar,
      body: _baseProducerScreens[globalVariable.getProducerTabValue],
    );
  }
}
