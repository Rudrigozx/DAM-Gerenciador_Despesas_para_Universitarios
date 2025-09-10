class Usuario {
  int? _id;
  String _nome;
  String _idade;
  String _email;
  String _senha;

  Usuario.comIdade(this._nome, this._idade, this._email, this._senha, [this._id]);

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario.comIdade(
      map['nome'],
      map['idade'],
      map['email'],
      map['senha'],
      map['id'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'idade': _idade,
      'email': _email,
      'senha': _senha,
      'id': _id,

    };
  }

  String get nome => _nome;
  set nome(String valor) {
    if (valor.isNotEmpty) {
      _nome = valor;
    } else {
      throw Exception("O nome não pode ser vazio.");
    }
  }

  String get email => _email;
  set email(String valor) {
    _email = valor;

  }

  String get senha => _senha;
  set senha(String valor) {
    _senha = valor;

  }

  int? get id => _id;
  set id(int? valor) {
      _id = valor;

  }

  String get idade => _idade;
  set idade(String valor) {
    _idade = valor;

  }

}
