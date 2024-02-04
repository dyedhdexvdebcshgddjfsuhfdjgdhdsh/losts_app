import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/constants.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);
  AppUserModel? userModel;
  var picker = ImagePicker();
  File? profileImage;
  File? coverImage;
  List<AppUserModel> users = [];
  bool isEnglish = true;

  Future<void> getUserData() async {
    if (userModel == null) {
      emit(UserGetUserLoadingState());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) async {
        userModel = AppUserModel.fromJson(value.data());
        emit(UserGetUserSuccessState());
      }).catchError((error) {
        debugPrint(error.toString());

        emit(UserGetUserErrorState(error.toString()));
      });
    }
  }

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(UserPickProfileImageSuccessState());
    } else {
      debugPrint('no image selected');
      emit(UserPickProfileImageErrorState());
    }
  }

  Future getProfileImageByCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(UserPickProfileImageSuccessState());
    } else {
      debugPrint('no image selected');
      emit(UserPickProfileImageErrorState());
    }
  }

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(UserPickCoverImageSuccessState());
    } else {
      debugPrint('no image selected');
      emit(UserPickCoverImageErrorState());
    }
  }

  Future getCoverImageByCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(UserPickCoverImageSuccessState());
    } else {
      debugPrint('no image selected');
      emit(UserPickCoverImageErrorState());
    }
  }

  void updateProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UserUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/$uId/profile')
        .putFile(profileImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(PostUploadProfileImageSuccessState());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profileImage: value,
        );
      }).catchError((error) {
        emit(UserUploadProfileImageErrorState());
      });
    })).catchError((error) {
      debugPrint('$error');
      emit(UserUploadProfileImageErrorState());
    });
  }

  void updateCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UserUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/$uId/cover')
        .putFile(coverImage!)
        .then(((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(PostUploadCoverImageSuccessState());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          coverImage: value,
        );
      }).catchError((error) {
        emit(UserUploadCoverImageErrorState());
      });
    })).catchError((error) {
      emit(UserUploadCoverImageErrorState());
    });
  }

  Future<void> updateUser({
    required String name,
    required String phone,
    required String bio,
    String? coverImage,
    String? profileImage,
  }) async {
    emit(UserUpdateUserLoadingState());
    AppUserModel model = AppUserModel(
      name: name,
      phone: phone,
      uId: userModel!.uId,
      cover: coverImage ?? userModel!.cover,
      image: profileImage ?? userModel!.image,
      email: userModel!.email,
      bio: bio,
    );
    userModel = model;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      emit(ChatUpdateUserSuccessState());
    }).catchError((error) {
      emit(ChatUpdateUserErrorState());
    });
  }

  Future<void> getAllUsers() async {
    if (users.isEmpty) {
      emit(ChatGetAllUsersLoadingState());
      await FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) async {
        for (var element in value.docs) {
          if (element.data()['uId'] != uId) {
            users.add(
              AppUserModel.fromJson(element.data()),
            );
          }
          emit(ChatGetAllUsersSuccessState());
        }
      }).catchError((error) {
        emit(ChatGetAllUsersErrorState());
      });
    }
  }

  void logout(BuildContext context) {
    FirebaseFirestore.instance.collection('users').doc(uId).update(
      {'token': ''},
    );
    CacheHelper.removeData(key: 'uId');
    uId = null;
    users = [];
    userModel = null;
    emit(UserLogOutSuccessState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(UserChangeAppThemeModeState());
    } else {
      emit(UserChangeAppThemeModeState());
      CacheHelper.saveData(key: 'isDark', value: isDark).then((_) {
        debugPrint('Change App mode ...........');
      });
    }
  }

  Future<void> setEnglish({
    required BuildContext context,
  }) async {
    context.setLocale(const Locale('en')).then((value) {});
    isEnglish = true;
    emit(UserChangeLanguageState());
    await CacheHelper.saveData(
      key: 'isEnglish',
      value: true,
    );
  }

  Future<void> setArabic({
    required BuildContext context,
  }) async {
    await context.setLocale(const Locale('ar'));
    isEnglish = false;
    emit(UserChangeLanguageState());
    await CacheHelper.saveData(
      key: 'isEnglish',
      value: false,
    );
  }

  void resetPassword({required String email}) {
    FirebaseAuth.instance
        .sendPasswordResetEmail(
      email: email,
    )
        .then((value) {
      emit(UserResetPasswordSuccessState());
    }).catchError((error) {
      emit(UserResetPasswordErrorState());
    });
  }
}
