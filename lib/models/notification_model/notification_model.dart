import 'package:social_app/helper/date_time_converter.dart';

class NotificationDataModel {
  late String userImage;
  late String title;
  late String type;
  late String userId;
  late String userName;
  late String postId;
  late DateTime dateTime;

  NotificationDataModel({
    required this.userId,
    required this.type,
    required this.userName,
    required this.postId,
    required this.dateTime,
    required this.userImage,
    required this.title,
  });

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    userImage = json['user_image'];
    title = json['title'];
    postId = json['post_id'];
    postId = json['post_id'];
    userName = json['user_name'];
    userId = json['user_id'];
    type = json['type'];
    dateTime = DateTimeConverter.getDateTimeFromStamp(json['date_time']);
  }

  Map<String, dynamic> toJson() {
    return {
      "date_time": dateTime.toUtc().millisecondsSinceEpoch,
      "title": title,
      "user_image": userImage,
      "type": type,
      "user_id": userId,
      "user_name": userName,
      "post_id": postId,
    };
  }
}
