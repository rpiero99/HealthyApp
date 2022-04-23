// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/Utils/MapEserciziDay.dart';

import 'CronometroProgrammabile.dart';
import 'Esercizio.dart';

class SchedaPalestra {
  String? _name;
  String? _descrizione;
  List<MapEserciziDay>? _map;
  DateTime? _dataInizio;
  DateTime? _dataFine;

  SchedaPalestra(this._descrizione, this._name, this._dataInizio, this._dataFine){
    for(num i = 1; i<8; i++){
     _map?.add(MapEserciziDay(i));
    }
  }

  SchedaPalestra.fromJson(Map<String, dynamic> json) {
    if (json['eserciziOfDay'] != null) {
      _map = <MapEserciziDay>[];
      json['eserciziOfDay'].forEach((v) {
        _map!.add(MapEserciziDay.fromJson(v));
      });
    }
    _name = json['nome'] ?? "";
    _descrizione = json['descrizione'] ?? "";
    if(json['dataInizio']!=null){
      Timestamp oraIn = json['dataInizio'];
      dataInizio = oraIn.toDate();
    }
    if(json['dataFine']!=null){
      Timestamp oraIn = json['dataFine'];
      dataFine = oraIn.toDate();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_map != null) {
      data['eserciziOfDay'] = _map!.map((v) => v.toJson()).toList();
    }
    data['nome'] = _name;
    data['descrizione'] = _descrizione;
    if(dataInizio == null){
      Timestamp timestamp = Timestamp.fromDate(dataInizio!);
      data['dataInizio'] = timestamp;
    }
    if(dataFine == null){
      Timestamp timestamp = Timestamp.fromDate(dataFine!);
      data['dataFine'] = timestamp;
    }
    return data;
  }

  Esercizio createEsercizio(CronometroProgrammabile cronometro, String descrizione, String image, String nome, int numeroSerie, int numeroRipetizioni, int tempoRiposo) =>
      Esercizio(cronometro, descrizione, nome, numeroSerie, numeroRipetizioni, tempoRiposo);

  addEsercizio(Esercizio? esercizio, int? day) {
    _map?[day!].addEsercizio(esercizio!);
  }

  removeEsercizio(Esercizio? esercizio, int? day){
    _map?[day!].removeEsercizio(esercizio!);
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
    return _map?[day].eserciziOfDay;
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
      for(var element in _map!) {
        for(Esercizio item in element.eserciziOfDay){
          if (filter(item)) {
            toReturn.add(item);
          }
        }
      }
    return toReturn;
  }
}
