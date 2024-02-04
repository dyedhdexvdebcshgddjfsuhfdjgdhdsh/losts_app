import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/notification_cubit/notification_states.dart';
import 'package:social_app/models/notification_model/main_notification.dart';
import 'package:social_app/models/notification_model/notification_model.dart';
import 'package:social_app/shared/components/constants.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());

  static NotificationCubit get(context) => BlocProvider.of(context);
  List<MainNotification> notifications = [];

  Future<void> storeNotifications({
    required String userId,
    required String receiverId,
    required String type,
    String? postId,
    required String title,
    required String userName,
    required String userImage,
    required DateTime dateTime,
  }) async {
    NotificationDataModel model = NotificationDataModel(
      userId: userId,
      userName: userName,
      type: type,
      postId: postId ?? '',
      dateTime: dateTime,
      userImage: userImage,
      title: title,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('notifications')
        .add(model.toJson())
        .then((value) {
      emit(StoreNotificationsSuccessState());
    }).catchError((error) {
      emit(StoreNotificationsErrorState());
    });
  }

  void getNotifications() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notifications')
        .orderBy('date_time', descending: true)
        .snapshots()
        .listen((event) {
      notifications = [];
      for (var element in event.docs) {
        notifications.add(
          MainNotification.fromJson(id: element.id, json: element.data()),
        );
      }

      emit(GetNotificationsSuccessState());
    });
  }

  void deleteNotification({required String notificationId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notifications')
        .doc(notificationId)
        .delete()
        .then((value) {
      emit(DeleteNotificationsSuccessState());
    }).catchError((error) {
      emit(DeleteNotificationsErrorState());
    });
  }
}
