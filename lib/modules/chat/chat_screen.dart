import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_app/cubit/chat_cubit/chat_states.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/chat/widgets/chat_item_widget.dart';

import '../../models/message_model/message_model.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  MessageModel? lastMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ChatCubit.get(context).chats.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: ChatCubit.get(context).chats.length,
            itemBuilder: (context, index) {
              AppUserModel userModel = UserCubit.get(context).users.firstWhere(
                    (user) => user.uId == ChatCubit.get(context).chats[index],
                  );

              return ChatItemBuilder(userModel: userModel);
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 5.0,
            ),
          ),
          fallback: (context) => Center(
            child: Text(
              //todo : add this also
              'No Chats Yet',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}
