// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

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

  void addAllenamento(Allenamento allenamento) => _allenamenti.add(allenamento);

  void removeAllenamento(Allenamento allenamento) =>
      allenamenti.removeWhere((element) => element.id == allenamento.id);

}
