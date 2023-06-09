import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_organicos/utils/cooperativeState.dart';
import 'package:projeto_organicos/utils/validators.dart';

import '../../components/nameAndIcon.dart';
import '../../controller/cooperativeController.dart';
import '../../controller/producerController.dart';
import '../../model/producers.dart';

class ProducerListScreen extends StatefulWidget {
  const ProducerListScreen({Key? key}) : super(key: key);

  @override
  State<ProducerListScreen> createState() => _ProducerListScreenState();
}

class _ProducerListScreenState extends State<ProducerListScreen> {
  bool isLoading = true;
  List<Producers> producers = [];
  final _updateProducerFormKey = GlobalKey<FormState>();
  Validators validators = Validators();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cellController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  var maskFormatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
  var maskFormatterPhone = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {'#': RegExp(r'[0-9]')});
  var maskFormatterBirth = MaskTextInputFormatter(
      mask: '####-##-##', filter: {'#': RegExp(r'[0-9]')});

  Future<void> loadProducers() async {
    CooperativeController controller = CooperativeController();
    List<Producers> temp = await controller.getAllProducers();
    CooperativeState state = CooperativeState();
    state.setProducerList(temp);
    print(state.producerList.length);
    setState(() {
      producers = temp;
    });
    print(producers.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProducers().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        child: Column(
          children: [
            NameAndIcon(
              constraints: constraints,
              icon: Icons.person,
              text: "Seus Produtores",
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
                    height: constraints.maxHeight * .85,
                    child: ListView.builder(
                      itemCount: producers.length,
                      itemBuilder: (context, index) {
                        Producers oldProducer = producers[index];
                        return ListTile(
                            title: Text(oldProducer.producerName),
                            subtitle: Text(oldProducer.producerCpf),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  CooperativeController coopController =
                                      CooperativeController();
                                  setState(() {
                                    producers.removeWhere(
                                      (element) =>
                                          element.producerId ==
                                          oldProducer.producerId,
                                    );
                                  });
                                  coopController
                                      .deleteProducer(oldProducer.producerId);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.update,
                                  color: Color.fromRGBO(108, 168, 129, 0.7),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Atualizar Produtor'),
                                        content: SingleChildScrollView(
                                          child: SizedBox(
                                            height: constraints.maxHeight * .45,
                                            width: constraints.maxWidth,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Preencha somente os campos que deseja alterar',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        18, 18, 18, 0.58),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      constraints.maxHeight *
                                                          .02,
                                                ),
                                                Form(
                                                  key: _updateProducerFormKey,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        validator: validators
                                                            .nameValidator2,
                                                        controller:
                                                            _nameController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Nome',
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          maskFormatterCpf
                                                        ],
                                                        validator: validators
                                                            .cpfValidate2,
                                                        controller:
                                                            _cpfController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'CPF',
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          maskFormatterPhone
                                                        ],
                                                        validator: validators
                                                            .phoneValidator2,
                                                        controller:
                                                            _cellController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Telefone',
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          maskFormatterBirth
                                                        ],
                                                        validator: validators
                                                            .birthDateValidator,
                                                        controller:
                                                            _birthDateController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText:
                                                              'Data de Nascimento',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_updateProducerFormKey
                                                  .currentState!
                                                  .validate()) {
                                                ProducerController controller =
                                                    ProducerController();
                                                Producers newProducer =
                                                    Producers(
                                                  producerId:
                                                      oldProducer.producerId,
                                                  producerName:
                                                      _nameController.text != ""
                                                          ? _nameController.text
                                                          : oldProducer
                                                              .producerName,
                                                  producerCell:
                                                      _cellController.text != ""
                                                          ? _cellController.text
                                                          : oldProducer
                                                              .producerCell,
                                                  producerCpf:
                                                      _cpfController.text != ""
                                                          ? _cpfController.text
                                                          : oldProducer
                                                              .producerCpf,
                                                  birthDate:
                                                      _birthDateController
                                                                  .text !=
                                                              ""
                                                          ? _birthDateController
                                                              .text
                                                          : oldProducer
                                                              .birthDate,
                                                );
                                                controller.updateProducer(
                                                  oldProducer.producerId,
                                                  newProducer,
                                                  oldProducer,
                                                );
                                                int index = producers
                                                    .indexOf(oldProducer);
                                                setState(() {
                                                  producers.replaceRange(
                                                    index,
                                                    index + 1,
                                                    [newProducer],
                                                  );
                                                });
                                                _nameController.text = "";
                                                _birthDateController.text = "";
                                                _cpfController.text = "";
                                                _cellController.text = "";
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text('Salvar'),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    108, 168, 129, 0.7),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _nameController.text = "";
                                              _birthDateController.text = "";
                                              _cpfController.text = "";
                                              _cellController.text = "";
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancelar'),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                            ]));
                      },
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
