import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/GetEserciziPage.dart';
import 'package:healthy_app/Utils/GeoLocService.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/TopAppBar.dart';

class GetSchedePalestraPage extends StatefulWidget {
  GetSchedePalestraPage({Key? key}) : super(key: key);

  TextEditingController nomeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController dataInizioController = TextEditingController();
  TextEditingController dataFineController = TextEditingController();

  SchedaPalestra? schedaToView;

  @override
  _GetSchedePalestraPage createState() => _GetSchedePalestraPage();
}

class _GetSchedePalestraPage extends State<GetSchedePalestraPage> {
  List<SchedaPalestra> allSchede = [];
  String searchString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Scheda Palestra", Constants.controller),
      body: SingleChildScrollView(
          child: SizedBox(
        child: Column(children: <Widget>[
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
          Container(
            child: showCards(),
          )
        ]),
      )),
    );
  }

  Future<List<SchedaPalestra>> getSchede() async {
    return await Constants.controller.getSchedePalestra(Constants.getCurrentIdUser()!);
  }

  Widget showCards() {
    return FutureBuilder(
      future: getSchede(),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<SchedaPalestra>).toList();
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
              } else {
                return _buildItem(d[index]);
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildItem(SchedaPalestra? obj) {
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
                widget.schedaToView = obj,
                openViewSchedaPalestra(context, false),
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
                            widget.schedaToView = obj;
                            openViewSchedaPalestra(context, true);
                          },
                        ),
                        TextButton(
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              Constants.controller.removeSchedaPalestra(obj);
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

  void setFieldsSchedaPalestra() {
    widget.nomeController.text = widget.schedaToView!.nome!;
    widget.descrizioneController.text = widget.schedaToView!.descrizione!;
    widget.dataInizioController.text =
        widget.schedaToView!.dataInizio!.toString();
    widget.dataFineController.text = widget.schedaToView!.dataFine!.toString();
  }

  Future openViewSchedaPalestra(context, isEdit) {
    setFieldsSchedaPalestra();
    String textEsercizi = isEdit ? "Modifica Esercizi" : "Visualizza Esercizi";
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(widget.schedaToView!.nome!),
        content: Column(children: [
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: widget.nomeController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
          TextFormField(
            readOnly: isEdit ? false : true,
            controller: widget.descrizioneController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Descrizione',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.dataInizioController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Data inizio',
            ),
            onTap: () async {
              if (isEdit) {
                DateTime? date = DateTime(DateTime.now().year);
                FocusScope.of(context).requestFocus(FocusNode());

                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                widget.dataInizioController.text = date.toString();
                //  "${date?.day}-${date?.month}-${date?.year}";
              }
            },
          ),
          TextFormField(
            readOnly: true,
            controller: widget.dataFineController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Data fine',
            ),
            onTap: () async {
              if (isEdit) {
                DateTime? date = DateTime(DateTime.now().year);
                FocusScope.of(context).requestFocus(FocusNode());

                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                widget.dataFineController.text = date.toString();
                // "${date?.day}-${date?.month}-${date?.year}";
              }
            },
          ),
        ]),
        actions: [
          isEdit
              ? TextButton(
                  child: const Text("Modifica"),
                  onPressed: () async {
                    if (widget.nomeController.text.isNotEmpty &&
                        widget.descrizioneController.text.isNotEmpty &&
                        DateTime.parse(widget.dataFineController.text).isAfter(
                            DateTime.parse(widget.dataInizioController.text))) {
                      setState(() {
                        widget.schedaToView?.nome = widget.nomeController.text;
                        widget.schedaToView?.descrizione =
                            widget.descrizioneController.text;
                        widget.schedaToView?.dataInizio =
                            DateTime.parse(widget.dataInizioController.text);
                        widget.schedaToView?.dataFine =
                            DateTime.parse(widget.dataFineController.text);
                        Constants.controller
                            .updateSchedaPalestra(widget.schedaToView!);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Scheda modificata correttamente.',
                                Constants.successSnackBar));
                        Navigator.pop(context);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          Constants.createSnackBar(
                              'Inserire tutti i dati o controllare che la data di fine sia dopo la data di inizio.',
                              Constants.errorSnackBar));
                    }
                  },
                )
              : TextButton(
                  child: const Text("Chiudi"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          TextButton(
            child: Text(textEsercizi),
            onPressed: () {
              Constants.redirectTo(
                  context, GetEserciziPage(scheda: widget.schedaToView!));
            },
          ),
        ],
      ),
    );
  }
}
