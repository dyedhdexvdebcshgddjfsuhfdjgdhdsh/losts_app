import 'package:social_app/helper/date_time_converter.dart';

class MessageModel {
  late String senderId;
  late String receiverId;
  late DateTime dateTime;
  late String text;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.text,
  });

  MessageModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    receiverId = json['receiverId'];
    dateTime = DateTimeConverter.getDateTimeFromStamp(json['dateTime']);
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime.toUtc().millisecondsSinceEpoch,
      'text': text,
    };
  }
}
