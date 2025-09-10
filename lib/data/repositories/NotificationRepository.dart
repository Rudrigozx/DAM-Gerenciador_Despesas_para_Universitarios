import 'package:sqflite/sqflite.dart';
import '../../Models/Notification.dart';
import '../services/DatabaseService.dart';

class NotificationRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<Database> get _database async => _databaseService.database;

  /// Adiciona uma nova notificação ao banco de dados.
  Future<void> addNotification(AppNotification notification) async {
    final db = await _database;
    await db.insert('notifications', notification.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Recupera todas as notificações do banco de dados em ordem decrescente de data.
  Future<List<AppNotification>> getNotifications() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('notifications', orderBy: 'date DESC');

    return List.generate(maps.length, (i) {
      return AppNotification.fromMap(maps[i]);
    });
  }
}
