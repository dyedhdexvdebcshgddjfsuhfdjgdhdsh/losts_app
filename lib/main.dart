import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:social_app/cubit/notification_cubit/notification_cubit.dart';
import 'package:social_app/cubit/post_cubit/post_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_cubit.dart';
import 'package:social_app/cubit/user_cubit/user_states.dart';
import 'package:social_app/local_notification_service/notification_service.dart';
import 'package:social_app/network/remote/dio_helper.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/translations/codegen_loader.g.dart';

import 'firebase_options.dart';
import 'layout/app_layout.dart';
import 'modules/login/login_screen.dart';
import 'modules/on_boarding/on_boarding_screen.dart';
import 'network/local/cache_helper.dart';
import 'shared/components/constants.dart';
import 'styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background Message');
  debugPrint(message.data.toString());
  showToast(
    message: 'Background Message',
    state: ToastStates.success,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocalNotificationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await CacheHelper.init();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();

  Widget startScreen;
  var onBoarding = CacheHelper.getData(key: 'onBoarding');
  uId = await CacheHelper.getData(key: 'uId');
  bool? isDark = await CacheHelper.getData(key: 'isDark');

  if (onBoarding != null) {
    if (uId != null) {
      startScreen = const AppLayout();
    } else {
      startScreen = const AppLoginScreen();
    }
  } else {
    startScreen = const OnBoardingScreen();
  }
  runApp(
    EasyLocalization(
      path: 'assets/translations/',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: MyApp(
        startWidget: startScreen,
        isDark: isDark,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.startWidget,
    required this.isDark,
  }) : super(key: key);
  final Widget startWidget;
  final bool? isDark;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => PostCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ChatCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => NotificationCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              UserCubit()..changeAppMode(fromShared: isDark),
        ),
      ],
      child: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: UserCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
