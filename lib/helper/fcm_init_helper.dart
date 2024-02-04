import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/modules/commented_post/commented_post.dart';
import 'package:social_app/shared/components/components.dart';

class FCMInitHelper {
  BuildContext context;

  FCMInitHelper({
    required this.context,
  });

  Future<void> initListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'message') {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'firebase key',
            title: message.notification!.title,
            payload: {
              'userId': message.data['user_id'],
              'userName': message.data['user_name'],
              'userImage': message.data['user_image'],
              'type': message.data['type'],
            },
          ),
        );
      } else if (message.data['type'] == 'comment') {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 2,
            channelKey: 'firebase key',
            title: message.notification!.title,
            payload: {
              'postId': message.data['post_id'],
              'type': message.data['type'],
            },
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.data['type'] == 'comment') {
        navigateTo(
          context: context,
          screen: CommentedPost(
            postId: event.data['post_id'],
          ),
        );
        //navigateTo(context: context, screen: CommentsScreen(),);
        // ensure to get posts data first
        // navigate to post comment screen
        // ..
      } else {
        navigateTo(
          context: context,
          screen: ChatDetails(
            userId: event.data['user_id'],
            userName: event.data['user_name'],
            userImage: event.data['user_image'],
            isChat: true,
          ),
        );
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((event) async {
      if (event == null) {
        return;
      } else if (event.data['type'] == 'comment') {
        navigateTo(
          context: context,
          screen: CommentedPost(
            postId: event.data['post_id'],
          ),
        );
        //navigateTo(context: context, screen: CommentsScreen(),);
        // ensure to get posts data first
        // navigate to post comment screen
        // ..
      } else {
        navigateTo(
          context: context,
          screen: ChatDetails(
            userId: event.data['user_id'],
            userName: event.data['user_name'],
            userImage: event.data['user_image'],
            isChat: true,
          ),
        );
      }
    });
  }
}
