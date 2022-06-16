import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/PianoAlimentare.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:intl/intl.dart';

import '../Model/CategoriaPasto.dart';
import '../Model/Pasto.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/RoundedButton.dart';
import 'Widgets/TopAppBar.dart';

class GetPastiOfPianoAlimentarePage extends StatefulWidget {
  PianoAlimentare? pianoAlimentareToEdit;
  Pasto? pastoToView;

  GetPastiOfPianoAlimentarePage(
      {Key? key, required PianoAlimentare? pianoAlimentare})
      : super(key: key) {
    pianoAlimentareToEdit = pianoAlimentare;
  }

  @override
  _GetPastiOfPianoAlimentarePage createState() =>
      _GetPastiOfPianoAlimentarePage();

}

class _GetPastiOfPianoAlimentarePage
    extends State<GetPastiOfPianoAlimentarePage> {
  List<Pasto?> allPasti = [];
  String searchString = "";
  String? dayItem = 'Giorno..';
  String categoriaItem = Constants.categoriePasto[0];
  TextEditingController calorieController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController descrizionePastoController = TextEditingController();
  TextEditingController nomePastoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController oraPastoController = TextEditingController();
  TextEditingController dayPastoController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    getPasti();
  }

  Future<void> getPasti() async{
    allPasti = await Constants.controller.getPastiOfPianoAlimentare(widget.pianoAlimentareToEdit!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(
          context,
          "Pasti di: " + widget.pianoAlimentareToEdit!.nome!,
          Constants.controller),
      body: SingleChildScrollView(
        child: SizedBox(
            child: Column(children: <Widget>[
          TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "cerca..",
                hintStyle: const TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!)),
              ),
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              }),
          const Divider(),
          RoundedButton(
            text: 'Aggiungi Pasto',
            color: Constants.backgroundButtonColor,
            textColor: Constants.textButtonColor,
            press: () async {
              clearFieldsPasto();
              return openAddPastoDialog(context);
            },
            key: GlobalKey(),
          ),
          const Divider(),
          Container(
            child: showCards(),
          )
        ])),
      ),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: Constants.controller.getPastiOfPianoAlimentare(widget.pianoAlimentareToEdit!),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Pasto>).toList();
          if(d.isNotEmpty && d != null) {
            return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: d.length,
            itemBuilder: (context, index) {
              if (searchString != "") {
                return _buildItem(d[index].nome!.contains(searchString) ||
                        d[index].descrizione!.contains(searchString)
                    ? d[index]
                    : null);
              }
              return _buildItem(d[index]);
            },
          );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        return const Divider();
      },
    );
  }

  Widget _buildItem(Pasto? obj) {
    if (obj != null) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blueGrey,
        elevation: 10,
        child: SizedBox(
            width: 200,
            child: GestureDetector(
              onTap: () => {
                widget.pastoToView = obj,
                openViewPasto(context, false),
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading:
                        const Icon(Icons.sports_gymnastics_outlined, size: 100),
                    title: Text(obj.nome!,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(obj.descrizione!,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  ButtonTheme(
                    child: ButtonBar(
                      children: <Widget>[
                        TextButton(
                            child: const Text('Modifica',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              widget.pastoToView = obj;
                              openViewPasto(context, true);
                            }),
                        TextButton(
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              Constants.controller
                                  .removePastoPianoAlimentare(widget.pianoAlimentareToEdit!, obj);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    }
    return const Divider();
  }

  Future openAddPastoDialog(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text("Nuovo Pasto"),
        content: Column(children: [
          TextField(
            controller: nomePastoController,
            decoration: const InputDecoration(hintText: "Nome.."),
          ),
          TextField(
            controller: descrizionePastoController,
            decoration: const InputDecoration(hintText: "Descrizione.."),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter dropDownState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  height: 40,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(style: BorderStyle.solid, width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: Constants.categoriePasto
                          .map((String item) => DropdownMenuItem<String>(
                              child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) {
                        dropDownState(() {
                          categoriaItem = (value as String?)!;
                          categoriaController.text = categoriaItem;
                        });
                      },
                      value: categoriaItem,
                    ),
                  ),
                ),
              );
            },
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter dropDownState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  height: 40,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(style: BorderStyle.solid, width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: Constants.daysWeek
                          .map((String item) => DropdownMenuItem<String>(
                              child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) {
                        dropDownState(() {
                          dayItem = value as String?;
                          dayPastoController.text = dayItem!;
                        });
                      },
                      value: dayItem,
                    ),
                  ),
                ),
              );
            },
          ),
          TextField(
            controller: quantitaController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Quantità.."),
          ),
          TextField(
            controller: calorieController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Calorie.."),
          ),
          TextField(
            controller: typeController,
            decoration: const InputDecoration(hintText: "Tipo pasto.."),
          ),
          TextField(
            controller: oraPastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Ora di consumazione del pasto..',
            ),
            onTap: () async {
              TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                initialEntryMode: TimePickerEntryMode.dial,
              );
              if (timeOfDay != null) {
                setState(() {
                  oraPastoController.text = _getStringFromTimeOfDay(timeOfDay);
                });
              }
            },
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Crea"),
            onPressed: () {
              if (nomePastoController.text.isNotEmpty &&
                  descrizionePastoController.text.isNotEmpty &&
                  quantitaController.text.isNotEmpty &&
                  oraPastoController.text.isNotEmpty &&
                  Constants.convertDayWeekInInt(dayPastoController.text) != -1 &&
                  dayItem != Constants.daysWeek[0] &&
                  categoriaItem != Constants.categoriePasto[0] &&
                  calorieController.text.isNotEmpty &&
                  typeController.text.isNotEmpty) {
                setState(() {
                  Constants.controller.createPastoPianoAlimentare(
                      widget.pianoAlimentareToEdit!,
                      Constants.getCategoriaFromString(categoriaController.text),
                      int.parse(calorieController.text),
                      descrizionePastoController.text,
                      nomePastoController.text,
                      oraPastoController.text,
                      Constants.convertDayWeekInInt(dayPastoController.text),
                      int.parse(quantitaController.text),
                      typeController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.createSnackBar(
                          'Pasto creato correttamente.',
                          Constants.successSnackBar));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar(
                        'Pasto non creato. Uno o piu campi non validi.',
                        Constants.errorSnackBar));
              }
              clearFieldsPasto();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void clearFieldsPasto() {
    calorieController.clear();
    categoriaController.clear();
    descrizionePastoController.clear();
    nomePastoController.clear();
    quantitaController.clear();
    typeController.clear();
    oraPastoController.clear();
    dayPastoController.clear();
    categoriaItem = Constants.categoriePasto[0];
    dayItem = "Giorno..";
  }

  void setFieldsPasto() {
    nomePastoController.text = widget.pastoToView!.nome!;
    descrizionePastoController.text = widget.pastoToView!.descrizione!;
    dayPastoController.text =
        Constants.convertDayWeekInString(widget.pastoToView!.giornoPasto!.toInt());
    quantitaController.text = widget.pastoToView!.quantita!.toString();
    typeController.text =
        widget.pastoToView!.type!;
    calorieController.text =
        widget.pastoToView!.calorie!.toString();
    oraPastoController.text =
        widget.pastoToView!.oraPasto!.toString();
    categoriaController.text =
        widget.pastoToView!.categoria!.name;
  }

  Future openViewPasto(context, isEdit) {
    setFieldsPasto();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(widget.pastoToView!.nome!),
        content: Column(children: [
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: nomePastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: descrizionePastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Descrizione',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: dayPastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Giorno',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: calorieController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Calorie',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: quantitaController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Quantità',
            ),
          ),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter dropDownState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 40,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(style: BorderStyle.solid, width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: Constants.categoriePasto
                        .map((String item) => DropdownMenuItem<String>(
                        child: Text(item), value: item))
                        .toList(),
                    onChanged: (value) {
                      if(isEdit){
                        dropDownState(() {
                          categoriaItem = (value as String?)!;
                          categoriaController.text = categoriaItem;
                        });
                      }
                    },
                    value: categoriaController.text,
                  ),
                ),
              ),
            );
          },
        ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: typeController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Tipo pasto',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: oraPastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Ora di consumazione',
            ),
            onTap: () async {
              if (isEdit) {
                TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  initialEntryMode: TimePickerEntryMode.dial,
                );
                if (timeOfDay != null && timeOfDay != selectedTime) {
                  setState(() {
                    oraPastoController.text = _getStringFromTimeOfDay(timeOfDay);
                  });
                }
              }
            },
          ),
        ]),
        actions: [
          isEdit
              ? TextButton(
                  child: const Text("Modifica"),
                  onPressed: () {
                    if (nomePastoController.text.isNotEmpty &&
                    descrizionePastoController.text.isNotEmpty &&
                    quantitaController.text.isNotEmpty &&
                    oraPastoController.text.isNotEmpty &&
                    Constants.convertDayWeekInInt(dayPastoController.text) != -1 &&
                    categoriaItem != Constants.categoriePasto[0] &&
                    calorieController.text.isNotEmpty &&
                    typeController.text.isNotEmpty) {
                      setState(() {
                        widget.pastoToView!.nome =
                            nomePastoController.text;
                        widget.pastoToView!.descrizione =
                            descrizionePastoController.text;
                        widget.pastoToView!.quantita =
                            int.parse(quantitaController.text);
                        widget.pastoToView!.calorie =
                            int.parse(calorieController.text);
                        widget.pastoToView!.giornoPasto =
                            Constants.convertDayWeekInInt(
                                dayPastoController.text);
                        widget.pastoToView!.oraPasto = oraPastoController.text;
                        widget.pastoToView!.type = typeController.text;
                        widget.pastoToView!.categoria = Constants.getCategoriaFromString(categoriaController.text);
                        Constants.controller.updatePasto(widget.pastoToView!);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Pasto modificato correttamente.',
                                Constants.successSnackBar));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar(
                              'Pasto non modificato. Uno o piu campi non validi.',
                              Constants.errorSnackBar));
                    }
                    clearFieldsPasto();
                    Navigator.pop(context);
                  },
                )
              : TextButton(
                  child: const Text("Chiudi"),
                  onPressed: () {
                    clearFieldsPasto();
                    Navigator.pop(context);
                  },
                )
        ],
      ),
    );
  }

  String _getStringFromTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.Hm();
    return format.format(dt);
  }
}
