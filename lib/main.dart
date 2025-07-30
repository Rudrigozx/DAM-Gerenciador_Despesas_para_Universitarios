import 'package:fin_plus/Config/Theme/Theme.dart';
import 'package:fin_plus/Config/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fin+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: AppRoutes.router,
    );
  }
}