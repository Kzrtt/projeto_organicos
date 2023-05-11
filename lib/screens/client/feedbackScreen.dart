import 'package:flutter/material.dart';
import 'package:projeto_organicos/components/commonButton.dart';
import 'package:projeto_organicos/components/nameAndIcon.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedItem = "";
  final List<String> _items = ["item 1", "item 2", "item 3"];
  final TextEditingController _feedbackController = TextEditingController();

  Widget _textField1(double height, double width, BoxConstraints constraints,
      String text, TextEditingController controller) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1.3,
            child: Column(
              children: [
                NameAndIcon(
                  constraints: constraints,
                  icon: Icons.feedback,
                  text: "Feedbacks",
                ),
                SizedBox(height: constraints.maxHeight * .03),
                Padding(
                  padding: EdgeInsets.all(constraints.maxHeight * .01),
                  child: const Card(
                    child: ListTile(
                      title: Text("Feedback 1"),
                      subtitle: Text("Status: Resolvido"),
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(83, 242, 166, 0.69),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(constraints.maxHeight * .01),
                  child: const Card(
                    child: ListTile(
                      title: Text("Feedback 2"),
                      subtitle: Text("Status: Em aberto"),
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(83, 242, 166, 0.69),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: const Color.fromRGBO(83, 242, 166, 0.69),
                  thickness: constraints.maxWidth * .003,
                  indent: constraints.maxWidth * .1,
                  endIndent: constraints.maxWidth * .1,
                  height: constraints.maxHeight * .1,
                ),
                SizedBox(
                  width: constraints.maxWidth * .9,
                  child: DropdownButtonFormField<String>(
                    value: _selectedItem.isNotEmpty ? _selectedItem : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: constraints.maxWidth * .03),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    hint: const Text("Escolher endereço padrão"),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value.toString();
                      });
                    },
                    items: _items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: constraints.maxHeight * .03),
                _textField1(
                  250,
                  320,
                  constraints,
                  "Feedback",
                  _feedbackController,
                ),
                SizedBox(height: constraints.maxHeight * .045),
                CommonButton(constraints: constraints, text: "Enviar Feedback"),
              ],
            ),
          ),
        );
      },
    );
  }
}
