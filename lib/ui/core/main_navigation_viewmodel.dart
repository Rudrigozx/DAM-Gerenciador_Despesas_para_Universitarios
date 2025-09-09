// lib/ui/core/main_navigation_viewmodel.dart
import 'package:fin_plus/ui/dashboard/dashboard_screen.dart';
import 'package:fin_plus/ui/expenses_list/ExpensesListPage.dart';
import 'package:fin_plus/ui/goals/my_goals_view.dart';
import 'package:flutter/material.dart';
import '../wallets/wallet_list_page.dart';


class MainNavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Lista das telas que serão exibidas em cada aba.
  final List<Widget> screens = [
    const DashboardScreen(),
    const MyGoalsView(),
    const ExpensesListPage(),
    const WalletListPage(),
  ];

  final List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.track_changes),
      label: 'Goals',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long), // Ícone mais adequado para despesas
      label: 'Expenses',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet),
      label: 'Wallet',
    ),
  ];

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners(); // Notifica a View para reconstruir com a nova tela
    }
  }
}