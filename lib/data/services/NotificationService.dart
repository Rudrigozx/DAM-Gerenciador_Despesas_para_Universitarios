import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../Models/Notification.dart';
import '../../ui/notifications/notification_view_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static NotificationViewModel? _notificationViewModel;

  static void registerViewModel(NotificationViewModel vm) {
    _notificationViewModel = vm;
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String type = "default",
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'transaction_channel',
      'Transaction Notifications',
      channelDescription: 'Notificações do app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    // Exibe a notificação no sistema
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );

    // Cria e salva a notificação no banco de dados local
    final newNotification = AppNotification(
      title: title,
      body: body,
      type: type,
      date: DateTime.now(),
    );
    await saveNotification(newNotification);
  }

  /// Salva uma notificação no banco de dados usando o ViewModel registrado.
  static Future<void> saveNotification(AppNotification notification) async {
    if (_notificationViewModel != null) {
      await _notificationViewModel!.addNotification(notification);
    } else {
      // ✅ Trata o caso onde o ViewModel não está registrado
      print("Erro: ViewModel de notificação não foi registrado.");
    }
  }
}
