import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as flutter_local_notifications;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@drawable/ic_launcher'),
            iOS: IOSInitializationSettings());

     _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        print("onSelectNotification");
        if (id!.isNotEmpty) {
          print("Router Value1234 $id");
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DemoScreen(
          //       id: id,
          //     ),
          //   ),
          // );
        }
      },
    );
  }

  static void createDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "cpscomapp",
        "cpscomappchannel",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['_id']);
    } on Exception catch (e) {
      print(e);
    }
  }
}