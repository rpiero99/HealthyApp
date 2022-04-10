import 'AnagraficaUtente.dart';

class Utente {
  int? _id = 0;
  AnagraficaUtente? _anagraficaUtente;
  String? _email;
  String? _password;

  Utente(this._anagraficaUtente, this._email, this._password);

  Utente.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _anagraficaUtente = json['anagraficaUtente'] != null
        ? AnagraficaUtente.fromJson(json['anagraficaUtente'])
        : null;
    _email = json['email'];
    _password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    if (_anagraficaUtente != null) {
      data['anagraficaUtente'] = _anagraficaUtente?.toJson();
    }
    data['email'] = _email;
    data['password'] = _password;
    return data;
  }

  int? get id => _id;

  AnagraficaUtente? get anagraficaUtente => _anagraficaUtente;

  set anagraficaUtente(AnagraficaUtente? anagraficaUtente) =>
      _anagraficaUtente = anagraficaUtente;

  String? get email => _email;

  set email(String? email) => _email = email;

  String? get password => _password;

  set password(String? password) => _password = password;
}
