import 'package:flutter/foundation.dart';
import '../../data/services/DatabaseService.dart';
import '/Models/Notification.dart';

class NotificationViewModel extends ChangeNotifier {
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  // ✅ Chamando loadNotifications no construtor
  NotificationViewModel() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final db = await DatabaseService().database;
    final maps = await db.query('notifications', orderBy: "id DESC");

    _notifications = maps.map((map) => AppNotification.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    final db = await DatabaseService().database;
    await db.insert('notifications', notification.toMap());

    _notifications.insert(0, notification);
    notifyListeners();
  }
}

/*
class NotificationViewModel extends ChangeNotifier {
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  NotificationViewModel() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final db = await DatabaseService().database; // se for classe normal
    final maps = await db.query('notifications', orderBy: "id DESC");

    _notifications = maps.map((map) => AppNotification.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    final db = await DatabaseService().database; // se for classe normal
    await db.insert('notifications', notification.toMap());

    _notifications.insert(0, notification);
    notifyListeners();
  }
}
*/
