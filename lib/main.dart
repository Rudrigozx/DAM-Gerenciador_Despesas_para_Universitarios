import 'package:fin_plus/data/repositories/sql_goal_repository_impl.dart';
import 'package:fin_plus/ui/core/main_navigation_viewmodel.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fin_plus/ui/goals/my_goals_viewModel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/services/DatabaseService.dart';
import 'ui/core/themes/Theme.dart';
import 'routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importe o Provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // É preciso iniciar o BD e a formatação de data no inicio do APP
  await DatabaseService().database;
  await initializeDateFormatting('pt_BR', null);

  // 2. Envolva o MyApp com o MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainNavigationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyGoalsViewModel(SqlGoalRepositoryImpl())..fetchGoals(),
        ),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: const MyApp(),
    ),
  );
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