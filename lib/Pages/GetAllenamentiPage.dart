import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Allenamento.dart';
import 'package:healthy_app/Model/SchedaPalestra.dart';
import 'package:healthy_app/Pages/EditSchedaPalestraPage.dart';
import 'package:healthy_app/Utils/GeoLocService.dart';
import 'package:intl/intl.dart';

import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/TopAppBar.dart';

class GetAllenamentiPage extends StatefulWidget {
  GetAllenamentiPage({Key? key}) : super(key: key);

  TextEditingController calorieConsumateController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController distanzaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController tempoPerKmController = TextEditingController();
  TextEditingController oraInizioController = TextEditingController();
  TextEditingController oraFineController = TextEditingController();
  TextEditingController tempoTotaleController = TextEditingController();
  TextEditingController velocitaMediaController = TextEditingController();

  Allenamento? allenamentoToView;

  @override
  _GetAllenamentiPage createState() => _GetAllenamentiPage();
}

class _GetAllenamentiPage extends State<GetAllenamentiPage> {
  String searchString = "";

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Allenamenti", Constants.controller),
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
                  Container(
                    child: showCards(),
                  )
                ]),
          )),
    );
  }

  Widget showCards() {
    return FutureBuilder(
      future: Constants.controller.getAllenamenti(),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          var d = (snapshot.data as List<Allenamento>).toList();
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
              else{
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

  Widget _buildItem(Allenamento? obj) {
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
                widget.allenamentoToView = obj,
                openViewAllenamento(context),
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
                          child: const Text('Rimuovi',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              Constants.controller.removeAllenamento(obj);
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

  void setFieldsAllenamento() {
    if(widget.allenamentoToView != null){
      widget.nomeController.text = widget.allenamentoToView!.nome!;
      widget.descrizioneController.text = widget.allenamentoToView!.descrizione!;
      widget.oraInizioController.text = widget.allenamentoToView!.oraInizio != null ?
        widget.allenamentoToView!.oraInizio.toString() : "";
      if(widget.allenamentoToView!.oraInizio != null){
        widget.oraFineController.text = widget.allenamentoToView!.oraFine.toString();
      }
      if(widget.allenamentoToView!.calorieConsumate != null){
        widget.calorieConsumateController.text = widget.allenamentoToView!.calorieConsumate.toString();
      }
      if(widget.allenamentoToView!.distanza != null){
        widget.distanzaController.text = widget.allenamentoToView!.distanza.toString();
      }
      if(widget.allenamentoToView!.tempoPerKm != null){
        widget.tempoPerKmController.text = widget.allenamentoToView!.tempoPerKm.toString();
      }
      if(widget.allenamentoToView!.tempoTotale != null){
        widget.tempoTotaleController.text = widget.allenamentoToView!.tempoTotale.toString();
      }
      if(widget.allenamentoToView!.velocitaMedia != null){
        widget.velocitaMediaController.text = widget.allenamentoToView!.velocitaMedia.toString();
      }
    }
  }

  Future openViewAllenamento(context) {
    setFieldsAllenamento();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(widget.allenamentoToView!.nome!),
        content: Column(children: [
          TextFormField(
            readOnly: true,
            controller: widget.nomeController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nome',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.descrizioneController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Descrizione',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.oraInizioController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Ora inizio',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.oraFineController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Ora fine',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.distanzaController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Distanza',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.calorieConsumateController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Calorie consumate',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.tempoPerKmController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Tempo per km',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.tempoTotaleController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Tempo totale',
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: widget.velocitaMediaController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Velocità media',
            ),
          ),
        ]),
        actions: [
          TextButton(
            child: const Text("Chiudi"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

}
