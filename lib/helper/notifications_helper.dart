import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notifs;
import 'package:rxdart/subjects.dart' as rxSub;

class NotificationClass {
  final int id;
  final String title;
  final String body;
  final String payload;

  
  NotificationClass(
      {required this.id,
      required this.body,
      required this.payload,
      required this.title});
}
