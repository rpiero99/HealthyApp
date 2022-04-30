// ignore_for_file: file_names, unnecessary_getters_setters

import '../Utils/IdGenerator.dart';
import 'AnagraficaUtente.dart';

class Utente {
  String? _id;
  AnagraficaUtente? _anagraficaUtente;
  String? _email;

  Utente(this._anagraficaUtente, this._email){
    id = IdGenerator.generate();
  }

  Utente.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? "";
    _anagraficaUtente = json['anagraficaUtente'] != null
        ? AnagraficaUtente.fromJson(json['anagraficaUtente'])
        : null;
    _email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id ?? "";
    if (_anagraficaUtente != null) {
      data['anagraficaUtente'] = _anagraficaUtente?.toJson();
    }
    data['email'] = _email;
    return data;
  }

  String? get id => _id;

  set id(String? id) => _id = id;

  AnagraficaUtente? get anagraficaUtente => _anagraficaUtente;

  set anagraficaUtente(AnagraficaUtente? anagraficaUtente) =>
      _anagraficaUtente = anagraficaUtente;

  String? get email => _email;

  set email(String? email) => _email = email;
}
