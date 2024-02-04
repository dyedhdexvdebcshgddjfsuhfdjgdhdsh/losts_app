import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/notification_cubit/notification_cubit.dart';
import 'package:social_app/cubit/notification_cubit/notification_states.dart';
import 'package:social_app/helper/date_time_converter.dart';
import 'package:social_app/models/notification_model/main_notification.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/modules/commented_post/commented_post.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class NotificationsDisplayScreen extends StatelessWidget {
  const NotificationsDisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocaleKeys.notifications.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          body: ConditionalBuilder(
            condition: NotificationCubit.get(context).notifications.isNotEmpty,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildNotificationItem(
                  context, NotificationCubit.get(context).notifications[index]),
              separatorBuilder: (context, index) => Divider(
                thickness: .5,
                indent: 20.0,
                endIndent: 20.0,
                color: Theme.of(context).iconTheme.color,
              ),
              itemCount: NotificationCubit.get(context).notifications.length,
            ),
            fallback: (context) => Center(
              child: Text(
                LocaleKeys.no_notifications.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNotificationItem(BuildContext context, MainNotification model) =>
      InkWell(
        onTap: () {
          if (model.type == 'comment') {
            navigateTo(
              context: context,
              screen: CommentedPost(postId: model.postId),
            );
          } else {
            navigateTo(
              context: context,
              screen: ChatDetails(
                userId: model.userId,
                userName: model.userName,
                userImage: model.userImage,
                isChat: true,
              ),
            );
          }
          NotificationCubit.get(context)
              .deleteNotification(notificationId: model.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24.0,
                backgroundImage: CachedNetworkImageProvider(
                  model.userImage,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      DateTimeConverter.getDateTime(startDate: model.dateTime),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
