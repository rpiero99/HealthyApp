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

  EditSchedaPalestraPage(
      {Key? key,
      required String id,
      required String nome,
      required String descrizione,
      required DateTime dataInizio,
      required DateTime dataFine})
      : super(key: key) {
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
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Modifica Scheda Palestra",
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
                        SchedaPalestra schedaToEdit = await Constants.controller
                            .getSchedaPalestraById(widget.idController.text);
                        Constants.redirectTo(
                            context, GetEserciziPage(scheda: schedaToEdit));
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
                      var scheda = await Constants.controller
                          .getSchedaPalestraById(widget.idController.text);
                      scheda.nome = widget.nomeController.text;
                      scheda.descrizione = widget.descrizioneController.text;
                      scheda.dataInizio =
                          DateTime.parse(widget.dataInizioController.text);
                      scheda.dataFine =
                          DateTime.parse(widget.dataFineController.text);
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
        ),
      ),
    );
  }
}
