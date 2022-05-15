// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/Utils/IdGenerator.dart';
import 'package:healthy_app/Utils/MapEserciziDay.dart';

import 'CronometroProgrammabile.dart';
import 'Esercizio.dart';

class SchedaPalestra {
  String? _id;
  String? _name;
  String? _descrizione;
  List<Esercizio>? _esercizi;
  DateTime? _dataInizio;
  DateTime? _dataFine;
  String? _idUtente;

  SchedaPalestra(this._descrizione, this._name, this._dataInizio, this._dataFine, this._idUtente){
    id = IdGenerator.generate();
    _esercizi = List.empty(growable: true);
  }

  SchedaPalestra.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? "";
    if (json['esercizi'] != [] && json['esercizi'] != null) {
      _esercizi = <Esercizio>[];
      json['esercizi'].forEach((v) {
        _esercizi!.add(Esercizio.fromJson(v));
      });
    }
    _idUtente = json['idUtente'] ?? "";
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
    data['id'] = _id ?? "";
    if (_esercizi != null) {
      data['esercizi'] = _esercizi!.map((v) => v.toJson()).toList();
    }
    data['nome'] = _name ?? "";
    data['descrizione'] = _descrizione ?? "";
    if(dataInizio != null){
      Timestamp timestamp = Timestamp.fromDate(dataInizio!);
      data['dataInizio'] = timestamp;
    }
    data['idUtente'] = _idUtente ?? "";
    if(dataFine != null){
      Timestamp timestamp = Timestamp.fromDate(dataFine!);
      data['dataFine'] = timestamp;
    }
    return data;
  }

  Esercizio createEsercizio(String descrizione, String nome, int numeroSerie, int numeroRipetizioni, int tempoRiposo, int day) =>
      Esercizio(descrizione, nome, numeroSerie, numeroRipetizioni, tempoRiposo, day, id);

  addEsercizio(Esercizio? esercizio) {
    _esercizi?.add(esercizio!);
  }

  removeEsercizio(Esercizio? esercizio){
    _esercizi?.remove(esercizio);
  }

  updateEsercizio(Esercizio? esercizio){
    removeEsercizio(getEsercizioFromName(esercizio?.nome));
    addEsercizio(esercizio);
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  String? get nome => _name;

  set nome(String? nome) => _name = nome;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  DateTime? get dataInizio => _dataInizio;

  set dataInizio(DateTime? dateTime) => _dataInizio = dateTime;

  DateTime? get dataFine => _dataFine;

  set dataFine(DateTime? dateTime) => _dataFine = dateTime;

  String? get idUtente => _idUtente;

  set idUtente(String? value) {
    _idUtente = value;
  }

  Esercizio? getEsercizioFromName(String? name){
    return filterEsercizi((element) => (element).nome == name).first;
  }

  List<Esercizio>? getEserciziFromDay(int day){
    return filterEsercizi((e) => e.day == day);
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
      for(var item in _esercizi!) {
          if (filter(item)) {
            toReturn.add(item);
          }
      }
    return toReturn;
  }
}
