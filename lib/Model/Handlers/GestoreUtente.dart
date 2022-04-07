import '../AnagraficaUtente.dart';
import '../Utente.dart';

class GestoreUtente {
  List<Utente> _utenti = List.empty(growable: true);

  GestoreUtente();

  List<Utente> get utenti => this._utenti;

  Utente createUtente(
          AnagraficaUtente anagrafica, String email, String password) =>
      Utente(anagrafica, email, password);
}
