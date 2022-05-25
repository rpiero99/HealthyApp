import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class AddSchedaPalestraPage extends StatefulWidget {
  const AddSchedaPalestraPage({Key? key}) : super(key: key);

  @override
  _AddSchedaPalestraPage createState() => _AddSchedaPalestraPage();
}

class _AddSchedaPalestraPage extends State<AddSchedaPalestraPage> {

  String? item = 'Giorno..';
  SchedaPalestra? schedaNew;
  List<Esercizio> esercizi = [];

  TextEditingController nomeController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController dataInizioController = TextEditingController();
  TextEditingController dataFineController = TextEditingController();

  TextEditingController dayEsercizioController = TextEditingController();
  TextEditingController descrizioneEsercizioController = TextEditingController();
  TextEditingController nomeEsercizioController = TextEditingController();
  TextEditingController numRepEsercizioController = TextEditingController();
  TextEditingController numSerieEsercizioController = TextEditingController();
  TextEditingController tempoRestEsercizioController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Scheda Palestra", Constants.controller),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Crea Scheda Palestra",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Constants.text,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      makeInput(
                          label: "Nome..",
                          obscureText: false,
                          controller: nomeController),
                      makeInput(
                          label: "Descrizione..",
                          obscureText: false,
                          controller: descrizioneController),
                      makeInput(
                        label: "Data Inizio..",
                        obscureText: false,
                        controller: dataInizioController,
                        isDate: true,
                        context: context,
                      ),
                      makeInput(
                        label: "Data Fine..",
                        obscureText: false,
                        controller: dataFineController,
                        isDate: true,
                        context: context,
                      ),
                      RoundedButton(
                        text: 'Aggiungi Esercizio',
                        color: Constants.backgroundButtonColor,
                        textColor: Constants.textButtonColor,
                        press: () {
                          clearFieldsEsercizio();
                          openAddEsercizioDialog(context);
                        },
                        key: GlobalKey(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      if (nomeController.text.isNotEmpty &&
                          descrizioneController.text.isNotEmpty &&
                          DateTime.parse(dataFineController.text).isAfter(
                              DateTime.parse(dataInizioController.text))) {
                        schedaNew = Constants.controller.createSchedaPalestra(
                            descrizioneController.text,
                            nomeController.text,
                            DateTime.parse(dataInizioController.text),
                            DateTime.parse(dataFineController.text),
                            Constants.getCurrentIdUser());
                        for (var element in esercizi) {
                          element.idSchedaPalestra = schedaNew?.id;
                          Constants.controller.createEsercizio(
                              schedaNew!,
                              element.descrizione!,
                              element.nome!,
                              element.nSerie!.toInt(),
                              element.nRep!.toInt(),
                              element.tempoRiposo!.toInt(),
                              element.day!.toInt());
                          schedaNew?.updateEsercizio(element);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Scheda creata correttamente.',
                                Constants.successSnackBar));
                        Constants.redirectTo(context, HomePage());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Inserire tutti i dati o controllare che la data di fine sia dopo la data di inizio.',
                                Constants.errorSnackBar));
                      }
                    },
                    color: Constants.backgroundColorLoginButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      "Crea Scheda palestra",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Constants.textButtonColor),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void clearFieldsEsercizio() {
      nomeEsercizioController.clear();
    descrizioneEsercizioController.clear();
    dayEsercizioController.clear();
    numRepEsercizioController.clear();
    numSerieEsercizioController.clear();
    tempoRestEsercizioController.clear();
    item = Constants.daysWeek[0];
  }

  Future openAddEsercizioDialog(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text("Nuovo Esercizio"),
        content: Column(children: [
          TextField(
            controller: nomeEsercizioController,
            decoration: const InputDecoration(hintText: "Nome.."),
          ),
          TextField(
            controller: descrizioneEsercizioController,
            decoration: const InputDecoration(hintText: "Descrizione.."),
          ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter dropDownState){
               return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child:
                    Container(
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
                                item = value as String?;
                              });
                            },
                            value: item,
                          ),
                        ),
                    ),
                );
              },
          ),
          TextField(
            controller: numRepEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Numero ripetizioni.."),
          ),
          TextField(
            controller: numSerieEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Numero serie.."),
          ),
          TextField(
            controller: tempoRestEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Tempo di riposo.. (in secondi)"),
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Crea"),
            onPressed: () {
              if (nomeEsercizioController.text.isNotEmpty &&
                  descrizioneEsercizioController.text.isNotEmpty &&
                  numRepEsercizioController.text.isNotEmpty &&
                  numSerieEsercizioController.text.isNotEmpty &&
                  tempoRestEsercizioController.text.isNotEmpty &&
                  item != Constants.daysWeek[0]) {
                esercizi.add(Esercizio(
                    descrizioneEsercizioController.text,
                    nomeEsercizioController.text,
                    int.parse(numSerieEsercizioController.text),
                    int.parse(numRepEsercizioController.text),
                    int.parse(tempoRestEsercizioController.text),
                    Constants.convertDayWeekInInt(item!),
                    ""));
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar('Esercizio creato correttamente.',
                        Constants.successSnackBar));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar(
                        'Esercizio non creato. Uno o piu campi non validi.',
                        Constants.errorSnackBar));
              }
              clearFieldsEsercizio();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
