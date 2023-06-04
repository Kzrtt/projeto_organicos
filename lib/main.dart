import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_organicos/screens/client/addAdressScreen.dart';
import 'package:projeto_organicos/screens/client/addFeedbackScreen.dart';
import 'package:projeto_organicos/screens/client/boxScreen.dart';
import 'package:projeto_organicos/screens/client/forgotPassword.dart';
import 'package:projeto_organicos/screens/client/homeTab.dart';
import 'package:projeto_organicos/screens/client/paymentScreen.dart';
import 'package:projeto_organicos/screens/client/productScreen.dart';
import 'package:projeto_organicos/screens/client/productsFromCategory.dart';
import 'package:projeto_organicos/screens/client/sellDetails.dart';
import 'package:projeto_organicos/screens/client/signUpScreen.dart';
import 'package:projeto_organicos/screens/producer/cooperativeAddFeedbackScreen.dart';
import 'package:projeto_organicos/screens/producer/openSellsDetails.dart';
import 'package:projeto_organicos/screens/producer/producerHomeTab.dart';
import 'package:projeto_organicos/screens/producer/selectProductsToBox.dart';
import 'package:projeto_organicos/screens/producer/signUpCooperativa.dart';
import 'package:projeto_organicos/screens/producer/updateProductScreen.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/cartProvider.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/globalVariable.dart';
import 'package:projeto_organicos/utils/quantityProvider.dart';
import 'package:projeto_organicos/utils/userState.dart';
import 'package:provider/provider.dart';

import 'screens/client/openingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalVariable()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => CooperativeState()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projeto Orgânicos',
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
          AppRoutes.ADDADRESS: (ctx) => const AddAdressScreen(),
          AppRoutes.ADDFEEDBACK: (ctx) => const AddFeedbackScreen(),
          AppRoutes.PRODUCTSCREEN: (ctx) => const ProductScreen(),
          AppRoutes.PAYMENTSCREEN: (ctx) => const PaymentScreen(),
          AppRoutes.SELLDETAILS: (ctx) => const SellDetails(),
          AppRoutes.BOXSCREEN: (ctx) => const BoxScreen(),
          AppRoutes.CATEGORYPRODUCTS: (ctx) => const ProductsFromCategory(),
          AppRoutes.FORGOTPASSWORD: (ctx) => const ForgotPassword(),
          //Producer app routes
          ProducerAppRoutes.PRODUCERHOMETAB: (ctx) => const ProducerHomeTab(),
          ProducerAppRoutes.OPENSELLDETAILS: (ctx) => const OpenSellsDetails(),
          ProducerAppRoutes.PRODUCERSIGNUP: (ctx) => const SignUpCooperativa(),
          ProducerAppRoutes.ADDFEEDBACKCOOP: (ctx) =>
              const CooperativeAddFeedbackScreen(),
          ProducerAppRoutes.UPDATEPRODUCT: (ctx) => const UpdateProductScreen(),
          ProducerAppRoutes.SEARCHPRODUCTS: (ctx) =>
              const SelectProductsToBox(),
        },
      ),
    );
  }
}
