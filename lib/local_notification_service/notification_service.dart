import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotificationService {
  static Future<bool> init() async {
    return await AwesomeNotifications().initialize(
      // 'resource://drawable/ic_flutternotification',
      null,
      [
        NotificationChannel(
          channelKey: 'basic key',
          channelName: 'test channel',
          channelDescription: 'notifications test',
          playSound: true,
          channelShowBadge: true,
          importance: NotificationImportance.Max,
        ),
        NotificationChannel(
          channelKey: 'firebase key',
          channelName: 'firebase channel',
          channelDescription: 'firebase test',
          playSound: true,
          channelShowBadge: true,
          importance: NotificationImportance.Max,
        ),
      ],
    );
  }

  static Future<bool> requestPermissions() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<bool> createNotification() async {
    return await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic key',
        title: 'Test Title',
        body: 'Notification From Abdullah',
        // bigPicture: 'assets/',
        // notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  static Future<bool> createScheduleNotification() async {
    return await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic key',
        title: 'Test Title',
        body: 'Notification From Abdullah',
        // bigPicture: 'assets/',
        // notificationLayout: NotificationLayout.BigPicture,
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(
          const Duration(seconds: 3),
        ),
      ),
    );
  }
}
