import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_organicos/model/cooperative.dart';
import 'package:projeto_organicos/model/cooperativeAdress.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/utils/validators.dart';

class SignUpCooperativa extends StatefulWidget {
  const SignUpCooperativa({Key? key}) : super(key: key);

  @override
  State<SignUpCooperativa> createState() => _SignUpCooperativaState();
}

class _SignUpCooperativaState extends State<SignUpCooperativa> {
  int _currentStep = 0;
  Validators _validators = Validators();
  var maskFormatterCnpj = MaskTextInputFormatter(
      mask: '###.###.###/####-##', filter: {'#': RegExp(r'[0-9]')});
  var maskedFormatterCep = MaskTextInputFormatter(
      mask: '#####-###', filter: {'#': RegExp(r'[0-9]')});
  final _passwordFormKey = GlobalKey<FormState>();
  final _personalInformationFormKey = GlobalKey<FormState>();
  final _adressFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  Widget _textField1(
    double height,
    double width,
    BoxConstraints constraints,
    String text,
    TextEditingController controller,
    String? Function(String?) validator,
  ) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromRGBO(83, 242, 166, 1),
              width: constraints.maxWidth * .01,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(14),
            ),
          ),
          hintText: text,
          hintStyle: TextStyle(
            fontSize: constraints.maxHeight * .02,
          ),
        ),
      ),
    );
  }

  Widget _textField2(
    double height,
    double width,
    BoxConstraints constraints,
    String text,
    TextEditingController controller,
    String? Function(String?) validator,
    bool isCnpj,
  ) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        inputFormatters: [isCnpj ? maskFormatterCnpj : maskedFormatterCep],
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color.fromRGBO(83, 242, 166, 1),
              width: constraints.maxWidth * .01,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(14),
            ),
          ),
          hintText: text,
          hintStyle: TextStyle(
            fontSize: constraints.maxHeight * .02,
          ),
        ),
      ),
    );
  }

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
                                      if (_currentStep == 0 &&
                                          _personalInformationFormKey
                                              .currentState!
                                              .validate()) {
                                        setState(() =>
                                            _currentStep = _currentStep + 1);
                                      } else if (_currentStep == 1 &&
                                          _adressFormKey.currentState!
                                              .validate()) {
                                        setState(() =>
                                            _currentStep = _currentStep + 1);
                                      } else if (_currentStep == 2) {
                                        setState(() =>
                                            _currentStep = _currentStep + 1);
                                      } else if (_currentStep == 3) {
                                        if (_passwordController.text ==
                                                _confirmPasswordController
                                                    .text &&
                                            _passwordFormKey.currentState!
                                                .validate()) {
                                          CooperativeAdress adress =
                                              CooperativeAdress(
                                            complement:
                                                _complementController.text,
                                            street: _streetController.text,
                                            city: _cityController.text,
                                            state: _stateController.text,
                                            zipCode: _zipCodeController.text,
                                          );
                                          Cooperative cooperative = Cooperative(
                                            cooperativeId: "",
                                            cooperativeEmail:
                                                _emailController.text,
                                            password: _passwordController.text,
                                            cooperativeName:
                                                _nameController.text,
                                            cooperativeCnpj:
                                                _cnpjController.text,
                                            cooperativeAdress: adress,
                                            cooperativeProfilePhoto: "",
                                            cooperativePhone:
                                                _phoneController.text,
                                          );
                                          CooperativeController _provider =
                                              CooperativeController();
                                          _provider.createCooperative(
                                            cooperative,
                                            adress,
                                            context,
                                          );
                                          Navigator.of(context).pop();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => const AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: Center(
                                                child: Text(
                                                  "As senhas não cooencidem",
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
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
                    steps: [
                      Step(
                        title: const Text("Informações Pessoais"),
                        content: Form(
                          key: _personalInformationFormKey,
                          child: Column(
                            children: [
                              _textField1(
                                55,
                                330,
                                constraints,
                                "Nome Cooperativa",
                                _nameController,
                                _validators.nameValidator,
                              ),
                              _textField1(
                                55,
                                330,
                                constraints,
                                "Email",
                                _emailController,
                                _validators.emailValidator,
                              ),
                              _textField2(
                                  55,
                                  330,
                                  constraints,
                                  "Cnpj",
                                  _cnpjController,
                                  _validators.cpnjValidator,
                                  true),
                              _textField1(
                                55,
                                330,
                                constraints,
                                "Telefone",
                                _phoneController,
                                _validators.phoneValidator,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: const Text("Endereço"),
                        content: Form(
                          key: _adressFormKey,
                          child: Column(
                            children: [
                              _textField1(
                                55,
                                330,
                                constraints,
                                "Rua",
                                _streetController,
                                _validators.adressValidator,
                              ),
                              _textField1(
                                55,
                                330,
                                constraints,
                                "complemento",
                                _complementController,
                                _validators.adressValidator,
                              ),
                              _textField1(
                                55,
                                330,
                                constraints,
                                "Cidade",
                                _cityController,
                                _validators.adressValidator,
                              ),
                              _textField1(
                                55,
                                330,
                                constraints,
                                "Estado",
                                _stateController,
                                _validators.adressValidator,
                              ),
                              _textField2(
                                55,
                                330,
                                constraints,
                                "Cep",
                                _zipCodeController,
                                _validators.cepValidator,
                                false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Step(
                        title: Text("Foto"),
                        content: Center(),
                      ),
                      Step(
                        title: const Text("Senha"),
                        content: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              _textField1(
                                55,
                                330,
                                constraints,
                                'Senha',
                                _passwordController,
                                _validators.passwordValidator,
                              ),
                              _textField1(
                                55,
                                330,
                                constraints,
                                'Confirmar senha',
                                _confirmPasswordController,
                                _validators.passwordValidator,
                              ),
                            ],
                          ),
                        ),
                      ),
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
