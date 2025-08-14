import 'package:fin_plus/ui/core/main_navigation_view.dart';

import '../ui/CadastroView.dart';
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
          return CriarConta(); // Widget da tela inicial
        },
      ),
      GoRoute(
        path: '/navigator',
        builder: (BuildContext context, GoRouterState state) {
          return MainNavigationView(); // Widget da tela inicial
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