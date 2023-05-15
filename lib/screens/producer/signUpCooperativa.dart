import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SignUpCooperativa extends StatefulWidget {
  const SignUpCooperativa({Key? key}) : super(key: key);

  @override
  State<SignUpCooperativa> createState() => _SignUpCooperativaState();
}

class _SignUpCooperativaState extends State<SignUpCooperativa> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(83, 242, 166, 0.69),
          ),
        ),
        actions: [
          Row(
            children: const [
              Icon(Icons.people, color: Color.fromRGBO(83, 242, 166, 0.69)),
              SizedBox(width: 10),
              Text(
                "Cadastro Cooperativa",
                style: TextStyle(
                  color: Color.fromRGBO(18, 18, 18, 0.58),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: constraints.maxHeight * .03),
              Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth * .05),
                child: Container(
                  height: constraints.maxHeight * .9,
                  width: constraints.maxWidth * .9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepTapped: (int index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    controlsBuilder: (context, details) {
                      return Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * .03),
                          SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(
                                            83, 242, 166, 0.69),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _currentStep = _currentStep + 1;
                                      });
                                    },
                                    child: Text(
                                      _currentStep <= 2
                                          ? "Continuar"
                                          : "Finalizar",
                                    ),
                                  ),
                                ),
                                SizedBox(width: constraints.maxWidth * .05),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.grey,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_currentStep != 0) {
                                          _currentStep = _currentStep - 1;
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "Voltar",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    steps: const [
                      Step(title: Text("Primeiro Passo"), content: Center()),
                      Step(title: Text("Segundo Passo"), content: Center()),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
