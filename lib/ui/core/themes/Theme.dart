import 'package:flutter/material.dart';

class AppTheme {
  
  // O tema principal da nossa aplicação
  static ThemeData get theme {
    return ThemeData(
      // Esquema de cores principal
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      
      // Define a fonte padrão para toda a aplicação
      fontFamily: 'Poppins', // O mesmo nome que definimos no pubspec.yaml

      // Textos
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      
      // Estilo de botões
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),

      // Ativa o Material 3
      useMaterial3: true,
    );
  }
}