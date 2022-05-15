import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';

import '../Controller/HealthyAppController.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class AddSchedaPalestraPage extends StatelessWidget {
  AddSchedaPalestraPage({Key? key}) : super(key: key);

  static HealthyAppController c = HealthyAppController.instance;

  SchedaPalestra? schedaNew;
  List<Esercizio> esercizi = [];

  TextEditingController nomeController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController dataInizioController = TextEditingController();
  TextEditingController dataFineController = TextEditingController();

  TextEditingController dayEsercizioController = TextEditingController();
  TextEditingController descrizioneEsercizioController =
      TextEditingController();
  TextEditingController nomeEsercizioController = TextEditingController();
  TextEditingController numRepEsercizioController = TextEditingController();
  TextEditingController numSerieEsercizioController = TextEditingController();
  TextEditingController tempoRestEsercizioController = TextEditingController();

  String? getCurrentIdUser() {
    return c.gestoreAuth.firebaseAuth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.backgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Constants.text,
            )),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
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
                      "Crea Scheda Palestra",
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
                          openAddEsercizioDialog(context);
                        },
                        key: GlobalKey(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: const Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black))),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        if (nomeController.text.isNotEmpty &&
                            descrizioneController.text.isNotEmpty &&
                            DateTime.parse(dataFineController.text).isBefore(DateTime.parse(dataInizioController.text))) {
                          schedaNew = c.createSchedaPalestra(descrizioneController.text,
                              nomeController.text, DateTime.parse(dataInizioController.text),
                              DateTime.parse(dataFineController.text), getCurrentIdUser());
                          for (var element in esercizi) {
                            element.idSchedaPalestra = schedaNew?.id;
                            c.createEsercizio(schedaNew!, element.descrizione!,
                                element.nome!, element.nSerie!.toInt(), element.nRep!.toInt(),
                                element.tempoRiposo!.toInt(), element.day!.toInt());
                            schedaNew?.updateEsercizio(element);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.createSnackBar(
                                  'Scheda creata correttamente.',
                                  Constants.successSnackBar));
                          Constants.redirectTo(context, HomePage());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.createSnackBar('Inserire tutti i dati o controllare che la data di fine sia dopo la data di inizio.',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future openAddEsercizioDialog(context) => showDialog(
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
            TextField(
              controller: dayEsercizioController,
              decoration: const InputDecoration(hintText: "Giorno.."),
            ),
            TextField(
              controller: numRepEsercizioController,
              decoration:
                  const InputDecoration(hintText: "Numero ripetizioni.."),
            ),
            TextField(
              controller: numSerieEsercizioController,
              decoration: const InputDecoration(hintText: "Numero serie.."),
            ),
            TextField(
              controller: tempoRestEsercizioController,
              decoration: const InputDecoration(hintText: "Tempo di riposo.."),
            ),
            CheckboxListTile(
              //todo --
              title: const Text("Cronometro programmabile"),
              value: false,
              onChanged: (newValue) {},
              controlAffinity: ListTileControlAffinity.leading,
            )
          ]),
          actions: [
            TextButton(
              child: const Text("Crea"),
              onPressed: () {
                if(nomeEsercizioController.text.isNotEmpty &&
                descrizioneEsercizioController.text.isNotEmpty &&
                dayEsercizioController.text.isNotEmpty &&
                numRepEsercizioController.text.isNotEmpty &&
                numSerieEsercizioController.text.isNotEmpty &&
                tempoRestEsercizioController.text.isNotEmpty){
                  esercizi.add(Esercizio(descrizioneEsercizioController.text, nomeEsercizioController.text,
                      int.parse(numSerieEsercizioController.text), int.parse(numRepEsercizioController.text),
                      int.parse(tempoRestEsercizioController.text), int.parse(dayEsercizioController.text),
                      ""));
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.createSnackBar('Esercizio creato correttamente.',
                          Constants.successSnackBar));
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.createSnackBar('Esercizio non creato. Uno o piu campi non validi.',
                          Constants.errorSnackBar));
                }
                nomeEsercizioController.clear();
                descrizioneController.clear();
                dayEsercizioController.clear();
                numRepEsercizioController.clear();
                numSerieEsercizioController.clear();
                tempoRestEsercizioController.clear();
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
}
