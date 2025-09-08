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
      // Mostra notificação no sistema
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transaction Notifications',
        channelDescription: 'Notificações do app',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails details = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );

      // Salva no banco
      if (_notificationViewModel != null) {
        final n = AppNotification(
          title: title,
          body: body,
          type: type,
          date: DateTime.now(),
        );
        await _notificationViewModel!.addNotification(n);
      }
    }


    // permissão direto pelo plugin
    /*
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestPermission();

    // iOS/macOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
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

    // Exibe a notificação
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );

    //  Salva no histórico (View)
    _notificationViewModel?.addNotification(
      AppNotification(
        title: title,
        body: body,
        type: type,
        date: DateTime.now(),
      ),
    );
    */




}
