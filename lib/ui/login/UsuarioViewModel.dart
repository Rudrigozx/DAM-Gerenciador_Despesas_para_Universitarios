// Refatorado para usar UsuarioRepository
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '/data/services/NotificationService.dart';
import '/data/repositories/UsuarioRepository.dart'; // Importe o novo repositório
import '/Models/Usuario.dart';

class UsuarioViewModel extends ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  final UsuarioRepository _usuarioRepository = UsuarioRepository(); // Use o repositório

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
      Usuario novoUsuario = Usuario.comIdade(nome, idade, email, senha);
      await _usuarioRepository.cadastrarUsuario(novoUsuario); // Chame o método do repositório
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

  // Atualize o método para buscar a lista do repositório
  Future<List<Usuario>> listarUsuarios() async {
    return _usuarioRepository.listarUsuarios();
  }

  // Atualize o método para buscar no repositório
  Future<Usuario?> buscarPorEmail(String email) async {
    return _usuarioRepository.buscarPorEmail(email);
  }

  // Atualize o método para buscar no repositório
  Future<Usuario?> buscarPorId(int id) async {
    return _usuarioRepository.buscarPorId(id);
  }

  void atualizarUsuario(String nome, String idade, String email, String senha) {
    if (_usuario != null) {
      _usuario!.nome = nome;
      _usuario!.idade = idade;
      _usuario!.email = email;
      _usuario!.senha = senha;
      _usuarioRepository.atualizarUsuario(_usuario!); // Chame o método de atualização do repositório
    }
    notifyListeners();
  }
}