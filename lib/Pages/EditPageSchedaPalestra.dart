import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/GetEserciziPage.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class EditSchedaPalestraPage extends StatefulWidget {
  TextEditingController nomeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController dataInizioController = TextEditingController();
  TextEditingController dataFineController = TextEditingController();
  EditSchedaPalestraPage({Key? key, required String id, required String nome, required String descrizione, required DateTime dataInizio,
    required DateTime dataFine}) : super(key: key){
    idController.text = id;
    nomeController.text = nome;
    descrizioneController.text = descrizione;
    dataInizioController.text = dataInizio.toString();
    dataFineController.text = dataFine.toString();
  }

  @override
  _EditSchedaPalestraPage createState() => _EditSchedaPalestraPage();
}

class _EditSchedaPalestraPage extends State<EditSchedaPalestraPage> {
  //
  // String? item = 'Giorno..';
  // SchedaPalestra? schedaNew;
  // List<Esercizio> esercizi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Scheda Palestra", Constants.controller),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Column(
                  children: const [
                    Text(
                      "Modifica Scheda Palestra",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Constants.text,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      makeInput(
                          label: "Nome..",
                          obscureText: false,
                          controller: widget.nomeController),
                      makeInput(
                          label: "Descrizione..",
                          obscureText: false,
                          controller: widget.descrizioneController),
                      makeInput(
                        label: "Data Inizio..",
                        obscureText: false,
                        controller: widget.dataInizioController,
                        isDate: true,
                        context: context,
                      ),
                      makeInput(
                        label: "Data Fine..",
                        obscureText: false,
                        controller: widget.dataFineController,
                        isDate: true,
                        context: context,
                      ),
                      RoundedButton(
                        text: 'Modifica Esercizio',
                        color: Constants.backgroundButtonColor,
                        textColor: Constants.textButtonColor,
                        press: () async {
                          SchedaPalestra schedaToEdit = await Constants.controller.getSchedaPalestraById(widget.idController.text);
                          Constants.redirectTo(context, GetEserciziPage(scheda:  schedaToEdit));
                          //clearFieldsEsercizio();
                          //openAddEsercizioDialog(context);
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
                      if (widget.nomeController.text.isNotEmpty &&
                          widget.descrizioneController.text.isNotEmpty &&
                          DateTime.parse(widget.dataFineController.text).isAfter(
                              DateTime.parse(widget.dataInizioController.text))) {
                        var scheda = await Constants.controller.getSchedaPalestraById(widget.idController.text);
                        scheda.nome = widget.nomeController.text;
                        scheda.descrizione = widget.descrizioneController.text;
                        scheda.dataInizio = DateTime.parse(widget.dataInizioController.text);
                        scheda.dataFine = DateTime.parse(widget.dataFineController.text);
                        Constants.controller.updateSchedaPalestra(scheda);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Scheda modificata correttamente.',
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
                      "Modifica Scheda palestra",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Constants.textButtonColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void clearFieldsEsercizio() {
  //   nomeEsercizioController.clear();
  //   descrizioneEsercizioController.clear();
  //   dayEsercizioController.clear();
  //   numRepEsercizioController.clear();
  //   numSerieEsercizioController.clear();
  //   tempoRestEsercizioController.clear();
  //   item = Constants.daysWeek[0];
  // }

  // Future openAddEsercizioDialog(context) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       scrollable: true,
  //       title: const Text("Nuovo Esercizio"),
  //       content: Column(children: [
  //         TextField(
  //           controller: nomeEsercizioController,
  //           decoration: const InputDecoration(hintText: "Nome.."),
  //         ),
  //         TextField(
  //           controller: descrizioneEsercizioController,
  //           decoration: const InputDecoration(hintText: "Descrizione.."),
  //         ),
  //         StatefulBuilder(
  //           builder: (BuildContext context, StateSetter dropDownState){
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 20),
  //               child:
  //               Container(
  //                 height: 40,
  //                 width: 270,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5.0),
  //                   border: Border.all(style: BorderStyle.solid, width: 0.80),
  //                 ),
  //                 child: DropdownButtonHideUnderline(
  //                   child: DropdownButton(
  //                     items: Constants.daysWeek
  //                         .map((String item) => DropdownMenuItem<String>(
  //                         child: Text(item), value: item))
  //                         .toList(),
  //                     onChanged: (value) {
  //                       dropDownState(() {
  //                         item = value as String?;
  //                       });
  //                     },
  //                     value: item,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //         TextField(
  //           controller: numRepEsercizioController,
  //           keyboardType: TextInputType.number,
  //           inputFormatters: <TextInputFormatter>[
  //             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //           ],
  //           decoration: const InputDecoration(hintText: "Numero ripetizioni.."),
  //         ),
  //         TextField(
  //           controller: numSerieEsercizioController,
  //           keyboardType: TextInputType.number,
  //           inputFormatters: <TextInputFormatter>[
  //             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //           ],
  //           decoration: const InputDecoration(hintText: "Numero serie.."),
  //         ),
  //         TextField(
  //           controller: tempoRestEsercizioController,
  //           keyboardType: TextInputType.number,
  //           inputFormatters: <TextInputFormatter>[
  //             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //           ],
  //           decoration: const InputDecoration(hintText: "Tempo di riposo.. (in secondi)"),
  //         ),
  //       ]),
  //       actions: [
  //         TextButton(
  //           child: const Text("Crea"),
  //           onPressed: () {
  //             if (nomeEsercizioController.text.isNotEmpty &&
  //                 descrizioneEsercizioController.text.isNotEmpty &&
  //                 numRepEsercizioController.text.isNotEmpty &&
  //                 numSerieEsercizioController.text.isNotEmpty &&
  //                 tempoRestEsercizioController.text.isNotEmpty &&
  //                 item != Constants.daysWeek[0]) {
  //               esercizi.add(Esercizio(
  //                   descrizioneEsercizioController.text,
  //                   nomeEsercizioController.text,
  //                   int.parse(numSerieEsercizioController.text),
  //                   int.parse(numRepEsercizioController.text),
  //                   int.parse(tempoRestEsercizioController.text),
  //                   Constants.convertDayWeekInInt(item!),
  //                   ""));
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                   Constants.createSnackBar('Esercizio creato correttamente.',
  //                       Constants.successSnackBar));
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                   Constants.createSnackBar(
  //                       'Esercizio non creato. Uno o piu campi non validi.',
  //                       Constants.errorSnackBar));
  //             }
  //             clearFieldsEsercizio();
  //             Navigator.pop(context);
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
