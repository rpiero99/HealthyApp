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

  addUtente(Utente utente) {
    _utenti.add(utente);
  }

  removeUtente(Utente utente) {
    _utenti.remove(utente);
  }
}
