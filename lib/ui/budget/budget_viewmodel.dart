import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/TransactionRepository.dart';
import '../../data/repositories/sql_goal_repository_impl.dart';
import '../../domain/models/goal_model.dart';

enum BudgetViewState { idle, loading, error }

class BudgetViewModel extends ChangeNotifier {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final SqlGoalRepositoryImpl _goalRepo = SqlGoalRepositoryImpl();

  BudgetViewState _state = BudgetViewState.idle;
  BudgetViewState get state => _state;

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  double _totalIncome = 0.0;
  double get totalIncome => _totalIncome;

  double _totalExpenses = 0.0;
  double get totalExpenses => _totalExpenses;

  Goal? _mainGoal;
  Goal? get mainGoal => _mainGoal;

  double get balance => _totalIncome - _totalExpenses;
  String get formattedMonth => DateFormat('MMMM yyyy', 'pt_BR').format(_selectedMonth).toUpperCase();

  BudgetViewModel() {
    Intl.defaultLocale = 'pt_BR';
    loadDashboardData();
  }

  void _setState(BudgetViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    _setState(BudgetViewState.loading);

    try {
      final results = await Future.wait([
        _transactionRepo.getSumOfIncomesByMonth(_selectedMonth),
        _transactionRepo.getSumOfExpensesByMonth(_selectedMonth),
        _goalRepo.getGoals(),
      ]);

      _totalIncome = results[0] as double;
      _totalExpenses = results[1] as double;
      final goals = results[2] as List<Goal>;

      _mainGoal = goals.isNotEmpty ? goals.first : null;

      _setState(BudgetViewState.idle);
    } catch (e) {
      _setState(BudgetViewState.error);
    }
  }

  void changeMonth(int increment) {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + increment, 1);
    loadDashboardData();
  }
}