import 'package:flutter/material.dart';

/// Verde institucional de la Gobernación; Material 3 arma la paleta a partir de él.
const Color verdeBeni = Color(0xFF0F6E5A);

ThemeData temaClaro() => _tema(Brightness.light);

ThemeData temaOscuro() => _tema(Brightness.dark);

ThemeData _tema(Brightness brillo) {
  final colores = ColorScheme.fromSeed(seedColor: verdeBeni, brightness: brillo);

  return ThemeData(
    colorScheme: colores,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: colores.surface,
      foregroundColor: colores.onSurface,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: colores.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colores.outlineVariant),
      ),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}
