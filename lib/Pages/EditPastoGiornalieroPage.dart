import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/Widgets/RoundedButton.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';

import '../Model/Pasto.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';
class EditPastoGiornalieroPage extends StatefulWidget {
  TextEditingController nomeController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController calorieController = TextEditingController();
  CategoriaPasto categoriaPasto = CategoriaPasto.COLAZIONE;
  String comboItem = "Categoria pasto...";
  Pasto pastoSelected = Pasto(null, null, null, null, null, null);

  EditPastoGiornalieroPage({Key? key, required Pasto pasto}) : super(key: key){
    nomeController.text = pasto.nome!;
    descrizioneController.text = pasto.descrizione!;
    categoriaPasto = pasto.categoria!;
    tipoController.text = pasto.type!;
    calorieController.text = pasto.calorie.toString();
    quantitaController.text = pasto.quantita.toString();
    comboItem = pasto.categoria.toString().split('.').last;
    pastoSelected = pasto;
  }
  @override
  _EditPastoGiornalieroPage createState() => _EditPastoGiornalieroPage();
}

class _EditPastoGiornalieroPage extends State<EditPastoGiornalieroPage>{
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
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Column(
                      children: const [
                        Text(
                          "Crea Pasto",
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
                            label: "Quantità..",
                            obscureText: false,
                            controller: widget.quantitaController,
                            context: context,
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
                                      items: Constants.categoriePastoString()
                                          .map((String item) => DropdownMenuItem<String>(
                                          child: Text(item), value: item))
                                          .toList(),
                                      onChanged: (value) {
                                        dropDownState(() {
                                          widget.comboItem = (value as String?)!;
                                        });
                                      },
                                      value: widget.comboItem,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          makeInput(
                            label: "Tipo..",
                            obscureText: false,
                            controller: widget.tipoController,
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
                            border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black))),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {
                            if (widget.nomeController.text.isNotEmpty &&
                                widget.descrizioneController.text.isNotEmpty &&
                                widget.quantitaController.text.isNotEmpty &&
                                widget.tipoController.text.isNotEmpty &&
                                widget.calorieController.text.isNotEmpty &&
                                widget.comboItem != 'Categoria pasto..') {
                              widget.pastoSelected.nome = widget.nomeController.text;
                              widget.pastoSelected.descrizione = widget.descrizioneController.text;
                              widget.pastoSelected.quantita = int.parse(widget.quantitaController.text);
                              widget.pastoSelected.calorie = int.parse(widget.calorieController.text);
                              widget.pastoSelected.categoria = Constants.getCategoriaFromString(widget.comboItem);
                              widget.pastoSelected.type = widget.tipoController.text;
                              Constants.controller.updatePasto(widget.pastoSelected);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.createSnackBar(
                                      'Pasto aggiunto correttamente.',
                                      Constants.successSnackBar));
                              Constants.redirectTo(context, HomePage());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.createSnackBar('Inserire tutti i dati.',
                                      Constants.errorSnackBar));
                            }
                            widget.comboItem = CategoriaPasto.values[0].toString().split('.').last;
                            Navigator.pop(context);
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
              ],
            ),
          )
      ),
    );
  }

}

