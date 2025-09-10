class AppNotification {
  final String title;
  final String body;
  final DateTime date;
  final String type;

  AppNotification({
    required this.title,
    required this.body,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'date': date.toIso8601String(),
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      title: map['title'],
      body: map['body'],
      type: map['type'],
      date: DateTime.parse(map['date']),
    );
  }
}
