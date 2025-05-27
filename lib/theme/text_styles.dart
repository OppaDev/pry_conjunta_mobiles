import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart'; // ELIMINAR
import 'color_palette.dart'; // Todavía necesario para los colores del texto

// --- Estilos de Texto Tema Oscuro ---
TextTheme buildDarkTextTheme() {
  // No especificamos 'fontFamily', Flutter usará la fuente predeterminada del sistema
  return TextTheme(
    displayLarge: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: modernDarkText, letterSpacing: -1.5),
    displayMedium: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: modernDarkText, letterSpacing: -1.0),
    displaySmall: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: modernDarkText),
    headlineLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: modernDarkText),
    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: modernDarkText),
    headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: modernDarkText),
    titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: modernDarkText),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: modernDarkText),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: modernDarkText),
    bodyLarge: const TextStyle(fontSize: 16, color: modernDarkText, height: 1.5),
    bodyMedium: const TextStyle(fontSize: 14, color: modernDarkSecondaryText, height: 1.5),
    bodySmall: const TextStyle(fontSize: 12, color: modernDarkSecondaryText, height: 1.4),
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5), // Para botones
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: modernDarkText),
    labelSmall: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: modernDarkSecondaryText, letterSpacing: 0.5),
  ).apply(
    bodyColor: modernDarkText,
    displayColor: modernDarkText,
  );
}

// --- Estilos de Texto Tema Claro ---
TextTheme buildLightTextTheme() {
  // No especificamos 'fontFamily'
  return TextTheme(
    displayLarge: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: modernLightText, letterSpacing: -1.5),
    displayMedium: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: modernLightText, letterSpacing: -1.0),
    displaySmall: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: modernLightText),
    headlineLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: modernLightText),
    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: modernLightText),
    headlineSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: modernLightText),
    titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: modernLightText),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: modernLightText),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: modernLightText),
    bodyLarge: const TextStyle(fontSize: 16, color: modernLightText, height: 1.5),
    bodyMedium: const TextStyle(fontSize: 14, color: modernLightSecondaryText, height: 1.5),
    bodySmall: const TextStyle(fontSize: 12, color: modernLightSecondaryText, height: 1.4),
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5), // Para botones
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: modernLightText),
    labelSmall: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: modernLightSecondaryText, letterSpacing: 0.5),
  ).apply(
    bodyColor: modernLightText,
    displayColor: modernLightText,
  );
}

// Helper para el logo (puedes personalizarlo más)
// Usaremos una fuente predeterminada, ajustando el estilo si es necesario
Widget buildModernLogo(bool isDarkMode, {double size = 24}) {
  // No especificamos 'fontFamily'
  return Text(
    "PRYTEMAS",
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold, // Puedes ajustar el peso si la fuente predeterminada no se ve bien como "Orbitron"
      color: isDarkMode ? modernDarkPrimary : modernLightPrimary,
      letterSpacing: 1.5,
       // Podrías añadir algún otro estilo para compensar la falta de una fuente específica
       // fontStyle: FontStyle.italic, // Ejemplo
    ),
  );
}