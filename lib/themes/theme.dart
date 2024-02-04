import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme _buildLightTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 30.0, color: Colors.black),
    displaySmall: TextStyle(fontSize: 14.0, color: Colors.black),
    bodyMedium:
        TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 93, 63, 211)),
    titleLarge: TextStyle(fontSize: 40.0, color: Colors.black),
  );
}

TextTheme _buildDarkTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 30.0, color: Colors.white),
    displaySmall: TextStyle(fontSize: 14.0, color: Colors.white),
    bodyMedium:
        TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 93, 63, 211)),
    titleLarge: TextStyle(fontSize: 40.0, color: Colors.white),
  );
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.indigo,
  textTheme: _buildLightTextTheme().apply(
    fontFamily: GoogleFonts.actor().fontFamily,
  ),
  colorScheme: const ColorScheme(
    background: Color(0xffffffff),
    brightness: Brightness.light,
    error: Colors.red,
    onBackground: Colors.transparent,
    onError: Color.fromARGB(255, 236, 233, 255),
    onPrimary: Colors.black,
    onSecondary: Colors.transparent,
    onSurface: Colors.transparent,
    primary: Color.fromARGB(255, 93, 63, 211),
    secondary: Color.fromARGB(255, 190, 190, 190),
    tertiary: Colors.white,
    surface: Colors.transparent,
    inverseSurface: Color.fromARGB(255, 223, 215, 250),
    primaryContainer: Color.fromARGB(255, 181, 251, 187),
    secondaryContainer: Color.fromARGB(255, 255, 144, 124),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: Colors.indigo,
  textTheme: _buildDarkTextTheme().apply(
    fontFamily: GoogleFonts.actor().fontFamily,
  ),
  colorScheme: const ColorScheme(
    // Update your dark mode colors here
    background: Color.fromARGB(255, 35, 33, 57),
    brightness: Brightness.dark,
    error: Colors.red,
    onBackground: Colors.white,
    onError: Color.fromARGB(255, 36, 33, 40),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    primary: Color.fromARGB(255, 127, 121, 230),
    secondary: Color.fromARGB(255, 190, 190, 190),
    tertiary: Colors.white,
    surface: Color.fromARGB(255, 36, 33, 40),
    inverseSurface: Color.fromARGB(255, 223, 215, 250),
    primaryContainer: Color.fromARGB(84, 181, 251, 187),
    secondaryContainer: Color.fromARGB(107, 255, 144, 124),
  ),
);
