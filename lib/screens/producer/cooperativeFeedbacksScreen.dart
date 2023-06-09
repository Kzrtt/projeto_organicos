import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';
import 'package:projeto_organicos/model/feedback.dart';
import 'package:projeto_organicos/utils/appRoutes.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/nameAndIcon.dart';

class CooperativeFeedbacksScreen extends StatefulWidget {
  const CooperativeFeedbacksScreen({Key? key}) : super(key: key);

  @override
  State<CooperativeFeedbacksScreen> createState() =>
      _CooperativeFeedbacksScreenState();
}

class _CooperativeFeedbacksScreenState
    extends State<CooperativeFeedbacksScreen> {
  bool isLoading = true;
  String _selectedItem = "";
  final List<String> _items = ["item 1", "item 2", "item 3"];
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  List<ClientFeedback> _feedbacks = [];
  List<bool> isExpandedList = List.generate(5, (index) => false);

  Future<void> loadFeedbacks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CooperativeController cooperativeController = CooperativeController();
    String? cooperativeId = prefs.getString("cooperativeId");
    List<ClientFeedback> temp =
        await cooperativeController.getAllFeedbacks(cooperativeId!);
    CooperativeState cooperativeState = CooperativeState();
    cooperativeState.setFeedbackList(temp);
    print(cooperativeState.feedbacks.length);
    setState(() {
      _feedbacks = temp;
    });
    print(_feedbacks.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFeedbacks().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

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
        return SizedBox(
          height: constraints.maxHeight,
          child: Stack(
            children: [
              Column(
                children: [
                  NameAndIcon(
                    constraints: constraints,
                    icon: Icons.feedback,
                    text: "Feedbacks",
                  ),
                  SizedBox(height: constraints.maxHeight * .03),
                  isLoading
                      ? Column(
                          children: [
                            SizedBox(height: constraints.maxHeight * .3),
                            Center(
                              child: CircularProgressIndicator(
                                color: const Color.fromRGBO(113, 227, 154, 1),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: constraints.maxHeight * .8,
                          child: ListView.builder(
                            itemCount: _feedbacks.length,
                            itemBuilder: (context, index) {
                              var item = _feedbacks[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        constraints.maxHeight * .015),
                                    child: Card(
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.favorite,
                                          color: Color.fromRGBO(
                                              108, 168, 129, 0.7),
                                        ),
                                        title: Text(item.title),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isExpandedList[index] =
                                                  !isExpandedList[index];
                                            });
                                          },
                                          child: Icon(
                                            isExpandedList[index]
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                          ),
                                        ),
                                        subtitle: isExpandedList[index]
                                            ? SizedBox(
                                                height:
                                                    constraints.maxHeight * .25,
                                                width: constraints.maxWidth,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: constraints
                                                              .maxHeight *
                                                          .02,
                                                    ),
                                                    Text(
                                                      "pergunta: ${item.message}",
                                                    ),
                                                    SizedBox(
                                                      height: constraints
                                                              .maxHeight *
                                                          .02,
                                                    ),
                                                    Text(
                                                      "resposta: ${item.response}",
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        constraints.maxHeight *
                                                            .035,
                                                    width: constraints.maxWidth,
                                                    child: Text(
                                                      "data: ${item.data.substring(0, 10)}",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                  SizedBox(height: constraints.maxHeight * .045),
                ],
              ),
              Positioned(
                bottom: 15.0,
                right: 15.0,
                child: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(83, 242, 166, 0.69),
                  onPressed: () async {
                    var result = await Navigator.of(context)
                            .pushNamed(ProducerAppRoutes.ADDFEEDBACKCOOP)
                        as ClientFeedback;
                    setState(() {
                      _feedbacks.add(result);
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
