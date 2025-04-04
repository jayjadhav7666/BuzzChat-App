import 'package:buzzchat/config/colors.dart';
import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: lBackgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: lContainerColor,
    foregroundColor: lOnBackgroundColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lPrimaryColor,
    foregroundColor: lContainerColor,
    iconSize: 30,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: lBackgroundColor,
    filled: true,
    border: UnderlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    hintStyle: TextStyle(
      fontSize: 15,
      color: donContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    ),
    prefixIconColor: lonContainerColor,
  ),
  colorScheme: ColorScheme.light(
    primary: const Color.fromRGBO(0, 87, 255, 1),
    onPrimary: lOnBackgroundColor,
    surface: lBackgroundColor,
    onSurface: lonContainerColor,
    primaryContainer: lContainerColor,
    tertiary: ltertiaryColor,
    secondary: lContainerColor,
    onSecondary: lOnBackgroundColor,
    onPrimaryContainer: lonContainerColor,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: lPrimaryColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: TextStyle(
      fontSize: 30,
      color: lOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      color: lOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: lOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      color: lOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      color: lonContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: lonContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      color: lonContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    ),
  ),
);
var darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: dBackgroundColor,

  appBarTheme: AppBarTheme(
    backgroundColor: dContainerColor,
    foregroundColor: dOnBackgroundColor,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: dPrimaryColor,
    foregroundColor: dOnBackgroundColor,
    iconSize: 30,
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: dBackgroundColor,
    filled: true,
    border: UnderlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    hintStyle: TextStyle(
      fontSize: 15,
      color: donContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    ),
    prefixIconColor: donContainerColor,
  ),
  colorScheme: ColorScheme.dark(
    primary: const Color.fromRGBO(0, 87, 255, 1),
    onPrimary: dOnBackgroundColor,
    surface: dBackgroundColor,
    onSurface: donContainerColor,
    primaryContainer: dContainerColor,
    tertiary: dtertiaryColor,
    secondary: dOnBackgroundColor,
    onSecondary: dOnBackgroundColor,
    onPrimaryContainer: donContainerColor,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: dPrimaryColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: TextStyle(
      fontSize: 30,
      color: dOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      color: dOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: dOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      color: dOnBackgroundColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      color: donContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: donContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      color: donContainerColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    ),
  ),
);
