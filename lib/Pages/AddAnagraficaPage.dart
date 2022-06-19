import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/MainPage.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';

import '../Model/AnagraficaUtente.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'Widgets/InputWidget.dart';

class AddAnagraficaPage extends StatelessWidget {
  AddAnagraficaPage({Key? key}) : super(key: key);

  AnagraficaUtente? anagraficaNew;
  Utente? utenteNew;

  TextEditingController altezzaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascitaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController sessoController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Anagrafica", Constants.controller),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Crea Scheda Anagrafica",
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
                    label: "Data di nascita..",
                    obscureText: false,
                    controller: dataNascitaController,
                    isDate: true,
                    context: context,
                  ),
                  makeInput(
                    label: "Sesso..",
                    obscureText: false,
                    controller: sessoController,
                    context: context,
                  ),
                  makeInput(
                      label: "Altezza (in cm)..",
                      obscureText: false,
                      controller: altezzaController,
                      context: context,
                      isNumber: true),
                  makeInput(
                      label: "Peso (in kg)..",
                      obscureText: false,
                      controller: pesoController,
                      context: context,
                      isNumber: true),
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
                    if (nomeController.text.isNotEmpty &&
                        DateTime.parse(dataNascitaController.text)
                            .isBefore(DateTime.now()) &&
                        altezzaController.text.isNotEmpty &&
                        pesoController.text.isNotEmpty &&
                        sessoController.text.isNotEmpty) {
                      anagraficaNew = Constants.controller
                          .createAnagraficaUtente(
                              int.parse(altezzaController.text),
                              DateTime.parse(dataNascitaController.text),
                              nomeController.text,
                              double.parse(pesoController.text),
                              sessoController.text);
                      utenteNew = Constants.controller.createUtente(
                          Constants.getCurrentIdUser()!,
                          anagraficaNew!,
                          (Constants.controller.gestoreAuth.firebaseAuth.currentUser?.email)!);
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar(
                              'Scheda anagrafica creata correttamente.',
                              Constants.successSnackBar));
                      Constants.redirectTo(context, MainPage());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar(
                              'Inserire tutti i dati o controllare che la data di nascita non sia futura.',
                              Constants.errorSnackBar));
                    }
                  },
                  color: Constants.backgroundColorLoginButton,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: const Text(
                    "Crea Utente",
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
      ),
    );
  }
}
