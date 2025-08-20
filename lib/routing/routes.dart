// routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Models/transaction_data.dart';
import '../ui/transactions/TransactionsPage.dart';
import '/ui/core/ui/CadastroView.dart';


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
          return CriarConta();
        },
      ),

      GoRoute(
        path: '/transaction/income/new',
        name: 'new-income',
        builder: (BuildContext context, GoRouterState state) {
          return TransactionsPage(initialType: TransactionType.income);
        },
      ),

      GoRoute(
        path: '/transaction/expense/new',
        name: 'new-expense',
        builder: (BuildContext context, GoRouterState state) {
          return TransactionsPage(initialType: TransactionType.expense);
        },
      ),

      GoRoute(
        path: '/transaction/transfer/new',
        name: 'new-transfer',
        builder: (BuildContext context, GoRouterState state) {
          return TransactionsPage(initialType: TransactionType.transfer);
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