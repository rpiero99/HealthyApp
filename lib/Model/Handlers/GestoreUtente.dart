// ignore_for_file: file_names

import '../AnagraficaUtente.dart';
import '../Utente.dart';

class GestoreUtente {
  final List<Utente> _utenti = List.empty(growable: true);

  GestoreUtente._privateConstructor();
  static final instance = GestoreUtente._privateConstructor();

  List<Utente> get utenti => _utenti;

  Utente createUtente(
          AnagraficaUtente anagrafica, String email, String password) =>
      Utente(anagrafica, email, password);

  AnagraficaUtente createAnagraficaUtente(int altezza, DateTime dataNascita, String nome,  double peso, bool sesso)=>
    AnagraficaUtente(altezza, dataNascita, nome, peso, sesso);


  addUtente(Utente utente) {
    _utenti.add(utente);
  }

  removeUtente(Utente utente) {
    _utenti.remove(utente);
  }
}
