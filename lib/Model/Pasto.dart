class Pasto {
  int _id = 0;
  Enum _categoria;
  String _nome;
  String _descrizione;
  int _calorie;
  DateTime _ora;
  String _type;
  int _quantita;

  Pasto(this._categoria, this._calorie, this._descrizione, this._nome,
      this._ora, this._quantita, this._type);

  int get id => _id;
  
  Enum get categoria => _categoria;

  String get nome => _nome;

  String get descrizione => _descrizione;

  int get calorie => _calorie;

  DateTime get ora => _ora;

  String get type => _type;

  int get quantita => _quantita;

  set categoria(Enum categoria) => _categoria = categoria;

  set nome(String nome) => _nome = nome;

  set descrizione(String descrizione) => _descrizione = descrizione;

  set ora(DateTime ora) => _ora = ora;

  set type(String type) => _type = type;

  set quantita(int quantita) => _quantita = quantita;

}
