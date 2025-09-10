import 'package:flutter/foundation.dart';
import '../../data/repositories/NotificationRepository.dart';
import '../../Models/Notification.dart';

class NotificationViewModel extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  final NotificationRepository _repository = NotificationRepository();

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  NotificationViewModel() {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    _notifications = await _repository.getNotifications();
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    await _repository.addNotification(notification);
    // Insere a nova notificação na lista local para atualização imediata da UI
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
