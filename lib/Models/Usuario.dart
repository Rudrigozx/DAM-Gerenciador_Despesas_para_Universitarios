class Usuario {
  String _nome;
  String _idade;
  String _email;
  String _senha;
  int _id;


  Usuario(this._nome, this._idade, this._email, this._senha, this._id);

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
    /*if (valor.contains("@")) {
      _email = valor;
    } else {
      throw Exception("E-mail inválido.");
    }*/
  }

  String get senha => _senha;
  set senha(String valor) {
    _senha = valor;
    /*if (valor.length >= 6) {
      _senha = valor;
    } else {
      throw Exception("A senha deve ter pelo menos 6 caracteres.");
    }*/
  }

  int get id => _id;
  set id(int valor) {
    if (valor >= 0) {
      _id = valor;
    } else {
      throw Exception("Id inválido.");
    }
  }

  String get idade => _idade;
  set idade(String valor) {
    _idade = valor;
    /*if (valor >= 0) {
      _idade = valor;
    } else {
      throw Exception("Idade inválida.");
    }*/
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': _nome,
      'idade': _idade,
      'email': _email,
      'senha': _senha,
    };
  }

  // Método de fábrica para criar um objeto Usuario a partir de um Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      map['nome'],
      map['idade'],
      map['email'],
      map['senha'],
      map['id'],
    );
  }
}

