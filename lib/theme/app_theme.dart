import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF8FD694);
  static const background = Color(0xFFF3FAF4);
  static const white = Color(0xFFFFFFFF);

  static const softBlue = Color(0xFFDCEFF2);
  static const softYellow = Color(0xFFFFF3C4);
  static const softPeach = Color(0xFFFFE4D6);
  static const softGreen = Color(0xFFDDF3DF);

  static const text=Color(0xFF3F5143);

  //dark mode palatte
  static const darkBackground = Color(0xFF18221A);
  static const darkCard = Color(0xFF26352A);
  static const darkText = Color(0xFFE8F5E9);
  static const darkAppBar = Color(0xFF3F6544);

}

class AppTheme{
  static ThemeData lightTheme(){
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      textTheme: GoogleFonts.nunitoTextTheme(),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.fredoka(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme(){
    return ThemeData(
      brightness: Brightness.dark,

        scaffoldBackgroundColor: AppColors.darkBackground,

        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.dark().textTheme,
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary,
        brightness: Brightness.dark,),

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkAppBar,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          titleTextStyle: GoogleFonts.fredoka(
            color: AppColors.darkText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        cardTheme: CardThemeData(
          color: AppColors.darkCard,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: const Color(0xFF18301B),
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}