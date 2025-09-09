import 'package:fin_plus/Models/transaction_data.dart';
import 'package:fin_plus/domain/models/goal_model.dart';
import 'package:fin_plus/ui/CadastroView.dart';
import 'package:fin_plus/ui/core/main_navigation_view.dart';
import 'package:fin_plus/ui/expenses_list/ExpensesListPage.dart';
import 'package:fin_plus/ui/goals/edit_goal_screen.dart';
import 'package:fin_plus/ui/goals/goal_details_screen.dart';
import 'package:fin_plus/ui/goals/my_goals_view.dart';
import 'package:fin_plus/ui/goals/new_goal_view.dart';
import 'package:fin_plus/ui/home/HomePage.dart';
import 'package:fin_plus/ui/reports/reports_screen.dart';
import 'package:fin_plus/ui/simulator/simulator_screen.dart';
import 'package:fin_plus/ui/transactions/TransactionsPage.dart';
import 'package:flutter/material.dart'; // Added for Scaffold and AppBar
import 'package:go_router/go_router.dart';
import '../ui/budget/budget_page.dart';
import '../ui/categories/category_list_page.dart';
import '../ui/wallets/wallet_list_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    // Rota inicial da aplicação
    initialLocation: '/main',
    routes: <RouteBase>[
      // Rotas de nível superior
      GoRoute(
        path: '/',
        name: 'signup',
        builder: (context, state) => const CriarConta(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainNavigationView(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/expenses',
        name: 'expenses-list',
        builder: (context, state) => const ExpensesListPage(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories-list',
        builder: (context, state) => const CategoryListPage(),
      ),
      GoRoute(
        path: '/transaction/:type/new',
        name: 'new-transaction',
        builder: (context, state) {
          final typeString = state.pathParameters['type']!;
          final type = TransactionType.values.firstWhere(
                (e) => e.name == typeString,
            orElse: () => TransactionType.expense,
          );
          return TransactionsPage(initialType: type);
        },
      ),
      GoRoute(
        path: '/wallets',
        name: 'wallets-list',
        builder: (context, state) => const WalletListPage(),
      ),
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/simulator',
        name: 'simulator',
        builder: (context, state) => const SimulatorScreen(),
      ),
      GoRoute(
        path: '/budgets',
        name: 'budget',
        builder: (context, state) => const BudgetPage(),
      ),
      GoRoute(
        path: '/goals',
        name: 'goals-list',
        builder: (context, state) => const MyGoalsView(),
        // Sub-rotas relacionadas a 'goals'
        routes: [
          GoRoute(
            path: 'new', // Caminho relativo: será /goals/new
            name: 'new-goal',
            builder: (context, state) => const NewGoalView(),
          ),
          GoRoute(
            path: 'details/:id', // Caminho relativo: /goals/details/:id
            name: 'goal-details',
            builder: (context, state) {
              final goalId = int.parse(state.pathParameters['id']!);
              return GoalDetailsScreen(goalId: goalId);
            },
          ),
          GoRoute(
            path: 'edit/:id', // Caminho relativo: /goals/edit/:id
            name: 'edit-goal',
            builder: (context, state) {
              // It's safer to check if 'extra' is not null and is of the correct type
              if (state.extra is Goal) {
                final goalToEdit = state.extra as Goal;
                return EditGoalScreen(initialGoal: goalToEdit);
              }
              // Return an error screen or navigate back if the extra is not valid
              return const Text('Error: Goal data not provided correctly.');
            },
          ),
        ],
      ),
    ], // <-- BRACKET MOVED HERE
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