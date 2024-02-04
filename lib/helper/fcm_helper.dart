import 'package:flutter/cupertino.dart';
import 'package:social_app/cubit/notification_cubit/notification_cubit.dart';
import 'package:social_app/network/remote/dio_helper.dart';
import 'package:social_app/shared/components/constants.dart';

class FCMHelper {
  static const _serverKey =
      'AAAARwqMvzs:APA91bH9PlZYgLtorTqf7gQ7HPzV6RdPjM9EYK8EuZOawcyt4e_oGLYCmaK-dbT8mxKuqcXm5oFMu2QBUrCvgfKjqwHHoNhJLByc66hjeqOzmi8hBdqgbroepvXpCResSc3HMHuOmkuz';

  static Future<void> pushCommentFCM({
    /// notification title
    required String title,

    /// notification description
    required String description,
    required String userId,
    required String userToken,
    required String userName,
    required String userImage,
    required String postId,
    required String receiverId,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    /// check if user is not current user
    /// check if the post belong to me and i commented on it it will send me nothing
    if (uId == userId) {
      return;
    }
    // POST METHOD
    await DioHelper.postData(
      baseUrl: 'https://fcm.googleapis.com',
      path: '/fcm/send',
      token: 'key=$_serverKey',
      data: {
        "to": userToken,
        "notification": {
          "title": title,
          "body": description,
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "Tri-tone",
            "default_sound": true
          }
        },
        "data": _commentData(
          postId: postId,
          userName: userName,
          userImage: userImage,
          title: title,
        ),
      },
    ).then((value) async {
      await NotificationCubit.get(context).storeNotifications(
        type: 'comment',
        postId: postId,
        userName: userName,
        userId: userId,
        receiverId: receiverId,
        title: title,
        userImage: userImage,
        dateTime: dateTime,
      );
    });
  }

  static Future<void> pushChatMessageFCM({
    /// notification title
    required String title,

    /// notification description
    required String description,
    required String userName,
    required String userImage,
    required String userId,
    required String receiverId,
    required DateTime dateTime,
    required BuildContext context,
    required String userToken,
  }) async {
    if (uId == receiverId) {
      return;
    }
    // POST METHOD
    await DioHelper.postData(
      baseUrl: 'https://fcm.googleapis.com',
      path: '/fcm/send',
      token: 'key=$_serverKey',
      data: {
        "to": userToken,
        "notification": {
          "title": title,
          "body": description,
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "Tri-tone",
            "default_sound": true
          }
        },
        "data": _messageData(
          userId: userId,
          userName: userName,
          title: title,
          userImage: userImage,
          userToken: userToken,
        ),
      },
    ).then((value) async {
      await NotificationCubit.get(context).storeNotifications(
        userId: userId,
        type: 'message',
        userName: userName,
        receiverId: receiverId,
        title: title,
        userImage: userImage,
        dateTime: dateTime,
      );
    });
  }

  static Map<String, dynamic> _commentData({
    required String postId,
    required String userName,
    required String userImage,
    required String title,
  }) {
    return {
      "type": "comment",
      "post_id": postId,
      "user_name": userName,
      "title": title,
      "user_image": userImage,
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    };
  }

  static Map<String, dynamic> _messageData({
    required String userId,
    required String userName,
    required String userImage,
    required String title,
    required String userToken,
  }) {
    return {
      "type": "message",
      "user_id": userId,
      "user_name": userName,
      "title": title,
      "user_image": userImage,
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    };
  }
}
