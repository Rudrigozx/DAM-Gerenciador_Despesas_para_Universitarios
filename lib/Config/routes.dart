import 'package:fin_plus/Views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppRoutes {
  // Instância do GoRouter para ser usada no MaterialApp
  static final GoRouter router = GoRouter(
    
    // Rota inicial da aplicação
    initialLocation: '/',

    // Lista de todas as rotas da nossa aplicação
    routes: <RouteBase>[
      
      // Rota para a HomeScreen
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage(); // Widget da tela inicial
        },
      ),
      
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: Center(
        child: Text('Erro: ${state.error?.message}'),
      ),
    ),
  );
}