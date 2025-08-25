<<<<<<< HEAD
import 'package:fin_plus/ui/core/main_navigation_view.dart';

import '../ui/CadastroView.dart';
=======
// routes.dart
import 'package:fin_plus/ui/home/HomePage.dart';
>>>>>>> main
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Models/transaction_data.dart';
import '../ui/expenses_list/ExpensesListPage.dart';
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
<<<<<<< HEAD
        path: '/navigator',
        builder: (BuildContext context, GoRouterState state) {
          return MainNavigationView(); // Widget da tela inicial
        },
      ),
      
=======
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
      // Tela de listagem de despesas
      GoRoute(
        path: '/expenses',
        name: 'expenses-list',
        builder: (context, state) => const ExpensesListPage(),
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

>>>>>>> main
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: Center(
        child: Text('Erro: ${state.error?.message}'),
      ),
    ),
  );
}