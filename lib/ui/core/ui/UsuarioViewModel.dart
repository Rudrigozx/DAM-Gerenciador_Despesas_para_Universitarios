import '/data/services/UsuarioService.dart';
import '/Models/Usuario.dart';

class UsuarioViewModel {
  final UsuarioService _usuarioService = UsuarioService();

  UsuarioViewModel();

  String? validarEmail (value){
    if (value == null || value.isEmpty) {
      return 'O campo e-mail é obrigatório';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String cadastrar(String nome, String email, String senha, int id) {
    try {
      Usuario novoUsuario = Usuario(nome, email, senha, id);
      _usuarioService.cadastrarUsuario(novoUsuario);
      return "Usuário cadastrado com sucesso!";
    } catch (e) {
      return e.toString();
    }
  }

  List<Usuario> listarUsuarios() {
    return _usuarioService.listarUsuarios();
  }

  Usuario? buscarPorEmail(String email) {
    return _usuarioService.buscarPorEmail(email);
  }
}
