import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/shared/components/constants.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: MaterialColor(
    defaultColor.value,
    <int, Color>{
      50: defaultColor.withOpacity(0.1),
      100: defaultColor.withOpacity(0.2),
      200: defaultColor.withOpacity(0.3),
      300: defaultColor.withOpacity(0.4),
      400: defaultColor.withOpacity(0.5),
      500: defaultColor.withOpacity(0.6),
      600: defaultColor.withOpacity(0.7),
      700: defaultColor.withOpacity(0.8),
      800: defaultColor.withOpacity(0.9),
      900: defaultColor.withOpacity(1.0),
    },
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: defaultColor,
    elevation: 0.0,
    // ignore: deprecated_member_use
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: defaultColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'Tajawal',
      color: Colors.black,
      fontSize: 20.0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black45,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: defaultColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: defaultColor,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.white,
    elevation: 20.0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Tajawal',
      fontSize: 18.0,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Tajawal',
      fontSize: 16.0,
      color: Colors.black,
      height: 1.3,
    ),
  ),
  fontFamily: 'Tajawal',
);
ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: HexColor('333739'),
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    // ignore: deprecated_member_use
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'Tajawal',
      color: Colors.white,
      fontSize: 20.0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.white,
    backgroundColor: HexColor('333739'),
  ),
  cardColor: HexColor('333739'),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18.0,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      height: 1.3,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
    ),
  ),
  fontFamily: 'Tajawal',
);
