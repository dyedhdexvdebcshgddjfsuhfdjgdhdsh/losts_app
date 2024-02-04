import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/constants.dart';

import 'login_states.dart';

class AppLoginCubit extends Cubit<AppLoginStates> {
  AppLoginCubit() : super(AppLoginInitialState());

  static AppLoginCubit get(context) => BlocProvider.of(context);

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    emit(AppLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      // update user token
      await updateToken(value.user!.uid);
      if (kDebugMode) {
        print(value.user!.email);
        print(value.user!.uid);
      }
      emit(AppLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (error == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      }
      emit(AppLoginErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility;

  changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(AppChanePasswordVisibilityState());
  }

  Future<String?> _getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> updateToken([String? userId]) async {
    if (uId == null && userId == null) {
      return;
    }
    final token = await _getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId ?? uId)
        .update(
      {
        'token': token,
      },
    );
  }
}
