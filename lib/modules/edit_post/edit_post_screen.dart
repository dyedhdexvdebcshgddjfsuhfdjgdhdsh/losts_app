import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_app/cubit/post_cubit/post_states.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/models/post_model/post.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/translations/locale_keys.g.dart';

class EditPost extends StatelessWidget {
  const EditPost({
    Key? key,
    required this.postModel,
  }) : super(key: key);
  final Post postModel;

  @override
  Widget build(BuildContext context) {
    var temp = postModel.image;
    var postTextController = TextEditingController();
    postTextController.text = postModel.postText;

    return Builder(
      builder: (context) {
        return BlocConsumer<PostCubit, PostStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var model = UserCubit.get(context).userModel;

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  LocaleKeys.edit_post.tr(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (PostCubit.get(context).pickedPostImage == null) {
                        PostCubit.get(context).editPost(
                          context: context,
                          text: postTextController.text,
                          postId: postModel.id,
                          postModel: postModel,
                        );
                        postModel.image = temp;
                      } else {
                        PostCubit.get(context).editPostWithImage(
                          context: context,
                          text: postTextController.text,
                          postId: postModel.id,
                          postModel: postModel,
                        );
                      }
                    },
                    child: Text(
                      LocaleKeys.edit.tr(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    if (state is PostEditPostLoadingState)
                      const LinearProgressIndicator(),
                    if (state is PostEditPostLoadingState)
                      const SizedBox(
                        height: 10.0,
                      ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider('${model!.image}'),
                          onBackgroundImageError: (_, __) => CachedNetworkImage(
                              imageUrl: AppConstants.defaultImageUrl),
                          radius: 25.0,
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          model.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          controller: postTextController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (temp != '' &&
                        PostCubit.get(context).pickedPostImage == null)
                      Expanded(
                        flex: 7,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image: NetworkImage('$temp'),
                                  onError: (_, __) => const NetworkImage(
                                    AppConstants.defaultImageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              child: IconButton(
                                onPressed: () {
                                  temp = '';
                                  PostCubit.get(context)
                                      .removeUploadedPostImage();
                                  // debugPrint('>>>>>>>>>>>> $temp');
                                },
                                icon: const Icon(
                                  Icons.close_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (PostCubit.get(context).pickedPostImage != null)
                      Expanded(
                        flex: 4,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image: FileImage(
                                      PostCubit.get(context).pickedPostImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.0,
                              child: IconButton(
                                onPressed: () {
                                  PostCubit.get(context).removePostImage();
                                },
                                icon: const Icon(
                                  Icons.close_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: Theme.of(context).iconTheme.color!,
                        ),
                      ),
                      child: PopupMenuButton(
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_search_sharp,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              LocaleKeys.add_photo.tr(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        onSelected: (String value) {
                          if (value == 'Camera') {
                            PostCubit.get(context).getPostImageByCamera();
                          } else if (value == 'Gallery') {
                            PostCubit.get(context).getPostImage();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'Camera',
                            child: Text(LocaleKeys.camera.tr()),
                          ),
                          PopupMenuItem(
                            value: 'Gallery',
                            child: Text(LocaleKeys.gallery.tr()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
