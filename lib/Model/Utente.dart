import 'AnagraficaUtente.dart';

class Utente {
  int _id = 0;
  AnagraficaUtente _anagraficaUtente;
  String _email;
  String _password;

  Utente(this._anagraficaUtente, this._email, this._password);

  int get id => _id;
  
  AnagraficaUtente get anagraficaUtente => this._anagraficaUtente;

  set anagraficaUtente(AnagraficaUtente anagraficaUtente) =>
      this._anagraficaUtente = anagraficaUtente;

  String get email => this._email;

  set email(String email) => this._email = email;

  String get password => this._password;

  set password(String password) => this._password = password;
}
