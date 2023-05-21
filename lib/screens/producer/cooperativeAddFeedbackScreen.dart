import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/validators.dart';

class CooperativeAddFeedbackScreen extends StatefulWidget {
  const CooperativeAddFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<CooperativeAddFeedbackScreen> createState() =>
      _CooperativeAddFeedbackScreenState();
}

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
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white, width: constraints.maxWidth * .03),
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

class _CooperativeAddFeedbackScreenState
    extends State<CooperativeAddFeedbackScreen> {
  final _feedbackFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  Validators validators = Validators();

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
            color: Color.fromRGBO(108, 168, 129, 0.7),
          ),
        ),
        actions: [
          Row(
            children: const [
              Icon(Icons.feedback, color: Color.fromRGBO(108, 168, 129, 0.7)),
              SizedBox(width: 10),
              Text(
                "Envio de Feedback",
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
          return Center(
            child: Form(
              key: _feedbackFormKey,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * .08),
                  _textField1(
                    55,
                    330,
                    constraints,
                    "Assunto",
                    _titleController,
                    validators.nameValidator,
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  _textField1(
                    300,
                    330,
                    constraints,
                    "Seu feedback",
                    _messageController,
                    validators.nameValidator,
                  ),
                  SizedBox(height: constraints.maxHeight * .05),
                  InkWell(
                    onTap: () async {
                      if (_feedbackFormKey.currentState!.validate()) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? cooperativeId =
                            prefs.getString("cooperativeId");
                        CooperativeController controller =
                            CooperativeController();
                        controller.createFeedback(
                          _messageController.text,
                          _titleController.text,
                          cooperativeId!,
                        );
                        ClientFeedback f = ClientFeedback(
                          id: "",
                          title: _titleController.text,
                          response: "Aguardando Resposta",
                          message: _messageController.text,
                          data: DateTime.now().toString().substring(0, 10),
                        );
                        Navigator.pop(context, f);
                      }
                    },
                    child: CommonButton(
                      constraints: constraints,
                      text: "Enviar Feedback",
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
