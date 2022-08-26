import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  primarySwatch: primarySwatch,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  fontFamily: "Outfit",
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontFamily: "Outfit",
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primarySwatch,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey[300]!;
          }

          return primarySwatch;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }

          return Colors.white;
        },
      ),
      overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(.4)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ),
  ),
);
