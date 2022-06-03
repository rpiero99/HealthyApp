import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Pasto.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/EditSchedaPalestraPage.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import 'EditPastoGiornalieroPage.dart';
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
  TextEditingController dataPasti = TextEditingController();

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
          makeInput(
            label:
                "Selezionare una data per vedere cos'hai mangiato quel giorno",
            obscureText: false,
            controller: dataPasti,
            isDate: true,
            context: context,
          ),
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
          Container(
            child: showCards(),
          )
        ]),
      ),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future:
          Constants.controller.getPastiOfDay(DateTime.parse(dataPasti.text)),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Pasto>);
          if (d != null) {
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
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
        return Divider();
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
              onTap: () => {},
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
                            Constants.redirectTo(
                                context, EditPastoGiornalieroPage(pasto: obj));
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
}
