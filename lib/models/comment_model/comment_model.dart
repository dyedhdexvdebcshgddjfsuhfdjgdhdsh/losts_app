import 'package:social_app/helper/date_time_converter.dart';

class CommentModel {
  late final String userImage;
  late String text;
  late final DateTime dateTime;
  late final String userName;
  late final String userId;
  late final String postId;

  CommentModel({
    required this.userImage,
    required this.text,
    required this.dateTime,
    required this.userName,
    required this.userId,
    required this.postId,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    userImage = json['user_image'];
    text = json['text'];
    dateTime = DateTimeConverter.getDateTimeFromStamp(json['date_time']);
    userName = json['user_name'];
    userId = json['user_id'];
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'user_image': userImage,
      'date_time': dateTime.toUtc().millisecondsSinceEpoch,
      'user_id': userId,
      'user_name': userName,
      'post_id': postId,
    };
  }
}
