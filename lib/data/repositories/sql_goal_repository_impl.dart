import 'package:fin_plus/data/repositories/goal_repository.dart';
import 'package:fin_plus/data/services/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/models/goal_model.dart';


class SqlGoalRepositoryImpl implements IGoalRepository {
  final dbService = DatabaseService();

  // Cria uma nova meta no banco de dados
  @override
  Future<void> createGoal(Goal goal) async {
    final db = await dbService.database;
    await db.insert('goals', goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Busca todas as metas do banco de dados
  @override
  Future<List<Goal>> getGoals() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('goals');

    if (maps.isEmpty) {
      return [];
    }
    
    return List.generate(maps.length, (i) => Goal.fromMap(maps[i]));
  }

  // Atualiza uma meta existente
  @override
  Future<void> updateGoal(Goal goal) async {
    final db = await dbService.database;
    await db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  // Deleta uma meta pelo ID
  @override
  Future<void> deleteGoal(int id) async {
    final db = await dbService.database;
    await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}