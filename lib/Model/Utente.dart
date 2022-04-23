// ignore_for_file: file_names, unnecessary_getters_setters

import 'AnagraficaUtente.dart';

class Utente {
  AnagraficaUtente? _anagraficaUtente;
  String? _email;
  String? _password;

  Utente(this._anagraficaUtente, this._email, this._password);

  Utente.fromJson(Map<String, dynamic> json) {
    _anagraficaUtente = json['anagraficaUtente'] != null
        ? AnagraficaUtente.fromJson(json['anagraficaUtente'])
        : null;
    _email = json['email'];
    _password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_anagraficaUtente != null) {
      data['anagraficaUtente'] = _anagraficaUtente?.toJson();
    }
    data['email'] = _email;
    data['password'] = _password;
    return data;
  }

  AnagraficaUtente? get anagraficaUtente => _anagraficaUtente;

  set anagraficaUtente(AnagraficaUtente? anagraficaUtente) =>
      _anagraficaUtente = anagraficaUtente;

  String? get email => _email;

  set email(String? email) => _email = email;

  String? get password => _password;

  set password(String? password) => _password = password;
}
