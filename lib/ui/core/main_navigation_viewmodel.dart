// lib/ui/core/main_navigation_viewmodel.dart
import 'package:fin_plus/ui/goals/my_goals_view.dart';
import 'package:flutter/material.dart';
import '../placeholders/carteira_placeholder_view.dart';
import '../placeholders/home_placeholder_view.dart';
import '../placeholders/transacoes_placeholder_view.dart';


class MainNavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Lista das telas que serão exibidas em cada aba.
  // A ordem DEVE corresponder à ordem dos itens na BottomNavigationBar.
  final List<Widget> _screens = [
    const HomePlaceholderView(),
    const MyGoalsView(), // Nossa tela já existente!
    const TransacoesPlaceholderView(),
    const CarteiraPlaceholderView(),
  ];

  List<Widget> get screens => _screens;

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners(); // Notifica a View para reconstruir com a nova tela
    }
  }
}