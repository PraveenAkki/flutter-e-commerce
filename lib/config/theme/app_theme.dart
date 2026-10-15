import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._internal();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1F2937),
    );

    final textTheme = base.textTheme;

    return base.copyWith(
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.poppins(
          textStyle: textTheme.displayLarge,
        ),
        displayMedium: GoogleFonts.poppins(
          textStyle: textTheme.displayMedium,
        ),
        headlineLarge: GoogleFonts.poppins(
          textStyle: textTheme.headlineLarge,
        ),
        titleLarge: GoogleFonts.poppins(
          textStyle: textTheme.titleLarge,
        ),
        bodyLarge: GoogleFonts.poppins(
          textStyle: textTheme.bodyLarge,
        ),
        bodyMedium: GoogleFonts.poppins(
          textStyle: textTheme.bodyMedium,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
    );
  }
}