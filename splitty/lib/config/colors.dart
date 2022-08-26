import 'package:flutter/material.dart';

const primarySwatch = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFF5839B0),
    100: Color(0xFF5839B0),
    200: Color(0xFF5839B0),
    300: Color(0xFF5839B0),
    400: Color(0xFF5839B0),
    500: primaryColor, // main
    600: Color(0xFF150050),
    700: Color(0xFF150050),
    800: Color(0xFF150050),
    900: Color(0xFF150050),
  },
);

const int _primaryColorValue = 0xFF150050;
const Color primaryColor = Color(_primaryColorValue);
