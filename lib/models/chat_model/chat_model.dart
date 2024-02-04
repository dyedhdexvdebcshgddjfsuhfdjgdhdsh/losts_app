import 'package:social_app/models/message_model/message_model.dart';
import 'package:social_app/models/user_model/user_model.dart';

class ChatModel {
  final AppUserModel user;
  final MessageModel lastMessage;

  ChatModel({
    required this.user,
    required this.lastMessage,
  });
}
