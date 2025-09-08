import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../../data/services/NotificationService.dart';
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
      return 'A nome deve ter pelo menos 16 caracteres';
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

  String? cadastrar(String nome,String idade, String email, String senha, int id) {
    try {
      Usuario novoUsuario = Usuario(nome, idade, email, senha, id);
      _usuarioService.cadastrarUsuario(novoUsuario);
      notifyListeners();

      NotificationService.showNotification(
        title: 'Cadastro realizado',
        body: 'Usuário ${nome} foi cadastrado com sucesso!',
        type: "alerta",
      );

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao cadastrar usuário: $e");
        return e.toString();
      }
      return toString();
    }
  }


  List<Usuario> listarUsuarios() {
    return _usuarioService.listarUsuarios();
  }

  Usuario? buscarPorEmail(String email) {
    return _usuarioService.buscarPorEmail(email);
  }


  Usuario? buscarPorId(int id) {
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
