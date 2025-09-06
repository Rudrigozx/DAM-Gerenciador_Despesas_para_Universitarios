import 'package:fin_plus/data/repositories/goal_repository.dart';
import 'package:fin_plus/domain/models/goal_model.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class MyGoalsViewModel extends ChangeNotifier {
  final IGoalRepository _repository;

  MyGoalsViewModel(this._repository);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<Goal> _goals = [];
  List<Goal> get goals => _goals;

  String _selectedCategory = 'Todas';
  String get selectedCategory => _selectedCategory;

  // Filtra as metas com base na categoria selecionada
  List<Goal> get filteredGoals {
    if (_selectedCategory == 'Todas') {
      return _goals;
    }
    return _goals.where((goal) => goal.category == _selectedCategory).toList();
  }

  Future<void> fetchGoals() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _goals = await _repository.getGoals();
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      // Aqui você poderia registrar o erro ou preparar uma mensagem mais amigável
    }
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}