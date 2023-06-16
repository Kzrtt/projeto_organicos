import 'package:flutter/material.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/authenticateUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.wait(
      [
        AuthenticateUser.isAuth(context),
        Future.delayed(Duration(seconds: 2)),
      ],
    ).then((value) {
      print(value);
      if (value[0].isEmpty) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.LOGINSCREEN);
      } else {
        if (value[0][1] == 'user') {
          Navigator.of(context).pushReplacementNamed(AppRoutes.HOMETAB);
        } else if (value[0][1] == 'cooperative') {
          Navigator.of(context)
              .pushReplacementNamed(ProducerAppRoutes.PRODUCERHOMETAB);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/folha.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
