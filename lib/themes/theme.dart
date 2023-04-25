import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData globalTheme = ThemeData(
  primaryColor: Colors.indigo,
  fontFamily: GoogleFonts.actor().fontFamily,
  colorScheme: const ColorScheme(
      background: Color(0xffffffff),
      brightness: Brightness.light,
      error: Colors.red,
      onBackground: Colors.transparent,
      onError: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.transparent,
      onSurface: Colors.transparent,
      primary: Color.fromARGB(255, 93, 63, 211),
      secondary: Color(0xffffffff),
      surface: Colors.transparent,
      primaryContainer: Color.fromARGB(255, 181, 251, 187),
      secondaryContainer: Color.fromARGB(255, 255, 144, 124)),
  textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      bodyText2:
          TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 93, 63, 211)),
      headline6: TextStyle(fontSize: 40.0, color: Colors.black)),
);
