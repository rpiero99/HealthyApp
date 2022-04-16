// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:flutter_icons/flutter_icons.dart';

import 'CronometroProgrammabile.dart';
import 'Esercizio.dart';

class SchedaPalestra {
  int? _id = 0;
  String? _name;
  String? _descrizione;
  final Map<int, List<Esercizio>> _mapEserciziOfDay = <int, List<Esercizio>>{};
  DateTime? _dataInizio;
  DateTime? _dataFine;

  SchedaPalestra(this._descrizione, this._name, this._dataInizio, this._dataFine){
    for(int i = 1; i<8; i++){
      _mapEserciziOfDay[i] = List.empty(growable: true);
    }
  }

  SchedaPalestra.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    // if (json['esercizi'] != null) {
    //   _esercizi = <Esercizio>[];
    //   json['esercizi'].forEach((p) {
    //     _esercizi.add(Esercizio.fromJson(p));
    //   });
   // }
    _name = json['nome'];
    _descrizione = json['descrizione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
  //  data['esercizi'] = _esercizi.map((v) => v?.toJson()).toList();
    data['nome'] = _name;
    data['descrizione'] = _descrizione;
    return data;
  }

  int? get id => _id;

  Esercizio createEsercizio(CronometroProgrammabile cronometro, String descrizione, String image, String nome, int numeroSerie, int numeroRipetizioni, int tempoRiposo) =>
      Esercizio(cronometro, descrizione, image, nome, numeroSerie, numeroRipetizioni, tempoRiposo);

  addEsercizio(Esercizio? esercizio, int day) {
    _mapEserciziOfDay[day]?.add(esercizio!);
  }

  removeEsercizio(Esercizio? esercizio, int day){
    getEserciziFromDay(day)?.remove(esercizio);
  }

  updateEsercizio(Esercizio? esercizio, int day){
    removeEsercizio(getEsercizioFromName(esercizio?.nome), day);
    addEsercizio(esercizio, day);
  }

  String? get nome => _name;

  set nome(String? nome) => _name = nome;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  DateTime? get dataInizio => _dataInizio;

  set dataInizio(DateTime? dateTime) => _dataInizio = dateTime;

  DateTime? get dataFine => _dataFine;

  set dataFine(DateTime? dateTime) => _dataFine = dateTime;

  Esercizio? getEsercizioFromName(String? name){
    return filterEsercizi((element) => (element).nome == name).first;
  }

  List<Esercizio>? getEserciziFromDay(int day){
    return _mapEserciziOfDay[day];
  }

  List<Esercizio> getAllEsercizi(){
    List<Esercizio>? toReturn = List.empty(growable: true);
    for(int i = 1; i<8; i++){
      getEserciziFromDay(i)?.forEach((element) {if(!toReturn.contains(element)) toReturn.add(element);});
    }
    return toReturn;
  }

  List<Esercizio> filterEsercizi(bool Function(Esercizio) filter){
    List<Esercizio> toReturn = List.empty(growable: true);
      for(var element in _mapEserciziOfDay.values) {
        for(Esercizio item in element){
          if (filter(item)) {
            toReturn.add(item);
          }
        }
      }
    return toReturn;
  }
}
