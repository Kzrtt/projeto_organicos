import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/client/adressScreen.dart';
import 'package:projeto_organicos/screens/client/cartScreen.dart';
import 'package:projeto_organicos/screens/client/feedbackScreen.dart';
import 'package:projeto_organicos/screens/client/historicScreen.dart';
import 'package:projeto_organicos/screens/client/homeScreen.dart';
import 'package:projeto_organicos/screens/client/profileScreen.dart';
import 'package:projeto_organicos/screens/client/searchScreen.dart';
import 'package:projeto_organicos/screens/client/sellDetails.dart';
import 'package:projeto_organicos/screens/client/userInfoScreen.dart';
import 'package:projeto_organicos/utils/globalVariable.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentIndex = 0;
  final int _tab = 0;
  final globalVariable = GlobalVariable();

  void changePage(int tabIndex) {
    setState(() {
      globalVariable.tabValue = tabIndex;
    });
  }

  late final List<Widget> _baseScreens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    ProfileScreen(callbackFunction: changePage),
    const AdressScreen(),
    HistoricScreen(callbackFunction: changePage),
    const SellDetails(),
    const UserInfoScreen(),
    const FeedbackScreen(),
  ];

  Widget _buildBody(int tabIndex, List baseScreens, List childScreens) {
    return Consumer<GlobalVariable>(
      builder: ((context, globalVariable, child) {
        if (globalVariable.getTabValue <= 3) {
          return baseScreens[tabIndex];
        } else {
          return childScreens[tabIndex];
        }
      }),
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
        onTap: (index) => setState((() {
          _currentIndex = index;
          globalVariable.tabValue = index;
        })),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      bottomNavigationBar: bottomNavigationBar,
      body: Center(
        child: _baseScreens[globalVariable.getTabValue],
      ),
    );
  }
}
