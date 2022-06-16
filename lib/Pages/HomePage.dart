import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Esercizio.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:intl/intl.dart';

import '../Model/Pasto.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'Widgets/RoundedButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchString = "";
  Pasto? pastoToView;
  Esercizio? esercizioToView;
  String? categoriaItem = Constants.categoriePasto[0];
  TextEditingController dataPasti = TextEditingController();
  TextEditingController calorieController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController descrizionePastoController = TextEditingController();
  TextEditingController nomePastoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  SchedaPalestra? currentScheda;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    dataPasti.text = formattedDate;
    getCurrentScheda();
  }

  // Future<Utente?> utenteFut = Constants.controller
  //     .getUtenteByEmail((FirebaseAuth.instance.currentUser?.email)!);
  // Utente? utente;
  //
  // Future<void> getUtenteSelected(Future<Utente?> utenteFuture) async {
  //   utente = await utenteFuture;
  // }

  Future<void> getCurrentScheda() async {
    currentScheda = await Constants.controller.getCurrentSchedaPalestra();
  }

  // Map<String, Widget> mapWidgets = <String, Widget>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  child: TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          //todo - aggiungere set della data giorno dell esercizio della scheda corrente.
                          dataPasti.text =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  padding: EdgeInsets.only(
                      right: 8, left: MediaQuery.of(context).size.width / 4),
                ),
                Text(
                  dataPasti.text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    letterSpacing: -0.2,
                    color: Constants.text,
                  ),
                ),
              ],
            ),
            //todo - cerca solo per pasto. aggiungere la ricerca per esercizi.
            TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "cerca..",
                  hintStyle: const TextStyle(color: Colors.white),
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
            Row(
              children: const [
                Padding(padding: EdgeInsets.only(left: 14)),
                Text(
                  "Pasti del giorno",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: -0.2,
                    color: Constants.text,
                  ),
                ),
              ],
            ),
            RoundedButton(
              text: 'Aggiungi Pasto',
              color: Constants.backgroundButtonColor,
              textColor: Constants.textButtonColor,
              press: () async {
                clearFieldsPasto();
                return openAddPastoDialog(context);
              },
              key: GlobalKey(),
            ),
            Row(
              children: [
                SizedBox(
                  width: 390,
                  child: showCardsPasti(),
                )
              ],
            ),
            const Divider(),
            Row(
              children: const [
                Padding(padding: EdgeInsets.only(left: 14)),
                Text(
                  "Esercizi del giorno",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: -0.2,
                    color: Constants.text,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 390,
                  child: showCardsEsercizi(),
                )
              ],
            ),
          ],
        ),
      ),
    );
    // initializeMap();
    // return Scaffold(
    //   backgroundColor: Constants.backgroundColor,
    //  // appBar: makeTopAppBar(context, "Home Page", c),
    // //  bottomNavigationBar: makeBottomAppBar(context)
    //   //CurvedNavigationBar(
    //   //   backgroundColor: Constants.backgroundColor,
    //   //   items: const <Widget>[
    //   //     Icon(
    //   //       Icons.home_outlined,
    //   //       size: 30,
    //   //       color: Constants.backgroundColor,
    //   //     ),
    //   //     Icon(Icons.run_circle_outlined,
    //   //         size: 30, color: Constants.backgroundColor),
    //   //     Icon(Icons.add_circle_outline_outlined,
    //   //         size: 30, color: Constants.backgroundColor),
    //   //     Icon(Icons.list_alt_outlined,
    //   //         size: 30, color: Constants.backgroundColor),
    //   //     Icon(Icons.account_circle_outlined,
    //   //         size: 30, color: Constants.backgroundColor),
    //   //   ],
    //   //   onTap: (index) {
    //   //     //Handle button tap
    //   //   },
    //   // ),
    //
    //   body: Container(
    //     child: showChildren(),
    //   )
    // );
  }

  Widget showCardsPasti() {
    return FutureBuilder(
      future:
          Constants.controller.getPastiOfDay(DateTime.parse(dataPasti.text)),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Pasto>).toList();
          if (d != null && d.isNotEmpty) {
            return SizedBox(
              width: 400,
              child: ListView.builder(
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
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        return const Divider();
      },
    );
  }

  Widget showCardsEsercizi() {
    return FutureBuilder(
      future: Constants.controller.getAllEserciziOf(currentScheda!),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Esercizio>).toList();
          if (d != null && d.isNotEmpty) {
            return SizedBox(
              width: 400,
              child: ListView.builder(
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
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        return const Divider();
      },
    );
  }

  Widget _buildItem(Object? obj) {
    var flagPasto = true;
    flagPasto = _checkTypeObj(obj, flagPasto);
    if (obj != null) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blueGrey,
        elevation: 10,
        child: GestureDetector(
          onTap: () => {
            if (obj is Pasto)
              {
                flagPasto = true,
                pastoToView = obj,
                openViewPasto(context, false),
              }
            else if (obj is Esercizio)
              {
                flagPasto = false,
                esercizioToView = obj,
                //todo openViewEsercizio(context, false);
              }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.fastfood_outlined, size: 100),
                title: Text(flagPasto ? pastoToView!.nome! : "", //todo - aggiungere il nome dell'esercizio
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(flagPasto ? pastoToView!.descrizione! : "", //todo - aggiungere la descrizione dell'esercizio
                    style: const TextStyle(color: Colors.white)),
              ),
              ButtonTheme(
                child: ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: const Text('Modifica',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (flagPasto) {
                          openViewPasto(context, true);
                        } else {
                          //todo openViewEsercizio(context, true);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text('Rimuovi',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          if (flagPasto) {
                            Constants.controller
                                .removePastoGiornaliero(pastoToView!);
                          } else {
                            Constants.controller.removeEsercizio(currentScheda!, esercizioToView!);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const Divider();
  }

  bool _checkTypeObj(Object? obj, bool isPasto) {
     if (obj is Pasto) {
      isPasto = true;
      pastoToView = obj;
    } else if (obj is Esercizio) {
      isPasto = false;
      esercizioToView = obj;
    }
    return isPasto;
  }

  void setFieldsPasto() {
    calorieController.text = pastoToView!.calorie!.toString();
    categoriaController.text = pastoToView!.categoria!.name;
    descrizionePastoController.text = pastoToView!.descrizione!;
    nomePastoController.text = pastoToView!.nome!;
    quantitaController.text = pastoToView!.quantita.toString();
    typeController.text = pastoToView!.type.toString();
  }

  Future openViewPasto(context, isEdit) {
    setFieldsPasto();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(pastoToView!.nome!),
        content: Column(children: [
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: nomePastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: descrizionePastoController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Descrizione',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: calorieController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Calorie',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
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
                      items: Constants.categoriePasto
                          .map((String item) => DropdownMenuItem<String>(
                              child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) {
                        if (isEdit) {
                          dropDownState(() {
                            categoriaItem = (value as String?)!;
                            categoriaController.text = categoriaItem!;
                          });
                        }
                      },
                      value: categoriaController.text,
                    ),
                  ),
                ),
              );
            },
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: quantitaController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Quantità (in gr)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
            ],
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: typeController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Tipo pasto',
            ),
          ),
        ]),
        actions: [
          isEdit
              ? TextButton(
                  child: const Text("Modifica"),
                  onPressed: () {
                    if (nomePastoController.text.isNotEmpty &&
                        descrizionePastoController.text.isNotEmpty &&
                        quantitaController.text.isNotEmpty &&
                        categoriaItem != Constants.categoriePasto[0] &&
                        calorieController.text.isNotEmpty &&
                        typeController.text.isNotEmpty) {
                      setState(() {
                        pastoToView!.nome = nomePastoController.text;
                        pastoToView!.descrizione =
                            descrizionePastoController.text;
                        pastoToView!.quantita =
                            int.parse(quantitaController.text);
                        pastoToView!.calorie =
                            int.parse(calorieController.text);
                        pastoToView!.type = typeController.text;
                        pastoToView!.categoria =
                            Constants.getCategoriaFromString(
                                categoriaController.text);
                        Constants.controller.updatePasto(pastoToView!);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Pasto modificato correttamente.',
                                Constants.successSnackBar));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar(
                              'Pasto non modificato. Uno o piu campi non validi.',
                              Constants.errorSnackBar));
                    }
                    clearFieldsPasto();
                    Navigator.pop(context);
                  },
                )
              : TextButton(
                  child: const Text("Chiudi"),
                  onPressed: () {
                    clearFieldsPasto();
                    Navigator.pop(context);
                  },
                )
        ],
      ),
    );
  }

  void clearFieldsPasto() {
    calorieController.clear();
    categoriaController.clear();
    descrizionePastoController.clear();
    nomePastoController.clear();
    quantitaController.clear();
    typeController.clear();
    categoriaItem = Constants.categoriePasto[0];
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
                      items: Constants.categoriePasto
                          .map((String item) => DropdownMenuItem<String>(
                              child: Text(item), value: item))
                          .toList(),
                      onChanged: (value) {
                        dropDownState(() {
                          categoriaItem = (value as String?)!;
                          categoriaController.text = categoriaItem!;
                        });
                      },
                      value: categoriaItem,
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
            decoration: const InputDecoration(hintText: "Quantità.."),
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
        ]),
        actions: [
          TextButton(
            child: const Text("Crea"),
            onPressed: () {
              if (nomePastoController.text.isNotEmpty &&
                  descrizionePastoController.text.isNotEmpty &&
                  quantitaController.text.isNotEmpty &&
                  categoriaItem != Constants.categoriePasto[0] &&
                  calorieController.text.isNotEmpty &&
                  typeController.text.isNotEmpty) {
                setState(() {
                  Constants.controller.createPastoOfDay(
                      Constants.getCategoriaFromString(
                          categoriaController.text),
                      int.parse(calorieController.text),
                      descrizionePastoController.text,
                      nomePastoController.text,
                      int.parse(quantitaController.text),
                      typeController.text,
                      DateTime.parse(dataPasti.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                      Constants.createSnackBar('Pasto creato correttamente.',
                          Constants.successSnackBar));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    Constants.createSnackBar(
                        'Pasto non creato. Uno o piu campi non validi.',
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

//   Widget showChildren() {
//     return FutureBuilder(
//       future: getUtenteSelected(utenteFut),
//       builder: (context, snapshot){
//         if ((snapshot.connectionState == ConnectionState.done)) {
//   //        mapWidgets["edit anagrafica"] = EditAnagraficaPage(utente: utente!);
//             return ListView.builder(
//                 itemCount: mapWidgets.length,
//                 itemBuilder: (context, index) {
//                   return _buildItem(context, index);
//                 });
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//       },
//     );
//   }
//   Widget _buildItem(BuildContext context, int index) {
//     String key = mapWidgets.keys.elementAt(index);
//     return TextButton(
//       style: ButtonStyle(
//         foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//       ),
//       onPressed: () { Constants.redirectTo(context, mapWidgets[key]! );},
//       child: Text(key),
//     );
//   }
//   void initializeMap() {
//     mapWidgets = {
//       'add anagrafica': AddAnagraficaPage(),
//       'view pasti del giorno': GetPastiGiornalieriPage(),
//       'get schede': GetSchedePalestraPage(),
//       'add scheda': AddSchedaPalestraPage(),
//       'get allenamenti':GetAllenamentiPage(),
//       'edit piano alimentare':EditPianoAlimentarePage(),
//       'add allenamento':AddAllenamentoPage(),
//       'add pasto giornaliero': AddPastoGiornaliero(),
//       'get piani alimentari': GetPianiAlimentari(),
// //      'edit anagrafica': EditAnagraficaPage(utente: utente!)
//     };
// }
}
