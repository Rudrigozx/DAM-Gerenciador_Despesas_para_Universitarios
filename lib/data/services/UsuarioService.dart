import '/Models/Usuario.dart';

class UsuarioService {
  final List<Usuario> _usuarios = [];

  void cadastrarUsuario(Usuario usuario) {

    bool emailExistente =
    _usuarios.any((u) => u.email.toLowerCase() == usuario.email.toLowerCase());

    if (emailExistente) {
      throw Exception("Já existe um usuário com esse e-mail.");
    }

    _usuarios.add(usuario);
  }

  List<Usuario> listarUsuarios() {
    return List.unmodifiable(_usuarios);
  }

  Usuario? buscarPorEmail(String email) {
    return _usuarios.firstWhere(
          (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception("Usuário não encontrado."),
    );
  }
}
