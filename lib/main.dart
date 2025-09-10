import 'package:fin_plus/ui/notifications/notification_view.dart';
import 'package:fin_plus/ui/notifications/notification_view_model.dart';
import 'package:fin_plus/data/repositories/sql_goal_repository_impl.dart';
import 'package:fin_plus/ui/core/main_navigation_viewmodel.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fin_plus/ui/goals/my_goals_viewModel.dart';
import 'package:fin_plus/ui/reports/reports_viewmodel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fin_plus/ui/Login/UsuarioViewModel.dart';
import 'package:fin_plus/ui/home/HomePage.dart';
import 'package:provider/provider.dart';
import 'data/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importe o Provider
import 'package:permission_handler/permission_handler.dart';
import 'data/services/NotificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService().database;
  await initializeDateFormatting('pt_BR', null);
  await NotificationService.init();
  await Permission.notification.request();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsuarioViewModel(),
         ),
        ChangeNotifierProvider(create: (_) {
          final vm = NotificationViewModel();
          NotificationService.registerViewModel(vm);
          return vm;
        }),
        ChangeNotifierProvider(
          create: (_) => MainNavigationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyGoalsViewModel(SqlGoalRepositoryImpl())..fetchGoals(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel()..fetchDashboardData(),
        ),
        ChangeNotifierProvider(create: (_) => ReportsViewModel()..fetchReportData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fin Plus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}