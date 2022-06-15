import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Handlers/GestoreAuth.dart';
import 'package:healthy_app/Pages/AddAllenamentoPage.dart';
import 'package:healthy_app/Pages/AddAnagraficaPage.dart';
import 'package:healthy_app/Pages/AddPastoGiornaliero.dart';
import 'package:healthy_app/Pages/AddSchedaPalestraPage.dart';
import 'package:healthy_app/Pages/DashBoard.dart';
import 'package:healthy_app/Pages/EditAnagraficaPage.dart';
import 'package:healthy_app/Pages/GetAllenamentiPage.dart';
import 'package:healthy_app/Pages/GetPastiGiornalieriPage.dart';
import 'package:healthy_app/Pages/GetPianiAlimentari.dart';
import 'package:healthy_app/Pages/GetSchedePalestraPage.dart';
import 'package:healthy_app/Pages/AddPianoAlimentarePage.dart';
import 'package:healthy_app/Pages/Widgets/BottomAppBar.dart';
import 'package:intl/intl.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/Allenamento.dart';
import '../Model/Pasto.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'Widgets/TopAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchString = "";
  Pasto? pastoToView;
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

  Future<Utente?> utenteFut = Constants.controller
      .getUtenteByEmail((FirebaseAuth.instance.currentUser?.email)!);
  Utente? utente;

  Future<void> getUtenteSelected(Future<Utente?> utenteFuture) async {
    utente = await utenteFuture;
  }

  Map<String, Widget> mapWidgets = <String, Widget>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      body: Column(
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
                        //todo - data pasti e giorno dell esercizio della scheda corrente.
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
        ],
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

  Widget showCards() {
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

  Widget _buildItem(Pasto? obj) {
    if (obj != null) {
      return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.blueGrey,
          elevation: 10,
          child: GestureDetector(
              onTap: () => {
                //todo
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
                            //todo
                          },
                        ),
                        TextButton(
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              //todo
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
