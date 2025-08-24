import 'package:intl/date_symbol_data_file.dart' hide initializeDateFormatting;
import 'package:intl/date_symbol_data_local.dart';

import 'data/services/DatabaseService.dart';
import 'ui/core/themes/Theme.dart';
import 'routing/routes.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // É preciso iniciar o BD e a formatação de data no inicio do APP
  await DatabaseService().database;
  await initializeDateFormatting('pt_BR', null);

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