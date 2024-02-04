import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_app/cubit/post_cubit/post_states.dart';
import 'package:social_app/models/comment_model/comment.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class EditComment extends StatelessWidget {
  const EditComment({
    Key? key,
    required this.commentModel,
    required this.postId,
  }) : super(key: key);

  final MainComment commentModel;
  final String postId;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    commentController.text = commentModel.text;

    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocaleKeys.edit_comment.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await PostCubit.get(context).editComment(
                    postId: postId,
                    commentId: commentModel.commentId,
                    text: commentController.text,
                    context: context,
                    commentModel: commentModel,
                  );
                },
                child: Text(
                  LocaleKeys.edit.tr(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is PostEditCommentLoadingState)
                  const LinearProgressIndicator(),
                if (state is PostEditCommentLoadingState)
                  const SizedBox(
                    height: 20.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage:
                          CachedNetworkImageProvider(commentModel.userImage),
                      onBackgroundImageError: (_, __) => CachedNetworkImage(
                          imageUrl: AppConstants.defaultImageUrl),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '${commentModel.userName} ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 14.0,
                          ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
