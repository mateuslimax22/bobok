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
      secondary: Color.fromARGB(255, 190, 190, 190),
      surface: Colors.transparent,
      primaryContainer: Color.fromARGB(255, 181, 251, 187),
      secondaryContainer: Color.fromARGB(255, 255, 144, 124)),
  textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 30.0, color: Colors.black),
      displaySmall: TextStyle(fontSize: 14.0, color: Colors.black),
      bodyMedium:
          TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 93, 63, 211)),
      titleLarge: TextStyle(fontSize: 40.0, color: Colors.black)),
);
