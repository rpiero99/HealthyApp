import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';
import 'package:vector_math/vector_math_64.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/AnagraficaUtente.dart';
import '../Model/CategoriaPasto.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class AddPastoGiornaliero extends StatefulWidget {
  AddPastoGiornaliero({Key? key}) : super(key: key);

  AnagraficaUtente? anagraficaNew;
  Utente? utenteNew;

  TextEditingController calorieController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController descrizionePastoController = TextEditingController();
  TextEditingController nomePastoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  String? categoriaComboItem = 'Categoria pasto..';

  @override
  _AddPastoGiornalieroPage createState() => _AddPastoGiornalieroPage();
}

class _AddPastoGiornalieroPage extends State<AddPastoGiornaliero> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Pasto giornaliero", Constants.controller),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Crea Pasto",
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
                      controller: widget.nomePastoController),
                  makeInput(
                      label: "Descrizione..",
                      obscureText: false,
                      controller: widget.descrizionePastoController),
                  makeInput(
                      label: "Quantità..",
                      obscureText: false,
                      controller: widget.quantitaController,
                      context: context,
                      isNumber: true),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 54,
                    ),
                    decoration: BoxDecoration(
                        color: Constants.text,
                        borderRadius: BorderRadius.circular(25.7)),

                    child: DropdownButton<String>(
                      value: widget.categoriaComboItem,
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.categoriaComboItem = newValue!;
                        });
                      },
                      items: Constants.categoriePastoString()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: const SizedBox(),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  makeInput(
                    label: "Tipo..",
                    obscureText: false,
                    controller: widget.typeController,
                    context: context,
                  ),
                  makeInput(
                    label: "Calorie stimate..",
                    obscureText: false,
                    controller: widget.calorieController,
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(40)),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    if (widget.nomePastoController.text.isNotEmpty &&
                        widget.descrizionePastoController.text.isNotEmpty &&
                        widget.quantitaController.text.isNotEmpty &&
                        widget.typeController.text.isNotEmpty &&
                        widget.calorieController.text.isNotEmpty &&
                        widget.categoriaComboItem != 'Categoria pasto..' &&
                        Constants.controller.gestoreUtente.pastiOfDay.where((element) => element.nome == widget.nomePastoController.text).isEmpty) {
                      Constants.controller.createPastoOfDay(
                          Constants.getCategoriaFromString(
                              widget.categoriaComboItem!),
                          int.parse(widget.calorieController.text),
                          widget.descrizionePastoController.text,
                          widget.nomePastoController.text,
                          int.parse(widget.quantitaController.text),
                          widget.typeController.text,
                          Constants.getCurrentIdUser()!);
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar(
                              'Pasto aggiunto correttamente.',
                              Constants.successSnackBar));
                      Constants.redirectTo(context, HomePage());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar('Inserire tutti i dati o controllare che il nome non sia già esistente.',
                              Constants.errorSnackBar));
                    }
                    widget.categoriaComboItem =
                        CategoriaPasto.values[0].toString().split('.').last;

                  },
                  color: Constants.backgroundColorLoginButton,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: const Text(
                    "Aggiungi Pasto",
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
