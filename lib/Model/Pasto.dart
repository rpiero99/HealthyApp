// ignore_for_file: file_names, unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utils/IdGenerator.dart';

class Pasto {
  String? _id;
  Enum? _categoria;
  String? _nome;
  String? _descrizione;
  num? _calorie;
  // ora del giorno rappresenta l'orario esatto in cui hai aggiunto il pasto
  DateTime? _oraDelGiorno;
  // ora pasto rappresenta l'orario in cui consumare il pasto secondo il piano alimentare
  num? _oraPasto;
  // giorno pasto indica il giorno settimanale in cui consumare il pasto secondo il piano alimentare
  num? _giornoPasto;
  bool? _isMangiato;
  String? _type;
  num? _quantita;

  Pasto(this._categoria, this._calorie, this._descrizione, this._nome,
      this._quantita, this._type){
    id = IdGenerator.generate();
    isMangiato = true;
    oraDelGiorno = DateTime.now();
  }

  Pasto.pianoAlimentare(this._categoria, this._calorie, this._descrizione, this._nome,
      this._oraPasto, this._giornoPasto, this._quantita, this._type){
    id = IdGenerator.generate();
    isMangiato = false;
  }

  Pasto.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? "";
    _calorie = json['calorie'];
    _categoria = json['categoria'];
    _oraPasto = _oraPasto != null ? json['oraPasto'] : 0;
    _giornoPasto = _giornoPasto != null ? json['giorno'] : 0;
    _isMangiato = json['isMangiato'];
    _descrizione = json['descrizione'] ?? "";
    _nome = json['nome'] ?? "";
    if(json['oraGiorno']!=null) {
      Timestamp oraFi = json['oraGiorno'];
      _oraDelGiorno = oraFi.toDate();
    }
    _quantita = json['quantita'];
    _type = json['tipo'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id ?? "";
    data['calorie'] = _calorie?.toInt();
    data['categoria'] = _categoria;
    data['oraPasto'] = _oraPasto?.toInt();
    data['giorno'] = _giornoPasto?.toInt();
    data['isMangiato'] = _isMangiato;
    data['descrizione'] = _descrizione ?? "";
    data['nome'] = _nome ?? "";
    if(_oraDelGiorno != null){
      Timestamp timestamp = Timestamp.fromDate(_oraDelGiorno!);
      data['oraGiorno'] = timestamp;
    }
    data['quantita'] = _quantita?.toInt();
    data['tipo'] = _type ?? "";
    return data;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  Enum? get categoria => _categoria;

  String? get nome => _nome;

  String? get descrizione => _descrizione;

  num? get calorie => _calorie;

  DateTime? get oraDelGiorno => _oraDelGiorno = null;

  String? get type => _type;

  num? get quantita => _quantita;

  num? get oraPasto => _oraPasto;

  num? get giornoPasto => _giornoPasto;

  bool? get isMangiato => _isMangiato;

  set isMangiato(bool? isMangiato) => _isMangiato = isMangiato;

  set oraPasto(num? ora) => _oraPasto = ora;

  set giornoPasto(num? giorno) => _giornoPasto = giorno;

  set categoria(Enum? categoria) => _categoria = categoria;

  set nome(String? nome) => _nome = nome;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  set oraDelGiorno(DateTime? ora) => _oraDelGiorno = ora;

  set type(String? type) => _type = type;

  set quantita(num? quantita) => _quantita = quantita;
}
