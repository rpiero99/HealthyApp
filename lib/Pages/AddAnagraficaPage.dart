import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/AnagraficaUtente.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';
import 'Widgets/TopAppBar.dart';

class AddAnagraficaPage extends StatelessWidget {
  AddAnagraficaPage({Key? key}) : super(key: key);

  AnagraficaUtente? anagraficaNew;
  Utente? utenteNew;

  TextEditingController altezzaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascitaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController sessoController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Anagrafica Utente", Constants.controller),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    makeInput(
                        label: "Nome..",
                        obscureText: false,
                        controller: nomeController),
                    makeInput(
                        label: "Email..",
                        obscureText: false,
                        controller: emailController),
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
                      isNumber: true,
                    ),
                    makeInput(
                      label: "Peso (in kg)..",
                      obscureText: false,
                      controller: pesoController,
                      context: context,
                      isNumber: true,
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
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      if (nomeController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          DateTime.parse(dataNascitaController.text).isBefore(
                              DateTime.now()) &&
                          altezzaController.text.isNotEmpty &&
                          pesoController.text.isNotEmpty &&
                          sessoController.text.isNotEmpty) {
                        anagraficaNew = Constants.controller.createAnagraficaUtente(
                            int.parse(altezzaController.text),
                            DateTime.parse(dataNascitaController.text),
                            nomeController.text,
                            double.parse(pesoController.text),
                            sessoController.text);
                        utenteNew = Constants.controller.createUtente(
                            Constants.getCurrentIdUser()!, anagraficaNew!,
                            emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Utente creato correttamente.',
                                Constants.successSnackBar));
                        Constants.redirectTo(context, HomePage());
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