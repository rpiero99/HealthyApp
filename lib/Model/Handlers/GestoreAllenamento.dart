import 'dart:ffi';

import '../Allenamento.dart';

class GestoreAllenamento {
  final List<Allenamento> _allenamenti = List.empty(growable: true);

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
      Float velocitaMedia) {
    return Allenamento(calorieConsumate, descrizione, distanza, image, nome,
        oraInizio, oraFine, tempoPerKm, tempoTotale, velocitaMedia);
  }
  List<Allenamento> get allenamenti => _allenamenti;



  void scheduleAllenamenti() {}
}
