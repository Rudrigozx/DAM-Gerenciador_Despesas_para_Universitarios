import 'package:sqflite/sqflite.dart';
import '../../Models/Usuario.dart';
import '../services/DatabaseService.dart';

class UsuarioRepository {
  final dbService = DatabaseService();

  Future<int> cadastrarUsuario(Usuario usuario) async {
    final db = await dbService.database;
    return await db.insert('users', usuario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Usuario?> buscarPorId(int id) async {
    final db = await dbService.database;
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

  Future<Usuario?> buscarPorEmail(String email) async {
    final db = await dbService.database;
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

  Future<int> atualizarUsuario(Usuario usuario) async {
    final db = await dbService.database;
    return await db.update(
      'users',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => Usuario.fromMap(maps[i]));
  }
}