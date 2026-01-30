import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme(int scaleIndex) {
  final fgColor = const Color.fromARGB(255, 255, 255, 255);
  final bgColor = Colors.deepOrange;

  return ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      titleSmall: GoogleFonts.carlito(fontSize: 16 + (scaleIndex * 3)),
      titleMedium: GoogleFonts.carlito(fontSize: 20 + (scaleIndex * 3)),
      titleLarge: GoogleFonts.carlito(fontSize: 24 + (scaleIndex * 3)),
      bodyMedium: GoogleFonts.carlito(fontSize: 18 + (scaleIndex * 3)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: CircleBorder(),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.carlito(fontSize: 18),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      centerTitle: true,
      elevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: bgColor,
        disabledForegroundColor: fgColor,
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color.fromARGB(255, 209, 209, 209),
      elevation: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: bgColor,
    ),
  );
}
