abstract class UserStates {}

class UserInitialState extends UserStates {}

class UserGetUserLoadingState extends UserStates {}

class UserGetUserSuccessState extends UserStates {}

class UserGetUserErrorState extends UserStates {
  final String error;

  UserGetUserErrorState(this.error);
}

class UserPickProfileImageSuccessState extends UserStates {}

class UserPickProfileImageErrorState extends UserStates {}

class UserPickCoverImageSuccessState extends UserStates {}

class UserPickCoverImageErrorState extends UserStates {}

class UserUpdateUserLoadingState extends UserStates {}

class UserUploadProfileImageErrorState extends UserStates {}

class UserUploadCoverImageErrorState extends UserStates {}

class ChatUpdateUserSuccessState extends UserStates {}

class ChatUpdateUserErrorState extends UserStates {}

class ChatGetAllUsersLoadingState extends UserStates {}

class ChatGetAllUsersSuccessState extends UserStates {}

class ChatGetAllUsersErrorState extends UserStates {}

class UserLogOutSuccessState extends UserStates {}

class UserChangeAppThemeModeState extends UserStates {}

class UserResetPasswordSuccessState extends UserStates {}

class UserResetPasswordErrorState extends UserStates {}

class UserChangeLanguageState extends UserStates {}
