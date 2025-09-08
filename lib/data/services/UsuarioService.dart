import 'package:sqflite/sqflite.dart';
import '/data/services/DatabaseService.dart';
import '/Models/Usuario.dart';

class UsuarioService {
  final DatabaseService _dbService = DatabaseService();

  // Salva um novo usuário no banco de dados
  Future<void> cadastrarUsuario(Usuario usuario) async {
    final db = await _dbService.database;
    await db.insert(
      'users',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retorna a lista de todos os usuários do banco de dados
  Future<List<Usuario>> listarUsuarios() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }

  // Busca um usuário por email
  Future<Usuario?> buscarPorEmail(String email) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Busca um usuário por ID
  Future<Usuario?> buscarPorId(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Atualiza um usuário existente
  Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await _dbService.database;
    await db.update(
      'users',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  // Deleta um usuário
  Future<void> deletarUsuario(int id) async {
    final db = await _dbService.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
