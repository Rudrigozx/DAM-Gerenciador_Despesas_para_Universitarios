import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/Notification.dart';
import 'notification_view_model.dart';


class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return "${diff.inDays}d";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m";
    }
    return "agora";
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "alerta":
        return Icons.warning_amber_rounded;
      case "conta":
        return Icons.notifications_active;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (context, vm, child) {
        final notifications = vm.notifications;

        if (notifications.isEmpty) {
          return const Center(child: Text("Nenhuma notificação"));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Notificações"),
          ),
          body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final AppNotification n = notifications[index];
              return ListTile(
                leading: Icon(
                  _getIcon(n.type),
                  color: Colors.black,
                  size: 32,
                ),
                title: Text(
                  n.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(_timeAgo(n.date)),
                trailing: const Icon(Icons.circle, color: Colors.red, size: 10),
              );
            },
          ),
        );
      },
    );
  }
}
