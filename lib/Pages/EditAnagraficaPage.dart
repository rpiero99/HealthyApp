import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/AnagraficaUtente.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class EditAnagraficaPage extends StatefulWidget {

  TextEditingController altezzaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascitaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController sessoController = TextEditingController();
  Utente utenteSelected = Utente("_id", null, "_email");

  EditAnagraficaPage({Key? key, required Utente utente}) : super(key: key) {
    utenteSelected = utente;
    altezzaController.text = utente.anagraficaUtente!.altezzaUtente.toString();
    nomeController.text = utente.anagraficaUtente!.nomeUtente!;
    dataNascitaController.text =
        utente.anagraficaUtente!.dataNascitaUtente.toString();
    pesoController.text = utente.anagraficaUtente!.pesoUtente.toString();
    emailController.text = utente.email!;
    sessoController.text = utente.anagraficaUtente!.sessoUtente!;
  }

  @override
  _EditAnagraficaPage createState() => _EditAnagraficaPage();
}

class _EditAnagraficaPage extends State<EditAnagraficaPage> {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Modifica scheda anagrafica",
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
                            obscureText: false,
                            controller: widget.nomeController),
                        makeInput(
                            obscureText: false,
                            controller: widget.emailController),
                        makeInput(
                          obscureText: false,
                          controller: widget.dataNascitaController,
                          isDate: true,
                          context: context,
                        ),
                        makeInput(
                          obscureText: false,
                          controller: widget.sessoController,
                          context: context,
                        ),
                        makeInput(
                          obscureText: false,
                          controller: widget.altezzaController,
                          context: context,
                        ),
                        makeInput(
                          obscureText: false,
                          controller: widget.pesoController,
                          context: context,
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
                            if (widget.nomeController.text.isNotEmpty &&
                                widget.emailController.text.isNotEmpty &&
                                DateTime.parse(
                                        widget.dataNascitaController.text)
                                    .isBefore(DateTime.now()) &&
                                widget.altezzaController.text.isNotEmpty &&
                                widget.pesoController.text.isNotEmpty &&
                                widget.sessoController.text.isNotEmpty) {
                              widget.utenteSelected.anagraficaUtente
                                  ?.nomeUtente = widget.nomeController.text;
                              widget.utenteSelected.anagraficaUtente
                                      ?.dataNascitaUtente =
                                  DateTime.parse(
                                      widget.dataNascitaController.text);
                              widget.utenteSelected.anagraficaUtente
                                      ?.altezzaUtente =
                                  int.parse(widget.altezzaController.text);
                              widget.utenteSelected.anagraficaUtente
                                      ?.pesoUtente =
                                  int.parse(widget.pesoController.text);
                              widget.utenteSelected.anagraficaUtente
                                  ?.sessoUtente = widget.sessoController.text;

                              Constants.controller.updateAnagraficaUtente(
                                  widget.utenteSelected.anagraficaUtente!);
                              widget.utenteSelected.email =
                                  widget.emailController.text;
                              Constants.controller
                                  .updateUtente(widget.utenteSelected);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.createSnackBar(
                                      'Utente modificato correttamente.',
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
                            "Modifica Utente",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Constants.textButtonColor),
                          ),
                        ),
                      ))
                ],
              ),
            )));
  }
}
