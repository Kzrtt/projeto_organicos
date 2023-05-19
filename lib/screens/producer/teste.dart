import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_organicos/controller/cooperativeController.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CooperativeController controller = CooperativeController();
    controller.getAllProducers().then((value) => print(value.length));
  }

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
