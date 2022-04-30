import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationDetails? androidNotificationDetails;
  NotificationDetails? platformChannelSpecifics;

  NotificationService._privateConstructor();

  static final instance = NotificationService._privateConstructor();

  Future<void> init() async {
    //inizializzo android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    //inizializzo app settings
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);
    //inizializzo timezone.
    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

void initDetails(){
  androidNotificationDetails =
  const AndroidNotificationDetails(
    '0',
    'Notifiche app',
    'Notifiche per healthyApp',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  platformChannelSpecifics =
   NotificationDetails(
      android: androidNotificationDetails,
      iOS: null);
}


//evento che viene scatenato quando la notifica viene cliccata.
  Future<void> selectNotification(String? payload) async {
  }

  //mostra una notifica quando questo metodo viene chiamato
  Future<void> showNotifications(num id, String titolo, String body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      id.toInt(),
      titolo,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  //schedula una notifica per una data passata.
  Future<void> scheduleNotifications(num id, String titolo, String body, DateTime data) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id.toInt(),
        titolo,
        body,
        tz.TZDateTime.from(data, tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics!,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}


