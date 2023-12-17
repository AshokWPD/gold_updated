import 'package:flutter/material.dart';

const Color primaryColor = Color(0xff80d6ff);

const MaterialColor primaryMaterialColor = MaterialColor(
  4286633727,
  <int, Color>{
    50: Color.fromRGBO(
      128,
      214,
      255,
      .1,
    ),
    100: Color.fromRGBO(
      128,
      214,
      255,
      .2,
    ),
    200: Color.fromRGBO(
      128,
      214,
      255,
      .3,
    ),
    300: Color.fromRGBO(
      128,
      214,
      255,
      .4,
    ),
    400: Color.fromRGBO(
      128,
      214,
      255,
      .5,
    ),
    500: Color.fromRGBO(
      128,
      214,
      255,
      .6,
    ),
    600: Color.fromRGBO(
      128,
      214,
      255,
      .7,
    ),
    700: Color.fromRGBO(
      128,
      214,
      255,
      .8,
    ),
    800: Color.fromRGBO(
      128,
      214,
      255,
      .9,
    ),
    900: Color.fromRGBO(
      128,
      214,
      255,
      1,
    ),
  },
);

ThemeData customTheme = ThemeData(
  primaryColor: const Color(0xff80d6ff),
  primarySwatch: primaryMaterialColor,
  scrollbarTheme: const ScrollbarThemeData().copyWith(
    thumbColor: MaterialStateProperty.all(primaryMaterialColor[500]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(
        const Color(0xff80d6ff),
      ),
    ),
  ),
);
