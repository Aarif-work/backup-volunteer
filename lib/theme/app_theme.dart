import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Soft, Warm, Human-Centered Color Palette
  static const Color primaryText = Color(0xFF2C3E50);
  static const Color secondaryText = Color(0xFF7F8C8D);
  static const Color backgroundColor = Color(0xFFFDFBF7); // Soft creamy white
  static const Color surfaceColor = Colors.white;

  // Legacy Aliases (mapped to new soft warm palette for backwards compatibility)
  static const Color primaryColor = Color(0xFFE67E22); // peachAccent
  static const Color primaryLight = Color(0xFFFFDAB9); // softPeach
  static const Color accentColor = Color(0xFF16A085);  // mintAccent
  static const Color textSecondary = Color(0xFF7F8C8D); // secondaryText
  static const Color textPrimary = Color(0xFF2C3E50);   // primaryText
  static const Color yellowAction = Color(0xFFF39C12);  // yellowAccent
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFDEBD0), Color(0xFFF5CBA7)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  // Soft Base Colors
  static const Color softPeach = Color(0xFFFFDAB9);
  static const Color warmPink = Color(0xFFFFB6C1);
  static const Color calmLavender = Color(0xFFE6E6FA);
  static const Color pureMint = Color(0xFFD4E6DF);
  static const Color gentleYellow = Color(0xFFFCF3CF);
  
  // Icon and Accent Tints
  static const Color peachAccent = Color(0xFFE67E22);
  static const Color pinkAccent = Color(0xFFE74C3C);
  static const Color lavenderAccent = Color(0xFF8E44AD);
  static const Color mintAccent = Color(0xFF16A085);
  static const Color yellowAccent = Color(0xFFF39C12);

  // Soft Gradients
  static const LinearGradient peachGradient = LinearGradient(
    colors: [Color(0xFFFDEBD0), Color(0xFFF5CBA7)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  
  static const LinearGradient lavenderGradient = LinearGradient(
    colors: [Color(0xFFF4ECF7), Color(0xFFD7BDE2)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient mintGradient = LinearGradient(
    colors: [Color(0xFFE8F8F5), Color(0xFFA3E4D7)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFEF9E7), Color(0xFFF9E79F)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient warmSunsetGradient = LinearGradient(
    colors: [Color(0xFFFAD7A1), Color(0xFFE96D71)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [
      Color(0xFF000000), // Pure black top-left
      Color(0xFF0A0A0A),  
      Color(0xFF8E44AD), // Primary purple
      Color(0xFF9B59B6), // Light purple
    ],
    stops: [0.0, 0.3, 0.8, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: peachAccent,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.bold, color: primaryText, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w700, color: primaryText, letterSpacing: -0.5),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: primaryText),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: primaryText),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: secondaryText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: primaryText, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        iconTheme: IconThemeData(color: primaryText),
      ),
    );
  }
}
