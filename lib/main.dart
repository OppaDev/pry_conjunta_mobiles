import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pry_conjunta_mobiles/controller/calcular_pagos_controller.dart';
import 'package:pry_conjunta_mobiles/theme/app_themes.dart';
import 'package:pry_conjunta_mobiles/view/screens/calculadora_pagos_screen.dart'; // Asegúrate que la ruta es correcta

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier(ThemeMode.system)), // O ThemeMode.light / ThemeMode.dark
        ChangeNotifierProvider(create: (_) => CalcularPagosController()),
        // Si fueras a usar PagoMensualController, lo añadirías aquí:
        // ChangeNotifierProvider(create: (_) => PagoMensualController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer aquí para que MaterialApp se reconstruya cuando cambie el tema
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Calculadora de Pagos Exponenciales',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeNotifier.value, // Controla el tema actual
          debugShowCheckedModeBanner: false,
          home: const CalculadoraPagosScreen(),
        );
      },
    );
  }
}