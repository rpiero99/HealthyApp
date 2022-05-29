import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/AnagraficaUtente.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';
import 'package:healthy_app/Model/PianoAlimentare.dart';
import 'package:healthy_app/Model/Utente.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/Pasto.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'RegistrationPage.dart';
import 'Widgets/InputWidget.dart';
import 'Widgets/RoundedButton.dart';
import 'Widgets/TopAppBar.dart';

class EditPianoAlimentarePage extends StatelessWidget {
  EditPianoAlimentarePage({Key? key}) : super(key: key);

  TextEditingController dataInizioController = TextEditingController();
  TextEditingController dataFineController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  Utente? utente;
  PianoAlimentare? pianoAlimentare;

  Future<void> getCurrentPianoAlimentare() async {
    final User? user = auth.currentUser;
    String? uid = user?.uid;
    utente = await Constants.controller.getUtenteById(uid!);
    pianoAlimentare = Constants.controller.getCurrentPianoAlimentareOf(utente!);
  }

  @override
  Widget build(BuildContext context) {
    getCurrentPianoAlimentare();
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar:
            makeTopAppBar(context, "Piano alimentare", Constants.controller),
        body: SingleChildScrollView(
            child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Modifica Piano Alimentare",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Constants.text,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    makeInput(
                        context: context,
                        label: pianoAlimentare?.dataInizio.toString(),
                        isDate: true,
                        obscureText: false,
                        controller: dataInizioController),
                    makeInput(
                        context: context,
                        label: pianoAlimentare?.dataFine.toString(),
                        isDate: true,
                        obscureText: false,
                        controller: dataFineController),
                    makeInput(
                        label: pianoAlimentare?.descrizione,
                        obscureText: false,
                        controller: descrizioneController),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(40)),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      if (dataInizioController.text.isNotEmpty &&
                          dataFineController.text.isNotEmpty &&
                          descrizioneController.text.isNotEmpty) {
                        DateTime dataInizio =
                            DateTime.parse(dataInizioController.text);
                        DateTime dataFine =
                            DateTime.parse(dataFineController.text);
                        if (dataInizio.isAfter(dataFine)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(Constants.createSnackBar(
                                  'La data di inizio non può essere successiva alla'
                                  'data di fine',
                                  Constants.errorSnackBar));
                          dataInizioController.clear();
                          dataFineController.clear();
                        } else {
                          pianoAlimentare?.descrizione =
                              descrizioneController.text;
                          pianoAlimentare?.dataInizio =
                              DateTime.parse(dataInizioController.text);
                          pianoAlimentare?.dataFine =
                              DateTime.parse(dataFineController.text);
                          Constants.controller
                              .updatePianoAlimentare(pianoAlimentare!);
                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.createSnackBar(
                                  'Piano alimentare modificato correttamente.',
                                  Constants.successSnackBar));
                          Constants.redirectTo(context, HomePage());
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar('Compilare tutti i campi',
                                Constants.errorSnackBar));
                      }
                    },
                    color: Constants.backgroundColorLoginButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      "Modifica piano alimentare",
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
        )));
  }
}
