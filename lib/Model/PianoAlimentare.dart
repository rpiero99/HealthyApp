// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';

import '../Utils/IdGenerator.dart';
import 'Pasto.dart';
import 'Utente.dart';

class PianoAlimentare {
  String? _id;
  String? _nome;
  List<Pasto?> _pasti = List.empty(growable: true);
  DateTime? _dataInizio;
  DateTime? _dataFine;
  String? _idUtente;
  Utente? _utente;
  String? _descrizione;

  PianoAlimentare(this._nome, this._dataFine, this._dataInizio, this._descrizione, this._idUtente){
    id = IdGenerator.generate();
  }

  PianoAlimentare.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? "";
    _nome = json['nome'] ?? "";
    if (json['pasti'] != null) {
      _pasti = <Pasto>[];
    }
    if(json['dataInizio']!=null){
      Timestamp oraFi = json['dataInizio'];
      _dataInizio = oraFi.toDate();
    }
    _descrizione = json['descrizione'] ?? "";
    if(json['dataFine']!=null){
      Timestamp oraFi = json['dataFine'];
      _dataFine = oraFi.toDate();
    }
    _idUtente = json['idUtente'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id ?? "";
    data['nome'] = _nome ?? "";
    data['pasti'] = _pasti.map((v) => v?.toJson()).toList();
    if(_dataInizio != null){
      Timestamp timestamp = Timestamp.fromDate(_dataInizio!);
      data['dataInizio'] = timestamp;
    }
    data['descrizione'] = _descrizione ?? "";
    if(dataFine != null){
      Timestamp timestamp = Timestamp.fromDate(dataFine!);
      data['dataFine'] = timestamp;
    }
    data['idUtente'] = _idUtente ?? "";
    return data;
  }

  Pasto createPasto(CategoriaPasto categoria, int calorie, String descrizione,
      String nome, String oraPasto, int giornoPasto,  int quantita, String type) {
    return Pasto.pianoAlimentare(categoria, calorie, descrizione, nome, oraPasto, giornoPasto, quantita, type, id);
  }

  void addPasto(Pasto? pasto) {
    if(pasto?.nome != "" && _pasti.where((element) => element!.nome == pasto!.nome).isEmpty) {
      _pasti.add(pasto);
    }
  }

  void removePasto(Pasto? pasto) => _pasti.removeWhere((element) => element?.id == pasto?.id);

  String? get id => _id;

  set id(String? id) => _id = id;

  String? get nome => _nome;

  set nome(String? value) {
    _nome = value;
  }

  DateTime? get dataInizio => _dataInizio;

  set dataInizio(DateTime? dataInizio) => _dataInizio = dataInizio;

  DateTime  ? get dataFine => _dataFine;

  set dataFine(DateTime? dataFine) => _dataFine = dataFine;

  String? get descrizione => _descrizione;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  String? get idUtente => _idUtente;

  set idUtente(String? idNew) => _idUtente = idNew;

  List<Pasto?> get pasti => _pasti;

  List<Pasto?> getPastiFromDayWeek(DateTime timestamp){
    List<Pasto?> toReturn = List.empty(growable: true);
   for (Pasto? element in pasti) {
      if(element?.oraDelGiorno?.weekday == timestamp.weekday)toReturn.add(element);}
   return toReturn;
  }
}
