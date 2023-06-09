import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../components/profileScreenButton.dart';
import '../../components/settingsText.dart';

class ProducerProfileScreen extends StatefulWidget {
  Cooperative cooperative;
  final void Function(int newValue) callbackFunction;
  ProducerProfileScreen({
    Key? key,
    required this.cooperative,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<ProducerProfileScreen> createState() => _ProducerProfileScreenState();
}

class _ProducerProfileScreenState extends State<ProducerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.1,
            width: constraints.maxWidth,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NameAndIcon(
                      constraints: constraints,
                      icon: Icons.person,
                      text: widget.cooperative.cooperativeName,
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
                                          fontSize:
                                              constraints.maxHeight * .025,
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
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Deseja mesmo deletar sua conta?'),
                                                    content: Text(
                                                        'Para reativar a conta, você deverá contatar nossa equipe e aguardar até 30 dias.'),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('Cancelar'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          primary: Colors.grey,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child:
                                                            Text('Confirmar'),
                                                        onPressed: () {
                                                          // Lógica para confirmar a exclusão da conta
                                                          CooperativeController
                                                              controller =
                                                              CooperativeController();
                                                          controller
                                                              .deleteAccount();
                                                          Navigator.of(context)
                                                              .pushReplacementNamed(
                                                                  AppRoutes
                                                                      .OPENINGSCREEN);

                                                          // TODO: Implemente a lógica de exclusão da conta aqui
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          primary: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: SettingsText(
                                              constraints: constraints,
                                              text: "Desativar Conta",
                                              isDesativarConta: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: constraints.maxHeight * .5),
                                      InkWell(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.remove('cooperativeId');
                                          prefs.remove('cooperativeToken');
                                          prefs.remove('loggedCooperative');
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
                ProfileScreenButton(
                  constraints: constraints,
                  text: "Produtores",
                  subtext: "Adicione novos produtores",
                  icon: Icons.people,
                  buttonFunction: () => widget.callbackFunction(7),
                ),
                ProfileScreenButton(
                  constraints: constraints,
                  text: "Lista de Produtores",
                  subtext:
                      "Altere os dados e visualize os dados dos seus Produtores",
                  icon: Icons.people,
                  buttonFunction: () => widget.callbackFunction(8),
                ),
                ProfileScreenButton(
                  constraints: constraints,
                  text: "Produtos",
                  subtext: "Adicione novos produtos",
                  icon: Icons.favorite,
                  buttonFunction: () => widget.callbackFunction(6),
                ),
                ProfileScreenButton(
                  constraints: constraints,
                  text: "Perfil",
                  subtext: "Altere ou visualize seus dados",
                  icon: Icons.person,
                  buttonFunction: () => widget.callbackFunction(5),
                ),
                ProfileScreenButton(
                  constraints: constraints,
                  text: "Chats",
                  subtext: "Suas conversas",
                  icon: Icons.chat_bubble_outline_rounded,
                  buttonFunction: () => widget.callbackFunction(10),
                ),
                ProfileScreenButton(
                  constraints: constraints,
                  text: "Feedbacks",
                  subtext: "Envie suas recomendações para nossa equipe",
                  icon: Icons.feedback,
                  buttonFunction: () => widget.callbackFunction(9),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
