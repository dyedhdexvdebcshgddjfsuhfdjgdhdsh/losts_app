import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_app/cubit/post_cubit/post_states.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    PostCubit.get(context).typing = true;

    List<Post> posts = [];
    return BlocConsumer<PostCubit, PostStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocaleKeys.search.tr(),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    hintText: LocaleKeys.search_post.tr(),
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    contentPadding: const EdgeInsets.all(20.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: defaultColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color!,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    posts = PostCubit.get(context)
                        .posts
                        .where(
                          (element) => element.postText.contains(value),
                        )
                        .toList();

                    PostCubit.get(context).searchOnSubmit();
                  },
                  onChanged: (value) {
                    PostCubit.get(context).searchOnchange();
                  },
                  onTap: () {
                    PostCubit.get(context).searchOnTap();
                  },
                ),
              ),
              PostCubit.get(context).typing
                  ? Expanded(
                      child: Center(
                        child: Text(
                          LocaleKeys.search_for_something.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : Expanded(
                      child: posts.isEmpty
                          ? Center(
                              child: Text(
                                LocaleKeys.no_posts_found.tr(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildPostItem(
                                  context,
                                  posts[index],
                                  isUserProfile: false,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10.0,
                              ),
                              itemCount: posts.length,
                            ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
