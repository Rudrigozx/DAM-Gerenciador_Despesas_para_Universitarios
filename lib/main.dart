import 'package:fin_plus/ui/notifications/notification_view.dart';
import 'package:fin_plus/ui/notifications/notification_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fin_plus/ui/Login/UsuarioViewModel.dart';
import 'package:fin_plus/ui/home/HomePage.dart';
import 'package:provider/provider.dart';
import 'data/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'data/services/NotificationService.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // É preciso iniciar o BD e a formatação de data no inicio do APP
  await DatabaseService().database;
  await initializeDateFormatting('pt_BR', null);
  await NotificationService.init();
  await Permission.notification.request();

  Future.delayed(const Duration(seconds: 2), () {
    NotificationService.showNotification(
      title: "Teste interno",
      body: "Essa notificação deve aparecer na View também!",
      type: "alerta",
    );
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) {
        final vm = NotificationViewModel();
        NotificationService.registerViewModel(vm); // conecta o Service
        return vm;
      }),
    ],
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UsuarioViewModel(),
            child: MaterialApp(
            title: 'Fin Plus',
            theme: ThemeData(
            primarySwatch: Colors.blue,
            ),
            ),
            )
    ],
            child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
    )
    );
  }
}