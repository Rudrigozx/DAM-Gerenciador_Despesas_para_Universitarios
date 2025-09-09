class Usuario {
  String _nome;
  String _email;
  String _senha;
  int _id;


  Usuario(this._nome, this._email, this._senha, this._id);


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
    if (valor.contains("@")) {
      _email = valor;
    } else {
      throw Exception("E-mail inválido.");
    }
  }

  String get senha => _senha;
  set senha(String valor) {
    if (valor.length >= 6) {
      _senha = valor;
    } else {
      throw Exception("A senha deve ter pelo menos 6 caracteres.");
    }
  }

  int get id => _id;
  set id(int valor) {
    if (valor >= 0) {
      _id = valor;
    } else {
      throw Exception("Id inválido.");
    }
  }

}