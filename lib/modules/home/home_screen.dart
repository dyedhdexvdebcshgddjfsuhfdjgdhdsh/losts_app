import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_app/cubit/post_cubit/post_states.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: BlocConsumer<UserCubit, UserStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return ConditionalBuilder(
                    condition: PostCubit.get(context).posts.isNotEmpty &&
                        UserCubit.get(context).userModel != null,
                    builder: (context) => ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildPostItem(
                        context,
                        PostCubit.get(context).posts[index],
                        isUserProfile: false,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10.0,
                      ),
                      itemCount: PostCubit.get(context).posts.length,
                    ),
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
