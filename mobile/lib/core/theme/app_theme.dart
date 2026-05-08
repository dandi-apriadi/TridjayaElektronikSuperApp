import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  static const Color secondary = Color(0xFFF97316);
  static const Color secondaryLight = Color(0xFFFB923C);

  // Semantic
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF22C55E);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoBg = Color(0xFFF0F9FF);

  // Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);

  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFCBD5E1);

  // Role colors — vibrant modern palette
  static const Color ownerColor = Color(0xFF7C3AED);
  static const Color ownerLight = Color(0xFFEDE9FE);
  static const Color kepalaCabangColor = Color(0xFF2563EB);
  static const Color kepalaCabangLight = Color(0xFFDBEAFE);
  static const Color adminColor = Color(0xFF0891B2);
  static const Color adminLight = Color(0xFFCFFAFE);
  static const Color salesColor = Color(0xFFEA580C);
  static const Color salesLight = Color(0xFFFFEDD5);
  static const Color driverColor = Color(0xFF0F766E);
  static const Color driverLight = Color(0xFFCCFBF1);

  // Gradients
  static const List<Color> ownerGradient = [Color(0xFF7C3AED), Color(0xFF4F46E5)];
  static const List<Color> kepalaCabangGradient = [Color(0xFF2563EB), Color(0xFF0EA5E9)];
  static const List<Color> adminGradient = [Color(0xFF0891B2), Color(0xFF0D9488)];
  static const List<Color> salesGradient = [Color(0xFFEA580C), Color(0xFFD97706)];
  static const List<Color> driverGradient = [Color(0xFF0F766E), Color(0xFF0369A1)];
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get sm => [
    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1)),
  ];
  static List<BoxShadow> get md => [
    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4)),
    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
  ];
  static List<BoxShadow> get lg => [
    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.10), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> colored(Color color) => [
    BoxShadow(color: color.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      textTheme: base.copyWith(
        displayLarge: base.displayLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        headlineMedium: base.headlineMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        titleLarge: base.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textPrimary),
        bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.border),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textHint),
        prefixIconColor: AppColors.textHint,
        suffixIconColor: AppColors.textHint,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get display => GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.2);
  static TextStyle get heading1 => GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3);
  static TextStyle get heading2 => GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3);
  static TextStyle get heading3 => GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get subtitle => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get body => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static TextStyle get caption => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get label => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.8);
  static TextStyle get overline => GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2);
}
