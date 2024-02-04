import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_app/cubit/chat_cubit/chat_states.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/helper/date_time_converter.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

class ChatItemBuilder extends StatefulWidget {
  const ChatItemBuilder({
    super.key,
    required this.userModel,
  });

  final AppUserModel userModel;

  @override
  State<ChatItemBuilder> createState() => _ChatItemBuilderState();
}

class _ChatItemBuilderState extends State<ChatItemBuilder> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatCubit.get(context).getLastMessage(receiverId: widget.userModel.uId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(
          context: context,
          screen: ChatDetails(
            userId: widget.userModel.uId,
            userName: widget.userModel.name,
            userImage: widget.userModel.image!,
            userToken: widget.userModel.token,
            isChat: true,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                '${widget.userModel.image}',
              ),
              onBackgroundImageError: (_, __) => CachedNetworkImage(
                imageUrl: AppConstants.defaultImageUrl,
              ),
              radius: 25.0,
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatStates>(
                builder: (context, state) {
                  final cubit = ChatCubit.get(context);
                  final lastMessage = cubit.lastMessages[widget.userModel.uId];

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userModel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            BlocConsumer<UserCubit, UserStates>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                return Text(
                                  lastMessage != null ? lastMessage.text : '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: UserCubit.get(context).isDark
                                            ? Colors.white
                                            : defaultColor.withOpacity(.9),
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (lastMessage != null)
                        Text(
                          DateTimeConverter.getDateTime(
                            startDate: lastMessage.dateTime,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
