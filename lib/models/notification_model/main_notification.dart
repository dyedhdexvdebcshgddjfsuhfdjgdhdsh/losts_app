import 'package:social_app/models/notification_model/notification_model.dart';

class MainNotification extends NotificationDataModel {
  final String id;

  MainNotification.fromJson({
    required Map<String, dynamic> json,
    required this.id,
  }) : super.fromJson(json);
}
