import 'package:social_app/helper/date_time_converter.dart';

class PostModel {
  late String userName;
  late String uId;
  late String userImage;
  late String postText;
  String? image;
  late DateTime dateTime;

  PostModel({
    required this.userName,
    required this.postText,
    required this.uId,
    required this.userImage,
    this.image,
    required this.dateTime,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    image = json['postImage'];
    userName = json['name'];
    userImage = json['image'];
    postText = json['postText'];
    uId = json['uId'];
    dateTime = DateTimeConverter.getDateTimeFromStamp(
        json['dateTime']); // 564687312 -> 11-2-2032
  }

  Map<String, dynamic> toJson() {
    return {
      'name': userName,
      'postText': postText,
      'uId': uId,
      'postImage': image,
      'image': userImage,
      'dateTime': dateTime.toUtc().millisecondsSinceEpoch,
    };
  }
}
