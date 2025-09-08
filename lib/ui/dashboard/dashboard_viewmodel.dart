import 'package:fin_plus/data/repositories/TransactionRepository.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class DashboardViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  double _monthlyExpenses = 0.0;
  double get monthlyExpenses => _monthlyExpenses;

  Map<String, double> _categoryExpenses = {};
  Map<String, double> get categoryExpenses => _categoryExpenses;

  // Método principal para carregar todos os dados do dashboard
  Future<void> fetchDashboardData() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final now = DateTime.now();
      // Executa todas as buscas em paralelo para mais performance
      final results = await Future.wait([
        _repository.getTotalBalance(),
        _repository.getExpensesForMonth(now),
        _repository.getExpensesByCategoryForMonth(now),
      ]);

      _totalBalance = results[0] as double;
      _monthlyExpenses = results[1] as double;
      _categoryExpenses = results[2] as Map<String, double>;

      _state = ViewState.success;
    } catch (e) {
      print("Erro ao buscar dados do dashboard: $e");
      _state = ViewState.error;
    }
    notifyListeners();
  }
}