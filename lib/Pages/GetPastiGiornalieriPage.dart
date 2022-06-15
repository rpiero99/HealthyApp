import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Pasto.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';
import 'Widgets/TopAppBar.dart';

class GetPastiGiornalieriPage extends StatefulWidget {
  const GetPastiGiornalieriPage({Key? key}) : super(key: key);

  @override
  _GetPastiGiornalieriPage createState() => _GetPastiGiornalieriPage();
}

class _GetPastiGiornalieriPage extends State<GetPastiGiornalieriPage> {
  List<Pasto> allPastiOfDay = [];
  String searchString = "";
  Pasto? pastoToView;
  String categoriaItem = Constants.categoriePasto[0];
  TextEditingController dataPasti = TextEditingController();
  TextEditingController calorieController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController descrizionePastoController = TextEditingController();
  TextEditingController nomePastoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    dataPasti.text = formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Pasti Giornalieri", Constants.controller),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
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
                padding: EdgeInsets.only(right: 8, left: MediaQuery.of(context).size.width/4),
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
          Container(
            child: showCards(),
          )
        ]),
      ),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: Constants.controller.getPastiOfDay(DateTime.parse(dataPasti.text)),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Pasto>).toList();
          if (d != null && d.isNotEmpty) {
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
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        return const Divider();
      },
    );
  }

  Widget _buildItem(Pasto? obj) {
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
                pastoToView = obj,
                openViewPasto(context, false),
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.fastfood_outlined, size: 100),
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
                            pastoToView = obj;
                            openViewPasto(context, true);
                            //todo -
                            // Constants.redirectTo(
                            //     context, EditPastoGiornalieroPage(pasto: obj));
                          },
                        ),
                        TextButton(
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              Constants.controller.removePastoGiornaliero(obj);
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

  void setFieldsPasto(){
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
                        if(isEdit){
                          dropDownState(() {
                            categoriaItem = (value as String?)!;
                            categoriaController.text = categoriaItem;
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
                  pastoToView!.nome =
                      nomePastoController.text;
                  pastoToView!.descrizione =
                      descrizionePastoController.text;
                  pastoToView!.quantita =
                      int.parse(quantitaController.text);
                  pastoToView!.calorie =
                      int.parse(calorieController.text);
                  pastoToView!.type = typeController.text;
                  pastoToView!.categoria = Constants.getCategoriaFromString(categoriaController.text);
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
}
