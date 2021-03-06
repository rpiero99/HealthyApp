import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/AnagraficaUtente.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';
import 'package:healthy_app/Model/PianoAlimentare.dart';
import 'package:healthy_app/Model/Utente.dart';
import 'package:healthy_app/Pages/MainPage.dart';
import 'package:intl/intl.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/Pasto.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'RegistrationPage.dart';
import 'Widgets/InputWidget.dart';
import 'Widgets/RoundedButton.dart';
import 'Widgets/TopAppBar.dart';

class AddPianoAlimentarePage extends StatelessWidget{
  AddPianoAlimentarePage({Key? key}) : super(key: key);

  TextEditingController dataInizioController = TextEditingController();
  TextEditingController dataFineController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController calorieController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController oraPastoController = TextEditingController();
  TextEditingController giornoPastoController = TextEditingController();
  TextEditingController descrizionePastoController = TextEditingController();
  TextEditingController nomePastoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  Utente? utente;
  PianoAlimentare? pianoAlimentare;
  List<Pasto> pasti = [];
  String? giornoComboItem = 'Giorno..';
  String? categoriaComboItem = Constants.categoriePasto[0];
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: makeTopAppBar(context, "Piano alimentare", Constants.controller),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                        const Text(
                          "Crea Piano Alimentare",
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
                              label: "Data inizio piano",
                              isDate: true,
                              obscureText: false,
                              controller: dataInizioController),
                          makeInput(
                              context: context,
                              label: "Data fine piano",
                              isDate: true,
                              obscureText: false,
                              controller: dataFineController),
                          makeInput(
                              label: "Descrizione piano",
                              obscureText: false,
                              controller: descrizioneController),
                          makeInput(
                              label: "Nome piano",
                              obscureText: false,
                              controller: nomeController),
                          RoundedButton(
                            text: 'Aggiungi Pasto',
                            color: Constants.backgroundButtonColor,
                            textColor: Constants.textButtonColor,
                            press: () {
                              clearFieldsPasto();
                              openAddPastoDialog(context);
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
                           ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {
                              if(dataInizioController.text.isNotEmpty && dataFineController.text.isNotEmpty
                                && descrizioneController.text.isNotEmpty && nomeController.text.isNotEmpty){
                                  DateTime dataInizio = DateTime.parse(dataInizioController.text);
                                  DateTime dataFine = DateTime.parse(dataFineController.text);
                                  if(dataInizio.isAfter(dataFine)){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        Constants.createSnackBar(
                                            'La data di inizio non pu?? essere successiva alla'
                                                'data di fine',
                                            Constants.errorSnackBar));
                                    dataInizioController.clear();
                                    dataFineController.clear();
                                  }else{
                                    utente = await Constants.controller.getUtenteById(Constants.getCurrentIdUser()!);
                                    pianoAlimentare = Constants.controller.createPianoAlimentare(nomeController.text, dataFine, dataInizio, descrizioneController.text, Constants.getCurrentIdUser()!);
                                    for(var element in pasti){
                                      element.pianoAlimentare = pianoAlimentare?.id;
                                      Constants.controller.createPastoPianoAlimentare(pianoAlimentare!,
                                          element.categoria!,
                                          element.calorie!.toInt(),
                                          element.descrizione!,
                                          element.nome!,
                                          element.oraPasto!,
                                          element.giornoPasto!.toInt(),
                                          element.quantita!.toInt(),
                                          element.type!);
                                      pianoAlimentare?.addPasto(element);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        Constants.createSnackBar(
                                            'Piano alimentare creato correttamente.',
                                            Constants.successSnackBar));
                                    Constants.redirectTo(context, MainPage());
                                  }

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    Constants.createSnackBar(
                                        'Compilare tutti i campi',
                                        Constants.errorSnackBar));
                              }

                          },
                          color: Constants.backgroundColorLoginButton,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: const Text(
                            "Crea",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Constants.textButtonColor),
                          ),
                        ),
                      ),
                ),
            ]
          ),
        ));
  }
  void clearFieldsPasto() {
    calorieController.clear();
    categoriaController.clear();
    descrizionePastoController.clear();
    giornoPastoController.clear();
    oraPastoController.clear();
    nomePastoController.clear();
    typeController.clear();
    quantitaController.clear();
    categoriaComboItem = CategoriaPasto.values[0].toString().split('.').last;
  }

  Future openAddPastoDialog(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text("Nuovo Pasto"),
        content: Column(children: [
          TextField(
            controller: nomePastoController,
            decoration: const InputDecoration(hintText: "Nome.."),
          ),
          TextField(
            controller: descrizionePastoController,
            decoration: const InputDecoration(hintText: "Descrizione.."),
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
                      items: Constants.categoriePasto
                          .map((String item) => DropdownMenuItem<String>(
                          child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) {
                        dropDownState(() {
                          categoriaComboItem = value as String?;
                        });
                      },
                      value: categoriaComboItem,
                    ),
                  ),
                ),
              );
            },
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
                      items: Constants.daysWeek
                          .map((String item) => DropdownMenuItem<String>(
                          child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) {
                        dropDownState(() {
                          giornoComboItem = value as String?;
                        });
                      },
                      value: giornoComboItem,
                    ),
                  ),
                ),
              );
            },
          ),
          TextField(
            controller: quantitaController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Quantit??.."),
          ),
          TextField(
            controller: calorieController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Calorie.."),
          ),
          TextField(
            controller: typeController,
            decoration: const InputDecoration(hintText: "Tipo pasto.."),
          ),
          TextField(
            controller: oraPastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Ora di consumazione del pasto..',
            ),
            onTap: () async {
              TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                initialEntryMode: TimePickerEntryMode.dial,
              );
              if (timeOfDay != null) {

                  oraPastoController.text = _getStringFromTimeOfDay(timeOfDay);

              }
            },
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Crea"),
            onPressed: () {
              if (nomePastoController.text.isNotEmpty &&
                  descrizionePastoController.text.isNotEmpty &&
                  quantitaController.text.isNotEmpty &&
                  oraPastoController.text.isNotEmpty &&
                  typeController.text.isNotEmpty &&
                  calorieController.text.isNotEmpty &&
                  categoriaComboItem != 'Categoria pasto..' &&
                  giornoComboItem != Constants.daysWeek[0] &&
                  pasti.where((element) => element.nome != nomePastoController.text).isEmpty) {
                pasti.add(Pasto.pianoAlimentare(Constants.getCategoriaFromString(categoriaComboItem!),
                    int.parse(calorieController.text),
                    descrizionePastoController.text,
                    nomePastoController.text,
                    oraPastoController.text,
                    Constants.convertDayWeekInInt(giornoComboItem!),
                    int.parse(quantitaController.text),
                    typeController.text,
                    pianoAlimentare?.id));
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar('Pasto creato correttamente.',
                        Constants.successSnackBar));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar(
                        'Pasto non creato. Uno o piu campi non validi. Il nome potrebbe gi?? esistere.',
                        Constants.errorSnackBar));
              }
              clearFieldsPasto();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
  String _getStringFromTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.Hm();
    return format.format(dt);
  }
}