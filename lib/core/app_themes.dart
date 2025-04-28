import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme(String? gender) {
    final isFemale = gender == 'Female';
    final seedColor =
        isFemale
            ? Colors.pinkAccent
            : Colors.blueGrey; // BlueGrey for Male, PinkAccent for Female

    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: _colorScheme(seedColor, isFemale),
      extensions: [_genderTheme(isFemale)],
      appBarTheme: _appBarTheme(isFemale),
      inputDecorationTheme: _inputDecorationTheme(isFemale),
      elevatedButtonTheme: _elevatedButtonTheme(seedColor),
      cardTheme: _cardTheme(),
      textTheme: _textTheme(),
      scaffoldBackgroundColor: isFemale ? Colors.pink[50] : Colors.blue[50],
    );
  }

  static ColorScheme _colorScheme(Color seedColor, bool isFemale) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ).copyWith(
      surfaceVariant: isFemale ? Colors.pink[100]! : Colors.blue[100]!,
      onSurfaceVariant: isFemale ? Colors.pink[900]! : Colors.blue[900]!,
    );
  }

  static GenderTheme _genderTheme(bool isFemale) {
    return GenderTheme(
      isFemale: isFemale,
      accentColor:
          isFemale
              ? Colors.pinkAccent
              : Colors.blueGrey, // Correct color accents
      badgeColor: isFemale ? Colors.pink[400]! : Colors.blue[400]!,
      softBgColor:
          isFemale
              ? Colors.pink[50]!
              : Colors.blueGrey[50]!, // Background changes
    );
  }

  static AppBarTheme _appBarTheme(bool isFemale) {
    return AppBarTheme(
      backgroundColor: isFemale ? Colors.pink[50] : Colors.blue[50],
      titleTextStyle: TextStyle(
        color: isFemale ? Colors.pink[900] : Colors.blue[900],
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: isFemale ? Colors.pink[900] : Colors.blue[900],
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(bool isFemale) {
    return InputDecorationTheme(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor:
          isFemale
              ? Colors.pink[50]!
              : Colors.blueGrey[50]!, // Consistency with background colors
      iconColor:
          isFemale ? Colors.pink : Colors.blueGrey, // Gender-based icon color
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color seedColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  static CardTheme _cardTheme() {
    return const CardTheme(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.25),
      bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.25),
    );
  }
}

class GenderTheme extends ThemeExtension<GenderTheme> {
  final bool isFemale;
  final Color accentColor;
  final Color badgeColor;
  final Color softBgColor;

  GenderTheme({
    required this.isFemale,
    required this.accentColor,
    required this.badgeColor,
    required this.softBgColor,
  });

  @override
  ThemeExtension<GenderTheme> copyWith({
    bool? isFemale,
    Color? accentColor,
    Color? badgeColor,
    Color? softBgColor,
  }) {
    return GenderTheme(
      isFemale: isFemale ?? this.isFemale,
      accentColor: accentColor ?? this.accentColor,
      badgeColor: badgeColor ?? this.badgeColor,
      softBgColor: softBgColor ?? this.softBgColor,
    );
  }

  @override
  ThemeExtension<GenderTheme> lerp(
    covariant ThemeExtension<GenderTheme>? other,
    double t,
  ) {
    if (other is! GenderTheme) return this;
    return GenderTheme(
      isFemale: other.isFemale,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      badgeColor: Color.lerp(badgeColor, other.badgeColor, t)!,
      softBgColor: Color.lerp(softBgColor, other.softBgColor, t)!,
    );
  }
}
