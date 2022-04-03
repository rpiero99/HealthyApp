import 'dart:ffi';

import '../Allenamento.dart';

class GestoreAllenamento {
  List<Allenamento> _allenamenti = new List.empty(growable: true);

  GestoreAllenamento();

  Allenamento createAllenamento(
          int calorieConsumate,
          String descrizione,
          Float distanza,
          String image,
          String nome,
          DateTime oraInizio,
          DateTime oraFine,
          DateTime tempoPerKm,
          DateTime tempoTotale,
          Float velocitaMedia) =>
      new Allenamento(calorieConsumate, descrizione, distanza, image, nome,
          oraInizio, oraFine, tempoPerKm, tempoTotale, velocitaMedia);

  List<Allenamento> get allenamenti => this._allenamenti;

  void scheduleAllenamenti() {}
}
