import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/homeScreen.dart';
import 'package:projeto_organicos/screens/homeTab.dart';
import 'package:projeto_organicos/screens/searchScreen.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:provider/provider.dart';

import 'screens/openingScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radix',
      theme: ThemeData(
        visualDensity: VisualDensity.comfortable,
      ),
      routes: {
        AppRoutes.OPENINGSCREEN: (ctx) => const OpeningScreen(),
        AppRoutes.HOMESCREEN: (ctx) => const HomeScreen(),
        AppRoutes.SEARCHSCREEN: (ctx) => const SearchScreen(),
        AppRoutes.HOMETAB: (ctx) => const HomeTab(),
      },
    );
  }
}
