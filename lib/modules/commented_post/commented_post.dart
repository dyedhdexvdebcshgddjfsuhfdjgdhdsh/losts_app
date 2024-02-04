import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_app/cubit/post_cubit/post_states.dart';
import 'package:social_app/shared/components/components.dart';

class CommentedPost extends StatefulWidget {
  const CommentedPost({
    Key? key,
    required this.postId,
  }) : super(key: key);
  final String postId;

  @override
  State<CommentedPost> createState() => _CommentedPostState();
}

class _CommentedPostState extends State<CommentedPost> {
  @override
  void initState() {
    super.initState();
    PostCubit.get(context).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final postModel = PostCubit.get(context).posts.firstWhere(
              (element) => element.id == widget.postId,
            );
        return Scaffold(
          appBar: AppBar(),
          body: buildPostItem(
            context,
            postModel,
            isUserProfile: false,
          ),
        );
      },
    );
  }
}
