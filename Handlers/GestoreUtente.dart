import '../AnagraficaUtente.dart';
import '../Utente.dart';

class GestoreUtente {
  List<Utente> _utenti = new List.empty(growable: true);

  GestoreUtente();

  List<Utente> get utenti => this._utenti;

  Utente createUtente(
          AnagraficaUtente anagrafica, String email, String password) =>
      new Utente(anagrafica, email, password);
}
