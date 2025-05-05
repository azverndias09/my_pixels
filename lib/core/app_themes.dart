import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData lightTheme(String? gender) {
    final isFemale = gender == 'Female';
    final seedColor =
        isFemale
            ? const Color(0xFFD81B60) // rich pink
            : const Color(0xFF455A64); // deep blue-grey

    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: scheme.onPrimaryContainer,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: scheme.onPrimaryContainer),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: TextStyle(
            color: scheme.onBackground,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
          displayMedium: TextStyle(
            color: scheme.onBackground,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: scheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: scheme.onBackground,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            color: scheme.onBackground,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: TextStyle(
            color: scheme.onBackground,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: scheme.primary, width: 1.5),
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        secondarySelectedColor: scheme.primaryContainer,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.onSurface.withOpacity(0.12),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      cardTheme: CardTheme(
        color: scheme.surface,
        elevation: 1.5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      extensions: <ThemeExtension<dynamic>>[
        GenderTheme(
          isFemale: isFemale,
          accentColor: scheme.primary,
          badgeColor: scheme.secondary,
          softBgColor: scheme.surfaceVariant,
        ),
      ],
    );
  }
}

class GenderTheme extends ThemeExtension<GenderTheme> {
  final bool isFemale;
  final Color accentColor;
  final Color badgeColor;
  final Color softBgColor;

  const GenderTheme({
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
  }) => GenderTheme(
    isFemale: isFemale ?? this.isFemale,
    accentColor: accentColor ?? this.accentColor,
    badgeColor: badgeColor ?? this.badgeColor,
    softBgColor: softBgColor ?? this.softBgColor,
  );

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
