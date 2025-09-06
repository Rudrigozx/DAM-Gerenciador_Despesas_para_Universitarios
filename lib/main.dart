import 'package:intl/date_symbol_data_local.dart';
import 'package:fin_plus/ui/core/ui/Login/UsuarioView.dart';
import 'package:fin_plus/ui/core/ui/Login/UsuarioViewModel.dart';
import 'package:fin_plus/ui/home/HomePage.dart';
import 'package:intl/date_symbol_data_file.dart' hide initializeDateFormatting;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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