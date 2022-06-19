// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/Model/CategoriaPasto.dart';

import '../Utils/IdGenerator.dart';

class Pasto {
  String? _id;
  CategoriaPasto? _categoria;
  String? _nome;
  String? _descrizione;
  num? _calorie;
  // ora del giorno rappresenta l'orario esatto in cui hai aggiunto il pasto
  DateTime? _oraDelGiorno;
  // ora pasto rappresenta l'orario in cui consumare il pasto secondo il piano alimentare
  String? _oraPasto;
  // giorno pasto indica il giorno settimanale in cui consumare il pasto secondo il piano alimentare
  num? _giornoPasto;
  bool? _isMangiato;
  String? _type;
  num? _quantita;
  String? _idPianoAlimentare;
  String? _idUtente;

  Pasto(this._categoria, this._calorie, this._descrizione, this._nome,
      this._quantita, this._type, this._idUtente, [this._oraDelGiorno]){
    id = IdGenerator.generate();
    isMangiato = true;
    oraDelGiorno ??= DateTime.now();
  }

  Pasto.pianoAlimentare(this._categoria, this._calorie, this._descrizione, this._nome,
      this._oraPasto, this._giornoPasto, this._quantita, this._type, this._idPianoAlimentare){
    id = IdGenerator.generate();
    isMangiato = false;
  }

  Pasto.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? "";
    _calorie = json['calorie'];
    _categoria = CategoriaPasto.values.firstWhere((element) => element.name.contains(json['categoria'] ?? ""));
    _oraPasto = json['oraPasto'] ?? "";
    _giornoPasto = json['giorno'] ?? 0;
    _isMangiato = json['isMangiato'];
    _idPianoAlimentare = json['idPianoAlimentare'] ?? "";
    _descrizione = json['descrizione'] ?? "";
    _nome = json['nome'] ?? "";
    if(json['oraGiorno']!=null) {
      Timestamp oraFi = json['oraGiorno'];
      _oraDelGiorno = oraFi.toDate();
    }
    _quantita = json['quantita'];
    _type = json['tipo'] ?? "";
    _idUtente = json['idUtente'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id ?? "";
    data['calorie'] = _calorie?.toInt();
    data['categoria'] = _categoria.toString().split('.').last;
    data['oraPasto'] = _oraPasto ?? "";
    data['giorno'] = _giornoPasto?.toInt();
    data['isMangiato'] = _isMangiato;
    data['idPianoAlimentare'] = _idPianoAlimentare ?? "";
    data['descrizione'] = _descrizione ?? "";
    data['nome'] = _nome ?? "";
    if(_oraDelGiorno != null){
      Timestamp timestamp = Timestamp.fromDate(_oraDelGiorno!);
      data['oraGiorno'] = timestamp;
    }
    data['quantita'] = _quantita?.toInt();
    data['tipo'] = _type ?? "";
    data['idUtente'] = _idUtente ?? "";
    return data;
  }

  String? get idUtente => _idUtente;

  set idUtente(String? value) {
    _idUtente = value;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  CategoriaPasto? get categoria => _categoria;

  String? get nome => _nome;

  String? get descrizione => _descrizione;

  num? get calorie => _calorie;

  DateTime? get oraDelGiorno => _oraDelGiorno;

  String? get type => _type;

  num? get quantita => _quantita;

  String? get oraPasto => _oraPasto;

  num? get giornoPasto => _giornoPasto;

  bool? get isMangiato => _isMangiato;

  set isMangiato(bool? isMangiato) => _isMangiato = isMangiato;

  set oraPasto(String? ora) => _oraPasto = ora;

  set giornoPasto(num? giorno) => _giornoPasto = giorno;

  set categoria(CategoriaPasto? categoria) => _categoria = categoria;

  set nome(String? nome) => _nome = nome;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  set calorie(num? calorie) => _calorie = calorie;

  set oraDelGiorno(DateTime? ora) => _oraDelGiorno = ora;

  set type(String? type) => _type = type;

  set quantita(num? quantita) => _quantita = quantita;

  String? get pianoAlimentare => _idPianoAlimentare;

  set pianoAlimentare(String? value) {
    _idPianoAlimentare = value;
  }
}
