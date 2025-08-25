import 'package:fin_plus/ui/core/main_navigation_view.dart';
import '../ui/CadastroView.dart';
import 'package:fin_plus/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Models/transaction_data.dart';
import '../ui/expenses_list/ExpensesListPage.dart';
import '../ui/transactions/TransactionsPage.dart';

class AppRoutes {
  // Instância do GoRouter para ser usada no MaterialApp.router
  static final GoRouter router = GoRouter(
    // Rota inicial da aplicação
    initialLocation: '/',

    // Lista de todas as rotas da nossa aplicação
    routes: <RouteBase>[
      // Rota para a tela de Cadastro/Login (tela inicial)
      GoRoute(
        path: '/',
        name: 'root', // É uma boa prática nomear todas as rotas
        builder: (BuildContext context, GoRouterState state) {
          return const CriarConta(); // Recomendo usar 'const' se o widget for imutável
        },
      ),

      // Rota para a tela principal que contém a Bottom Navigation
      GoRoute(
        path: '/navigator',
        name: 'navigator',
        builder: (BuildContext context, GoRouterState state) {
          return const MainNavigationView();
        },
      ),

      // Rota para a HomePage (provavelmente uma das telas dentro do Navigator)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),

      // Tela de listagem de despesas
      GoRoute(
        path: '/expenses',
        name: 'expenses-list',
        builder: (context, state) => const ExpensesListPage(),
      ),

      // Rotas agrupadas para criação de transações
      GoRoute(
        path: '/transaction/:type/new', // Rota com parâmetro dinâmico
        name: 'new-transaction',
        builder: (BuildContext context, GoRouterState state) {
          // Obtém o tipo da URL e o converte para o enum
          final typeString = state.pathParameters['type']!;
          final type = TransactionType.values.firstWhere(
            (e) => e.name == typeString,
            orElse: () => TransactionType.expense, // Valor padrão em caso de erro
          );
          return TransactionsPage(initialType: type);
        },
      ),
    ],

    // Página de erro para rotas não encontradas
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('A rota que você tentou acessar não existe.'),
            Text('Erro: ${state.error?.message ?? 'Rota inválida'}'),
          ],
        ),
      ),
    ),
  );
}