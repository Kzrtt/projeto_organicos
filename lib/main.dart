import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/client/adressScreen.dart';
import 'package:projeto_organicos/screens/client/cartScreen.dart';
import 'package:projeto_organicos/screens/client/homeScreen.dart';
import 'package:projeto_organicos/screens/client/homeTab.dart';
import 'package:projeto_organicos/screens/client/profileScreen.dart';
import 'package:projeto_organicos/screens/client/searchScreen.dart';
import 'package:projeto_organicos/screens/producer/producerHomeScreen.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/globalVariable.dart';
import 'package:provider/provider.dart';

import 'screens/client/openingScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalVariable()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Radix',
        theme: ThemeData(
          visualDensity: VisualDensity.comfortable,
        ),
        routes: {
          //rotas para trocar as páginas
          //Página inicial: HomeTab, as outras páginas são abertas dentro do body dela
          AppRoutes.OPENINGSCREEN: (ctx) => const OpeningScreen(),
          AppRoutes.HOMESCREEN: (ctx) => const HomeScreen(),
          AppRoutes.SEARCHSCREEN: (ctx) => const SearchScreen(),
          AppRoutes.HOMETAB: (ctx) => const HomeTab(),
          AppRoutes.CARTSCREEN: (ctx) => const CartScreen(),
          //Producer app routes
          ProducerAppRoutes.PRODUCERHOMESCREEN: (ctx) =>
              const ProducerHomeScreen(),
        },
      ),
    );
  }
}
