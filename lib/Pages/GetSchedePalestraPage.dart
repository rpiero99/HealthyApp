import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/EditPageSchedaPalestra.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/TopAppBar.dart';

class GetSchedePalestraPage extends StatefulWidget {
  const GetSchedePalestraPage({Key? key}) : super(key: key);

  @override
  _GetSchedePalestraPage createState() => _GetSchedePalestraPage();
}

class _GetSchedePalestraPage extends State<GetSchedePalestraPage> {
  List<SchedaPalestra> allSchede = [];
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Scheda Palestra", Constants.controller),
      body: SingleChildScrollView(
          child: SizedBox(
              child: Column(
                  children: <Widget>[
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
            )),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: Constants.controller.getSchedePalestra(),
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
                            Constants.redirectTo(
                                context,
                                EditSchedaPalestraPage(
                                    id: obj.id!,
                                    nome: obj.nome!,
                                    descrizione: obj.descrizione!,
                                    dataInizio: obj.dataInizio!,
                                    dataFine: obj.dataFine!));
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
}
