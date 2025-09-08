import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '/data/services/NotificationService.dart';
import '/data/services/UsuarioService.dart';
import '/Models/Usuario.dart';

class UsuarioViewModel extends ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  final UsuarioService _usuarioService = UsuarioService();

  String? validarEmail (value){
    if (value == null || value.isEmpty) {
      return 'O campo e-mail é obrigatório';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validaSenha(value){
    if (value == null || value.isEmpty) {
      return 'O campo senha é obrigatório';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? validaNome(value){
    if (value == null || value.isEmpty) {
      return 'O campo nome é obrigatório';
    }
    if (value.length < 16) {
      return 'O nome deve ter pelo menos 16 caracteres';
    }
    return null;
  }

  String? validaIdade(value){
    if (value == null || value.isEmpty) {
      return 'O campo idade é obrigatório';
    }
    if (value.length > 2) {
      return 'Idade > que 100';
    }
    return null;
  }

  Future<String?> cadastrar(String nome, String idade, String email, String senha) async {
    try {
      // O ID será gerado pelo banco de dados, então não é necessário passá-lo aqui
      Usuario novoUsuario = Usuario.comIdade(nome, idade, email, senha);
      await _usuarioService.cadastrarUsuario(novoUsuario);
      notifyListeners();

      NotificationService.showNotification(
        title: 'Cadastro realizado',
        body: 'Usuário $nome foi cadastrado com sucesso!',
        type: "alerta",
      );

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao cadastrar usuário: $e");
        return e.toString();
      }
      return 'Erro desconhecido ao cadastrar usuário.';
    }
  }

  /* void logar(String email){
    bool emailExistente =
    _usuarios.any((u) => u.email.toLowerCase() == usuario.email.toLowerCase());

    if (emailExistente) {
      throw Exception("Já existe um usuário com esse e-mail.");
    }
  }*/

  // Atualize o método para buscar a lista do banco de dados
  Future<List<Usuario>> listarUsuarios() async {
    return _usuarioService.listarUsuarios();
  }

  // Atualize o método para buscar no banco de dados
  Future<Usuario?> buscarPorEmail(String email) async {
    return _usuarioService.buscarPorEmail(email);
  }

  // Atualize o método para buscar no banco de dados
  Future<Usuario?> buscarPorId(int id) async {
    return _usuarioService.buscarPorId(id);
  }

  void atualizarUsuario(String nome, String idade, String email, String senha) {
    if (_usuario != null) {
      _usuario!.nome = nome;
      _usuario!.idade = idade;
      _usuario!.email = email;
      _usuario!.senha = senha;
    }
    // Notifique a UI sobre a alteração
    notifyListeners();
  }

}
