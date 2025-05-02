import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme(String? gender) {
    final isFemale = gender == 'Female';
    final seedColor =
        isFemale
            ? const Color(0xFFE91E63) // More mature pink
            : const Color(0xFF607D8B); // Softer blue-grey

    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: _colorScheme(seedColor, isFemale),
      extensions: [_genderTheme(isFemale)],
      appBarTheme: _appBarTheme(isFemale),
      inputDecorationTheme: _inputDecorationTheme(isFemale),
      elevatedButtonTheme: _elevatedButtonTheme(seedColor),
      outlinedButtonTheme: _outlinedButtonTheme(seedColor),
      cardTheme: _cardTheme(),
      textTheme: _textTheme(),
      scaffoldBackgroundColor:
          isFemale
              ? Colors.pink[50]?.withOpacity(0.95)
              : Colors.blueGrey[50]?.withOpacity(0.95),
      chipTheme: _chipTheme(seedColor),
    );
  }

  static ColorScheme _colorScheme(Color seedColor, bool isFemale) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ).copyWith(
      surfaceVariant:
          isFemale
              ? Colors.pink[50]!.withOpacity(0.8)
              : Colors.blueGrey[50]!.withOpacity(0.8),
      onSurfaceVariant: isFemale ? Colors.pink[900]! : Colors.blueGrey[900]!,
      secondary: isFemale ? Colors.pink[200]! : Colors.blueGrey[200]!,
    );
  }

  static GenderTheme _genderTheme(bool isFemale) {
    return GenderTheme(
      isFemale: isFemale,
      accentColor: isFemale ? const Color(0xFFE91E63) : const Color(0xFF607D8B),
      badgeColor: isFemale ? Colors.pink[400]! : Colors.blueGrey[400]!,
      softBgColor: isFemale ? Colors.pink[50]! : Colors.blueGrey[50]!,
    );
  }

  static AppBarTheme _appBarTheme(bool isFemale) {
    return AppBarTheme(
      backgroundColor:
          isFemale
              ? Colors.pink[50]?.withOpacity(0.95)
              : Colors.blueGrey[50]?.withOpacity(0.95),
      titleTextStyle: TextStyle(
        color: isFemale ? Colors.pink[900] : Colors.blueGrey[900],
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
      iconTheme: IconThemeData(
        color: isFemale ? Colors.pink[900] : Colors.blueGrey[900],
        size: 28,
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(bool isFemale) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor:
          isFemale
              ? Colors.pink[50]!.withOpacity(0.8)
              : Colors.blueGrey[50]!.withOpacity(0.8),
      hintStyle: TextStyle(
        color: isFemale ? Colors.pink[400]! : Colors.blueGrey[400]!,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color seedColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        elevation: 1,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color seedColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: seedColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(color: seedColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  static CardTheme _cardTheme() {
    return const CardTheme(
      elevation: 1.5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        height: 1.3,
      ),
      displayMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
    );
  }

  static ChipThemeData _chipTheme(Color seedColor) {
    return ChipThemeData(
      backgroundColor: seedColor.withOpacity(0.1),
      labelStyle: TextStyle(color: seedColor, fontWeight: FontWeight.w500),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
