// ignore_for_file: file_names, unnecessary_getters_setters

class Pasto {
  int? _id = 0;
  Enum? _categoria;
  String? _nome;
  String? _descrizione;
  int? _calorie;
  DateTime? _ora;
  String? _type;
  int? _quantita;

  Pasto(this._categoria, this._calorie, this._descrizione, this._nome,
      this._ora, this._quantita, this._type);

  Pasto.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _calorie = json['calorie'];
    _categoria = json['categoria'];
    _descrizione = json['descrizione'];
    _nome = json['nome'];
    _ora = json['ora'];
    _quantita = json['quantita'];
    _type = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['calorie'] = _calorie;
    data['categoria'] = _categoria;
    data['descrizione'] = _descrizione;
    data['nome'] = _nome;
    data['ora'] = _ora;
    data['quantita'] = _quantita;
    data['tipo'] = _type;
    return data;
  }

  int? get id => _id;

  Enum? get categoria => _categoria;

  String? get nome => _nome;

  String? get descrizione => _descrizione;

  int? get calorie => _calorie;

  DateTime? get ora => _ora;

  String? get type => _type;

  int? get quantita => _quantita;

  set categoria(Enum? categoria) => _categoria = categoria;

  set nome(String? nome) => _nome = nome;

  set descrizione(String? descrizione) => _descrizione = descrizione;

  set ora(DateTime? ora) => _ora = ora;

  set type(String? type) => _type = type;

  set quantita(int? quantita) => _quantita = quantita;
}
