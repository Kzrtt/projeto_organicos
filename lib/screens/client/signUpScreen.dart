import 'package:flutter/material.dart';
import 'package:projeto_organicos/model/user.dart';
import 'package:projeto_organicos/providers/userProvider.dart';
import 'package:projeto_organicos/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum UserType { user, seller }

enum DietType { vegan, carnivore, vegetarian }

class _SignUpScreenState extends State<SignUpScreen> {
  int _step = 0;
  UserType _character = UserType.user;
  DietType _type = DietType.vegan;
  Validators validators = Validators();
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController cellphoneController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();

  String? placeholder(String? value) {
    if (value!.length < 3) {
      return "por favor preencha corretamente o campo";
    }
    return null;
  }

  Widget _dietOption(String text, DietType type) {
    return ListTile(
      title: Text(text),
      leading: Radio<DietType>(
        activeColor: const Color.fromRGBO(83, 242, 166, 0.47),
        value: type,
        groupValue: _type,
        onChanged: (DietType? value) {
          setState(() {
            _type = value!;
          });
        },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: const [
          Row(
            children: [
              Icon(Icons.people, color: Color.fromRGBO(83, 242, 166, 0.69)),
              SizedBox(width: 10),
              Text(
                "Cadastro",
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
                    currentStep: _step,
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
                                      if (_step == 0 &&
                                          _personalInfoFormKey.currentState!
                                              .validate()) {
                                        setState(() => _step = _step + 1);
                                      } else if (_step != 3 && _step != 0) {
                                        setState(() => _step = _step + 1);
                                      } else if (_step == 3 &&
                                          _passwordFormKey.currentState!
                                              .validate()) {
                                        if (passwordController.text ==
                                            confirmPasswordController.text) {
                                          User userData = User(
                                            userName: nameController.text,
                                            userCpf: cpfController.text,
                                            userEmail: emailController.text,
                                            userCell: cellphoneController.text,
                                            password: passwordController.text,
                                            isSubscriber: false,
                                            isNutritious: false,
                                          );
                                          UserProvider provider =
                                              UserProvider();
                                          provider.createClient(
                                              userData, _type, context);
                                          Navigator.of(context).pop();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => const AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: Center(
                                                child: Text(
                                                    "As senhas não cooencidem"),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      _step <= 2 ? "Continuar" : "Finalizar",
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
                                        if (_step != 0) {
                                          _step = _step - 1;
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
                    onStepTapped: (int index) {
                      setState(() {
                        _step = index;
                      });
                    },
                    steps: <Step>[
                      Step(
                        title: const Text('Informações Pessoais'),
                        content: Form(
                          key: _personalInfoFormKey,
                          child: Column(
                            children: [
                              _textField2(
                                55,
                                330,
                                constraints,
                                'Nome completo',
                                nameController,
                                validators.nameValidator,
                              ),
                              SizedBox(
                                height: constraints.maxHeight * .01,
                              ),
                              _textField2(
                                55,
                                330,
                                constraints,
                                'E-mail',
                                emailController,
                                validators.emailValidator,
                              ),
                              SizedBox(
                                height: constraints.maxHeight * .01,
                              ),
                              _textField2(
                                55,
                                330,
                                constraints,
                                'Cpf',
                                cpfController,
                                validators.cpfValidate,
                              ),
                              SizedBox(height: constraints.maxHeight * .01),
                              _textField2(
                                55,
                                330,
                                constraints,
                                'Telefone',
                                cellphoneController,
                                validators.phoneValidator,
                              ),
                              SizedBox(height: constraints.maxHeight * .01),
                              _textField2(
                                55,
                                330,
                                constraints,
                                'Data de Nascimento',
                                birthDayController,
                                placeholder,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: const Text('Criar conta como Vendedor?'),
                        content: Column(
                          children: [
                            Column(
                              children: [
                                ListTile(
                                  title: const Text('Não'),
                                  leading: Radio<UserType>(
                                    activeColor: const Color.fromRGBO(
                                        83, 242, 166, 0.47),
                                    value: UserType.user,
                                    groupValue: _character,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _character = value!;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Sim'),
                                  leading: Radio<UserType>(
                                    activeColor: const Color.fromRGBO(
                                        83, 242, 166, 0.47),
                                    value: UserType.seller,
                                    groupValue: _character,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _character = value!;
                                      });
                                    },
                                  ),
                                ),
                                _character == UserType.seller
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height:
                                                  constraints.maxHeight * .04),
                                          _textField2(
                                            55,
                                            330,
                                            constraints,
                                            'Endereço',
                                            nameController,
                                            placeholder,
                                          ),
                                          _textField2(
                                            55,
                                            330,
                                            constraints,
                                            'Cnpj',
                                            nameController,
                                            placeholder,
                                          ),
                                        ],
                                      )
                                    : const Center()
                              ],
                            )
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('Dieta'),
                        content: Column(
                          children: [
                            _dietOption("Vegano", DietType.vegan),
                            _dietOption("Carnivoro", DietType.carnivore),
                            _dietOption("Vegetariano", DietType.vegetarian),
                          ],
                        ),
                      ),
                      Step(
                        title: const Text('Senha'),
                        content: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              _textField2(
                                55,
                                330,
                                constraints,
                                'Senha',
                                passwordController,
                                validators.passwordValidator,
                              ),
                              _textField2(
                                55,
                                330,
                                constraints,
                                'Confirmar senha',
                                confirmPasswordController,
                                validators.passwordValidator,
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
