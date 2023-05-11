import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/client/adressScreen.dart';
import 'package:projeto_organicos/screens/client/cartScreen.dart';
import 'package:projeto_organicos/screens/client/homeScreen.dart';
import 'package:projeto_organicos/screens/client/homeTab.dart';
import 'package:projeto_organicos/screens/client/profileScreen.dart';
import 'package:projeto_organicos/screens/client/searchScreen.dart';
import 'package:projeto_organicos/screens/client/signUpScreen.dart';
import 'package:projeto_organicos/screens/producer/producerHomeTab.dart';
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
          primaryColor: const Color.fromRGBO(83, 242, 166, 0.69),
        ),
        routes: {
          //rotas para trocar as páginas
          //Página inicial: HomeTab, as outras páginas são abertas dentro do body dela
          AppRoutes.OPENINGSCREEN: (ctx) => const OpeningScreen(),
          AppRoutes.HOMETAB: (ctx) => const HomeTab(),
          AppRoutes.SIGNUPSCREEN: (ctx) => const SignUpScreen(),
          //Producer app routes
          ProducerAppRoutes.PRODUCERHOMETAB: (ctx) => const ProducerHomeTab(),
        },
      ),
    );
  }
}
