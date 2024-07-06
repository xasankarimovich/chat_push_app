import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationServices {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _localNotification.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      notificationEnabled =
          await android?.requestNotificationsPermission() ?? false;
      notificationEnabled =
          await android?.requestExactAlarmsPermission() ?? false;
    } else if (Platform.isIOS) {
      final ios = _localNotification.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      notificationEnabled = await ios?.requestPermissions(
        sound: true,
        alert: true,
        badge: true,
        provisional: true,
        critical: true,
      ) ??
          false;
    }
  }

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('xasan');
    const iosSetting = DarwinInitializationSettings();

    const initSetting = InitializationSettings(
      android: androidSettings,
      iOS: iosSetting,
    );
    await _localNotification.initialize(initSetting);
  }

  static Future<void> showNotification() async {
    const androidnotifications = AndroidNotificationDetails(
      "sovg'alar ID",
      "Sovgalar nomi",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      enableLights: true,
    );
    const iosNotifications = DarwinNotificationDetails();

    const initNotificatons = NotificationDetails(
      android: androidnotifications,
      iOS: iosNotifications,
    );

    await _localNotification.show(
      0,
      'birinchi Xabarnoma\n',
      ' \nOlim mani ismim Onalarini ukalaridekman',
      initNotificatons,
    );
  }
}
