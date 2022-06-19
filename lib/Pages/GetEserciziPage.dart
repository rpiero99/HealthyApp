import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';

import '../Utils/Constants.dart';
import 'Widgets/RoundedButton.dart';
import 'Widgets/TopAppBar.dart';

class GetEserciziPage extends StatefulWidget {
  SchedaPalestra? schedaToEdit;
  Esercizio? esercizioToView;

  GetEserciziPage({Key? key, required SchedaPalestra scheda})
      : super(key: key) {
    schedaToEdit = scheda;
  }

  @override
  _GetEserciziPage createState() => _GetEserciziPage();
}

class _GetEserciziPage extends State<GetEserciziPage> {
  List<Esercizio> allEsercizi = [];
  String? item = Constants.daysWeek[0];
  String searchString = "";
  TextEditingController dayEsercizioController = TextEditingController();
  TextEditingController descrizioneEsercizioController = TextEditingController();
  TextEditingController nomeEsercizioController = TextEditingController();
  TextEditingController numRepEsercizioController = TextEditingController();
  TextEditingController numSerieEsercizioController = TextEditingController();
  TextEditingController tempoRestEsercizioController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context,
          "Esercizi di: " + widget.schedaToEdit!.nome!, Constants.controller),
      body: SingleChildScrollView(
        child: SizedBox(
            child: Column(
                children: <Widget>[
                    TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: "cerca..",
                          hintStyle:  const TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]!)),
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
                        clearFieldsEsercizio();
                        return openAddEsercizioDialog(context);
                      },
                      key: GlobalKey(),
                    ),
                    const Divider(),
                    Container(
                      child: showCards(),
                    )
        ])),
      ),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: Constants.controller.getAllEserciziOf(widget.schedaToEdit),
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
              onTap: () => {
                widget.esercizioToView = obj,
                openViewEsercizio(context, false),
              },
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
                              widget.esercizioToView = obj;
                              openViewEsercizio(context, true);
                            }
                            ),
                        TextButton(
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              Constants.controller
                                  .removeEsercizio(widget.schedaToEdit!, obj);
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
            builder: (BuildContext context, StateSetter dropDownState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
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
            decoration: const InputDecoration(
                hintText: "Tempo di riposo.. (in secondi)"),
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
                  item != Constants.daysWeek[0] &&
                  allEsercizi.where((element) => element.nome == nomeEsercizioController.text.trim().toLowerCase() &&
                  element.day == Constants.convertDayWeekInInt(item!)).isEmpty) {
                setState(() {
                  Constants.controller.createEsercizio(
                    widget.schedaToEdit!, descrizioneEsercizioController.text,
                      nomeEsercizioController.text,
                      int.parse(numSerieEsercizioController.text),
                      int.parse(numRepEsercizioController.text),
                      int.parse(tempoRestEsercizioController.text),
                      Constants.convertDayWeekInInt(item!));
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.createSnackBar('Esercizio creato correttamente.',
                          Constants.successSnackBar));
                });
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

  void setFieldsEsercizio(){
    nomeEsercizioController.text = widget.esercizioToView!.nome!;
    descrizioneEsercizioController.text = widget.esercizioToView!.descrizione!;
    dayEsercizioController.text = Constants.convertDayWeekInString(widget.esercizioToView!.day!.toInt());
    numRepEsercizioController.text = widget.esercizioToView!.nRep!.toString();
    numSerieEsercizioController.text = widget.esercizioToView!.nSerie!.toString();
    tempoRestEsercizioController.text = widget.esercizioToView!.tempoRiposo!.toString();
  }

  Future openViewEsercizio(context, isEdit) {
    setFieldsEsercizio();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(widget.esercizioToView!.nome!),
        content: Column(children: [
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: nomeEsercizioController,
            decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Nome',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: descrizioneEsercizioController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Descrizione',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: dayEsercizioController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Giorno',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: numRepEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Numero rep',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: numSerieEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Numero serie',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: tempoRestEsercizioController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Tempo di riposo',
            ),
          ),

        ]),
        actions: [
          isEdit ?
            TextButton(
              child: const Text("Modifica"),
              onPressed: () {
                if (nomeEsercizioController.text.isNotEmpty &&
                    descrizioneEsercizioController.text.isNotEmpty &&
                    numRepEsercizioController.text.isNotEmpty &&
                    numSerieEsercizioController.text.isNotEmpty &&
                    tempoRestEsercizioController.text.isNotEmpty &&
                    Constants.convertDayWeekInInt(dayEsercizioController.text) != -1) {
                  setState(() {
                    var oldName = widget.esercizioToView!.nome;
                    widget.esercizioToView!.nome = nomeEsercizioController.text;
                    widget.esercizioToView!.descrizione = descrizioneEsercizioController.text;
                    widget.esercizioToView!.nRep = int.parse(numRepEsercizioController.text);
                    widget.esercizioToView!.nSerie = int.parse(numSerieEsercizioController.text);
                    widget.esercizioToView!.day = Constants.convertDayWeekInInt(dayEsercizioController.text);
                    widget.esercizioToView!.tempoRiposo = int.parse(tempoRestEsercizioController.text);
                    Constants.controller.updateEsercizio(widget.schedaToEdit!, widget.esercizioToView!, oldName!);
                    ScaffoldMessenger.of(context).showSnackBar(
                        Constants.createSnackBar('Esercizio creato correttamente.',
                            Constants.successSnackBar));
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.createSnackBar(
                          'Esercizio non modificato. Uno o piu campi non validi.',
                          Constants.errorSnackBar));
                }
                clearFieldsEsercizio();
                Navigator.pop(context);
              },
            )
          :
            TextButton(
              child: const Text("Chiudi"),
              onPressed: () {
                clearFieldsEsercizio();
                Navigator.pop(context);
              },
            )
        ],
      ),
    );
  }
}
