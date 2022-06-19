// ignore_for_file: file_names

import 'package:healthy_app/Model/Pasto.dart';

import '../AnagraficaUtente.dart';
import '../PianoAlimentare.dart';
import '../Utente.dart';

class GestoreUtente {
  final List<Utente> _utenti = List.empty(growable: true);
  final List<PianoAlimentare> _piani = List.empty(growable: true);
  final List<Pasto> _pastiOfDay = List.empty(growable: true);

  GestoreUtente._privateConstructor();

  static final instance = GestoreUtente._privateConstructor();

  List<Utente> get utenti => _utenti;

  List<PianoAlimentare> get piani => _piani;

  Utente createUtente(String id, AnagraficaUtente anagrafica, String email) =>
      Utente(id, anagrafica, email);

  AnagraficaUtente createAnagraficaUtente(int altezza, DateTime dataNascita,
          String nome, double peso, String sesso) =>
      AnagraficaUtente(altezza, dataNascita, nome, peso, sesso);

  addUtente(Utente utente) => _utenti.add(utente);

  removeUtente(Utente utente) => _utenti.remove(utente);

  PianoAlimentare createPianoAlimentare(DateTime dataFine, DateTime dataInizio,
          String descrizione, String idUtente) =>
      PianoAlimentare(dataFine, dataInizio, descrizione, idUtente);

  addPianoAlimentare(PianoAlimentare piano) => _piani.add(piano);

  removePianoAlimentare(PianoAlimentare piano) => _piani.removeWhere((element) => element.id == piano.id);

  List<Pasto> get pastiOfDay => _pastiOfDay;

  //aggiunta di un pasto fatto in un certo giorno e che potrebbe essere incluso nel piano come no.
  addPastoOfDay(Pasto pasto) {
    if(pasto.nome != "" && pastiOfDay.where((element) => element.nome == pasto.nome).isEmpty) {
      pastiOfDay.add(pasto);
    }
  }
}
