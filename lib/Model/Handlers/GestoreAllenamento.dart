// ignore_for_file: file_names

import 'dart:ffi';

import '../Allenamento.dart';

class GestoreAllenamento {
  final List<Allenamento> _allenamenti = List.empty(growable: true);
  GestoreAllenamento._privateConstructor();
  static final instance = GestoreAllenamento._privateConstructor();

  Allenamento createAllenamento(
      String descrizione,
      String nome) {
    return Allenamento(descrizione, nome);
  }

  List<Allenamento> get allenamenti => _allenamenti;

  void addAllenamento(Allenamento allenamento) => allenamenti.add(allenamento);

  void removeAllenamento(Allenamento allenamento) =>
      allenamenti.remove(allenamento);

  void scheduleAllenamenti() {}
}
