abstract class AppRegisterStates {}

class AppRegisterInitialState extends AppRegisterStates {}

class AppRegisterLoadingState extends AppRegisterStates {}

class AppRegisterSuccessState extends AppRegisterStates {}

class AppRegisterErrorState extends AppRegisterStates {
  final String error;

  AppRegisterErrorState(this.error);
}

class AppCreateUserSuccessState extends AppRegisterStates {
  final String uId;

  AppCreateUserSuccessState(this.uId);
}

class AppCreateUserErrorState extends AppRegisterStates {
  final String error;

  AppCreateUserErrorState(this.error);
}

class AppRegisterChanePasswordVisibilityState extends AppRegisterStates {}
