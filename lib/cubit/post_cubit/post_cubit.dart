import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/helper/fcm_helper.dart';
import 'package:social_app/models/comment_model/comment.dart';
import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/post_model/post.dart';

import '../../models/post_model/post_model.dart';
import '../../modules/chat/chat_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../modules/profile/profile_screen.dart';
import '../../shared/components/constants.dart';
import 'post_states.dart';

class PostCubit extends Cubit<PostStates> {
  PostCubit() : super(PostInitialState());

  static PostCubit get(context) => BlocProvider.of(context);
  var picker = ImagePicker();

  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const ChatsScreen(),
    const NewPostScreen(),
    const ProfileScreen(),
  ];

  void changeBottomNavBar(int index) {
    if (index == 2) {
      emit(PostNewPostState());
    } else {
      currentIndex = index;
      emit(PostChangeBottomNavState());
    }
  }

// so important

  File? pickedPostImage;

  Future<void> getPostImage() async {
    pickedPostImage = null;
    emit(PostImagePickedLoadingState());
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      pickedPostImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
      }
      emit(PostImagePickedErrorState());
    }
  }

  Future<void> getPostImageByCamera() async {
    pickedPostImage = null;
    emit(PostImagePickedLoadingState());
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      pickedPostImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
      }
      emit(PostImagePickedErrorState());
    }
  }

  Future<void> uploadPostImage({
    required BuildContext context,
    required String postText,
    required DateTime postDateTime,
  }) async {
    emit(PostCreatePostLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(pickedPostImage!.path).pathSegments.last}')
        .putFile(pickedPostImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(PostUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        createPost(
          context: context,
          postText: postText,
          dateTime: postDateTime,
          postImage: value,
        );
        pickedPostImage = null;
      }).catchError((error) {
        emit(PostCreatePostErrorState());
      });
    })).catchError((error) {
      emit(PostCreatePostErrorState());
    });
  }

  void createPost({
    required BuildContext context,
    required String postText,
    required DateTime dateTime,
    String? postImage,
  }) {
    emit(PostCreatePostLoadingState());
    PostModel model = PostModel(
      userName: UserCubit.get(context).userModel!.name,
      userImage: UserCubit.get(context).userModel!.image!,
      uId: UserCubit.get(context).userModel!.uId,
      image: postImage ?? '',
      postText: postText,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toJson())
        .then((value) {
      // add post to posts
      posts.insert(
        0,
        Post.fromJson(
          json: model.toJson(),
          id: value.id,
          likes: [],
          // comments: [],
        ),
      );
      Navigator.pop(context);
      emit(PostCreatePostSuccessState());
    }).catchError((error) {
      emit(PostCreatePostErrorState());
    });
  }

  void removePostImage() {
    pickedPostImage = null;
    emit(PostRemovePostImageState());
  }

  void removeUploadedPostImage() {
    emit(PostRemoveUploadedPostImageState());
  }

  List<Post> posts = [];

  Future<void> getPosts() async {
    if (posts.isEmpty) {
      emit(PostGetPostsLoadingState());
      await FirebaseFirestore.instance
          .collection('posts')
          .orderBy(
            'dateTime',
            descending: true,
          )
          .get()
          .then((postDocs) async {
        // get posts with likes
        for (var postDoc in postDocs.docs) {
          // get post likes
          await postDoc.reference
              .collection('likes')
              .where('like', isEqualTo: true)
              .get()
              .then((likeDoc) {
            posts.add(
              Post.fromJson(
                json: postDoc.data(),
                id: postDoc.id,
                likes: likeDoc.docs.map((e) => e.id).toList(),
                comments: [],
              ),
            );
          });

          // get post comments
          posts.last.comments = [];
          await postDoc.reference
              .collection('comments')
              .orderBy('date_time')
              .get()
              .then((commentDocs) {
            for (var commentDoc in commentDocs.docs) {
              posts.last.comments!.add(
                MainComment.fromJson(
                  commentId: commentDoc.id,
                  json: commentDoc.data(),
                ),
              );
            }
          });
          emit(PostGetPostsSuccessState());
        }
      }).catchError((error) {
        emit(PostGetPostsErrorState());
      });
    }
  }

  void streamComments(Post post) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .orderBy('date_time')
        .snapshots()
        .listen((event) {
      post.comments = [];
      for (var comment in event.docs) {
        debugPrint('stream comments ');
        post.comments?.add(
            MainComment.fromJson(json: comment.data(), commentId: comment.id));
      }
      debugPrint(post.comments!.length.toString());
      emit(PostGetCommentSuccessState());
    });

    // debugPrint('start streaming ..');
    // final snaps = FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(post.id)
    //     .collection('comments')
    //     .snapshots()
    //     .map((event) {
    //   post.comments = [];
    //   for(var comment in event.docs){
    //     post.comments?.add(MainComment.fromJson(json: comment.data(), commentId: comment.id));
    //   }
    //   return post.comments;
    //  });

    // return snaps;
  }

  Future<void> editPost({
    required BuildContext context,
    required String text,
    String? postImage,
    required String postId,
    required Post postModel,
  }) async {
    emit(PostEditPostLoadingState());

    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'postText': text,
      'postImage': postImage ?? '',
    }).then((value) {
      // update changes on post model (copy by reference)
      postModel.postText = text;
      postModel.image = postImage ?? '';
      Navigator.pop(context);
      emit(PostEditPostSuccessState());
    }).catchError((error) {
      emit(PostEditPostErrorState(error.toString()));
    });
  }

  Future<void> editPostWithImage({
    required BuildContext context,
    required String text,
    required String postId,
    required Post postModel,
  }) async {
    emit(PostEditPostLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(pickedPostImage!.path).pathSegments.last}')
        .putFile(pickedPostImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) async {
        //emit(PostUploadCoverImageSuccessState());
        if (kDebugMode) {
          print(value);
        }
        await editPost(
          context: context,
          postModel: postModel,
          postId: postId,
          text: text,
          postImage: value,
        );
        pickedPostImage = null;
      }).catchError((error) {
        emit(PostEditPostErrorState(error.toString()));
      });
    })).catchError((error) {
      emit(PostEditPostErrorState(error.toString()));
    });
  }

  Future<void> editComment({
    required String postId,
    required String commentId,
    required String text,
    required BuildContext context,
    required CommentModel commentModel,
  }) async {
    emit(PostEditCommentLoadingState());
    // var model  = CommentModel(
    //   userImage: commentModel.userImage,
    //   text: text,
    //   dateTime: commentModel.dateTime,
    //   userName: commentModel.userName,
    //   userId: commentModel.userId,
    // );
    // commentModel = model;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'text': text,
    }).then((value) {
      commentModel.text = text;
      Navigator.pop(context);
      emit(PostEditCommentSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(PostEditCommentErrorState(error.toString()));
    });
  }

  Future<void> deletePost({
    required Post postModel,
  }) async {
    emit(PostDeletePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.id)
        .delete()
        .then((value) {
      posts.remove(postModel);
      emit(PostDeletePostSuccessState());
    }).catchError((error) {
      emit(PostDeletePostErrorState(error.toString()));
    });
  }

  Future<void> deleteComment({
    required String commentId,
    required Post postModel,
  }) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.id)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then((value) {
      emit(PostDeleteCommentSuccessState());
    }).catchError((error) {
      emit(PostDeleteCommentErrorState(error.toString()));
    });
  }

  Future<void> likePost({
    required Post post,
  }) async {
    bool isLiked = post.likes.contains(uId);

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('likes')
        .doc(uId)
        .set({
      'like': !isLiked,
    }).then((_) {
      if (isLiked) {
        post.likes.remove(uId);
      } else {
        post.likes.add(uId!);
      }
      emit(PostLikePostSuccessState());
    }).catchError((error) {
      debugPrint('error when likePost: ${error.toString()}');
      emit(PostLikePostErrorState(error.toString()));
    });
  }

  void commentOnPost({
    required String comment,
    required String type,
    required DateTime dateTime,
    required BuildContext context,
    required Post post,
  }) {
    var model = CommentModel(
      postId: post.id,
      text: comment,
      userImage: UserCubit.get(context).userModel!.image!,
      dateTime: dateTime,
      userId: UserCubit.get(context).userModel!.uId,
      userName: UserCubit.get(context).userModel!.name,
    );

    // upload comment in Firebase
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('comments')
        .add(model.toJson())
        .then((value) {
      emit(PostCommentOnPostSuccessState());
    }).catchError((error) {
      debugPrint('error when commentPost: ${error.toString()}');
      emit(PostCommentOnPostErrorState(error.toString()));
    });
    if (uId != post.uId) {
      final userToken = UserCubit.get(context)
          .users
          .firstWhere((user) => user.uId == post.uId)
          .token;

      FCMHelper.pushCommentFCM(
        title: '${model.userName} commented on your post',
        description: '',
        userImage: model.userImage,
        userName: model.userName,
        postId: post.id,
        userId: post.uId,
        receiverId: post.uId,
        userToken: userToken,
        context: context,
        dateTime: dateTime,
      ).then((_) {
        debugPrint('push notification on comment');
        debugPrint('userToken >>>>>>>>$userToken');
      });
    }
  }

  bool typing = true;

  void searchOnTap() {
    typing = true;
    emit(PostSearchOnTapState());
  }

  void searchOnSubmit() {
    typing = false;
    emit(PostSearchOnSubmitState());
  }

  void searchOnchange() {
    typing = true;
    emit(PostSearchOnChangeState());
  }
}
