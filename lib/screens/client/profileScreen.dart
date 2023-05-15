import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/profileScreenButton.dart';
import 'package:projeto_organicos/components/settingsText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../components/nameAndIcon.dart';
import '../../utils/appRoutes.dart';

class ProfileScreen extends StatefulWidget {
  final void Function(int newValue) callbackFunction;
  const ProfileScreen({
    Key? key,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color: const Color.fromRGBO(238, 238, 238, 1),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NameAndIcon(
                    constraints: constraints,
                    icon: Icons.person,
                    text: "Perfil",
                  ),
                  Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * .029),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * .05,
                        ),
                        child: InkWell(
                          child: Icon(
                            Icons.settings_outlined,
                            size: constraints.maxHeight * .035,
                            color: const Color.fromRGBO(0, 0, 0, .5),
                          ),
                          onTap: () {
                            SideSheet.right(
                              context: context,
                              width: MediaQuery.of(context).size.width * .7,
                              body: Container(
                                width: 100,
                                height: 100,
                                color: const Color.fromRGBO(178, 214, 192, 1),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: constraints.maxHeight * .03),
                                    Text(
                                      "Configurações",
                                      style: TextStyle(
                                        color: const Color.fromRGBO(
                                            18, 18, 18, .58),
                                        fontSize: constraints.maxHeight * .025,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                        height: constraints.maxHeight * .05),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SettingsText(
                                          constraints: constraints,
                                          text: "Idioma",
                                        ),
                                        SettingsText(
                                          constraints: constraints,
                                          text: "Modo Escuro",
                                        ),
                                        SettingsText(
                                          constraints: constraints,
                                          text: "Limpar histórico de busca",
                                        ),
                                        SettingsText(
                                          constraints: constraints,
                                          text: "Termos de uso",
                                        ),
                                        SettingsText(
                                          constraints: constraints,
                                          text: "Política de Privacidade",
                                        ),
                                        SettingsText(
                                          constraints: constraints,
                                          text: "Desativar Conta",
                                          isDesativarConta: true,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: constraints.maxHeight * .5),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefs.remove("token");
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          AppRoutes.OPENINGSCREEN,
                                        );
                                      },
                                      child: const Text(
                                        "Loggout",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: constraints.maxHeight * .01),
              SizedBox(
                height: constraints.maxHeight * .8,
                width: constraints.maxWidth,
                child: ListView(
                  children: [
                    ProfileScreenButton(
                      constraints: constraints,
                      text: "Endereços",
                      subtext: "Endereços para as entregas",
                      icon: Icons.map,
                      buttonFunction: () => widget.callbackFunction(4),
                    ),
                    ProfileScreenButton(
                      constraints: constraints,
                      text: "Meus Pedidos",
                      subtext: "Veja seus pedidos finalizados e em andamento",
                      icon: Icons.receipt,
                      buttonFunction: () => widget.callbackFunction(5),
                    ),
                    ProfileScreenButton(
                      constraints: constraints,
                      text: "Perfil",
                      subtext: "Alterar ou visualizar os dados do seu perfil",
                      icon: Icons.person,
                      buttonFunction: () => widget.callbackFunction(7),
                    ),
                    ProfileScreenButton(
                      constraints: constraints,
                      text: "Chats",
                      subtext:
                          "Enviar mensagens para os produtores do nosso app",
                      icon: Icons.chat_bubble,
                      buttonFunction: () => widget.callbackFunction(7),
                    ),
                    ProfileScreenButton(
                      constraints: constraints,
                      text: "Feedbacks",
                      subtext:
                          "Envie suas recomendações ou reclamações para a nossa equipe",
                      icon: Icons.feedback,
                      buttonFunction: () => widget.callbackFunction(8),
                    ),
                    ProfileScreenButton(
                      constraints: constraints,
                      text: "Seja Assinante",
                      subtext:
                          "Seja nosso assinante e tenha descontos e beneficios em nosso App",
                      icon: Icons.favorite,
                      buttonFunction: () => widget.callbackFunction(9),
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
