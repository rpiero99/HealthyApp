import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/EditPageSchedaPalestra.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/RoundedButton.dart';
import 'Widgets/TopAppBar.dart';

class GetEserciziPage extends StatefulWidget {

  SchedaPalestra? schedaToEdit;

  GetEserciziPage({Key? key, required SchedaPalestra scheda}) : super(key: key){
    schedaToEdit = scheda;
  }

  @override
  _GetEserciziPage createState() => _GetEserciziPage();
}

class _GetEserciziPage extends State<GetEserciziPage> {
  String? item = 'Giorno..';
  String searchString = "";
  TextEditingController dayEsercizioController = TextEditingController();
  TextEditingController descrizioneEsercizioController = TextEditingController();
  TextEditingController nomeEsercizioController = TextEditingController();
  TextEditingController numRepEsercizioController = TextEditingController();
  TextEditingController numSerieEsercizioController = TextEditingController();
  TextEditingController tempoRestEsercizioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Esercizi di: " +  widget.schedaToEdit!.nome!, Constants.controller),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "cerca..",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchString = value;
                });
              }),
          const Divider(),
          RoundedButton(
            text: 'Aggiungi Esercizio',
            color: Constants.backgroundButtonColor,
            textColor: Constants.textButtonColor,
            press: () async {
        //      SchedaPalestra schedaToEdit = await Constants.controller.getSchedaPalestraById(widget.schedaToEdit!.id!);
              return openAddEsercizioDialog(context);
              //clearFieldsEsercizio();
              //openAddEsercizioDialog(context);
            },
            key: GlobalKey(),
          ),
          const Divider(),
          Container(
            child: showCards(),
          )
        ]),
      ),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: Constants.controller.getAllEserciziOf(widget.schedaToEdit!),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Esercizio>).toList();
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: d.length,
            itemBuilder: (context, index) {
              if (searchString != "") {
                return _buildItem(d[index].nome!.contains(searchString) ||
                    d[index].descrizione!.contains(searchString)
                    ? d[index]
                    : null);
              }
              return _buildItem(d[index]);
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildItem(Esercizio? obj) {
    if (obj != null) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blueGrey,
        elevation: 10,
        child: SizedBox(
            width: 200,
            child: GestureDetector(
              onTap: () => {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading:
                    const Icon(Icons.sports_gymnastics_outlined, size: 100),
                    title: Text(obj.nome!,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(obj.descrizione!,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  ButtonTheme(
                    child: ButtonBar(
                      children: <Widget>[
                        TextButton(
                          child: const Text('Modifica',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            //todo : pagina per modificare esercizio
                          }
                          //   Constants.redirectTo(
                          //       context,
                          //       EditSchedaPalestraPage(
                          //           id: obj.id!,
                          //           nome: obj.nome!,
                          //           descrizione: obj.descrizione!,
                          //           dataInizio: obj.dataInizio!,
                          //           dataFine: obj.dataFine!));
                          // },
                        ),
                        TextButton(
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              Constants.controller.removeEsercizio(widget.schedaToEdit!, obj);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    }
    return const Divider();
  }

  Future openAddEsercizioDialog(context) {
    return showDialog(
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
                          item = value as String?;
                        });
                      },
                      value: item,
                    ),
                  ),
                ),
              );
            },
          ),
          TextField(
            controller: numRepEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Numero ripetizioni.."),
          ),
          TextField(
            controller: numSerieEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Numero serie.."),
          ),
          TextField(
            controller: tempoRestEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(hintText: "Tempo di riposo.. (in secondi)"),
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Crea"),
            onPressed: () {
              if (nomeEsercizioController.text.isNotEmpty &&
                  descrizioneEsercizioController.text.isNotEmpty &&
                  numRepEsercizioController.text.isNotEmpty &&
                  numSerieEsercizioController.text.isNotEmpty &&
                  tempoRestEsercizioController.text.isNotEmpty &&
                  item != Constants.daysWeek[0]) {
                Constants.controller.addEsercizio(widget.schedaToEdit!, Esercizio(
                    descrizioneEsercizioController.text,
                    nomeEsercizioController.text,
                    int.parse(numSerieEsercizioController.text),
                    int.parse(numRepEsercizioController.text),
                    int.parse(tempoRestEsercizioController.text),
                    Constants.convertDayWeekInInt(item!),
                    ""));
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar('Esercizio creato correttamente.',
                        Constants.successSnackBar));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar(
                        'Esercizio non creato. Uno o piu campi non validi.',
                        Constants.errorSnackBar));
              }
              clearFieldsEsercizio();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void clearFieldsEsercizio() {
    nomeEsercizioController.clear();
    descrizioneEsercizioController.clear();
    dayEsercizioController.clear();
    numRepEsercizioController.clear();
    numSerieEsercizioController.clear();
    tempoRestEsercizioController.clear();
    item = Constants.daysWeek[0];
  }
}
