import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Allenamento.dart';
import 'package:healthy_app/Pages/LoginPage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Utils/Constants.dart';

import 'Background.dart';
import 'StartAllenamentoPage.dart';
import 'Widgets/InputWidget.dart';
import 'Widgets/TopAppBar.dart';

class AddAllenamentoPage extends StatefulWidget {
  AddAllenamentoPage({Key? key}) : super(key: key);

  TextEditingController descrizioneController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  @override
  _AddAllenamentoPage createState() => _AddAllenamentoPage();
}

class _AddAllenamentoPage extends State<AddAllenamentoPage> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.backgroundColor,
//      appBar: makeTopAppBar(context, "Allenamento", Constants.controller),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 30,
              ),
            const Text(
              "Avvia un nuovo allenamento",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Constants.text,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
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
                      if (widget.nomeController.text.isNotEmpty &&
                          widget.descrizioneController.text.isNotEmpty) {
                        Allenamento alle = Constants.controller.createAllenamento(widget.descrizioneController.text, widget.nomeController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Allenamento aggiunto correttamente.',
                                Constants.successSnackBar));
                        Constants.redirectTo(context, StartAllenamentoPage(alle));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar('Inserire tutti i dati',
                                Constants.errorSnackBar));
                      }
                    },
                    color: Constants.backgroundColorLoginButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      "Salva anagrafica allenamento",
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
