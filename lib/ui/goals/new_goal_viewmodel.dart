// lib/ui/home/new_goal_viewmodel.dart
import 'package:fin_plus/data/repositories/goal_repository.dart';
import 'package:fin_plus/domain/models/goal_model.dart';
import 'package:flutter/material.dart';

class NewGoalViewModel extends ChangeNotifier {
  final IGoalRepository _repository;

  NewGoalViewModel(this._repository);

  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final targetAmountController = TextEditingController();

  String _selectedCategory = 'Viagem'; // Valor inicial
  String get selectedCategory => _selectedCategory;
  final List<String> categories = ['Viagem', 'Estudos', 'Veículo', 'Outro'];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setSelectedCategory(String? newCategory) {
    if (newCategory != null) {
      _selectedCategory = newCategory;
      notifyListeners();
    }
  }

  Future<bool> createGoal() async {
    if (formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      notifyListeners();

      final targetAmount = double.tryParse(targetAmountController.text) ?? 0.0;
      
      final newGoal = Goal(
        id: '', // O repositório irá gerar o ID
        description: descriptionController.text,
        category: _selectedCategory,
        targetAmount: targetAmount,
      );

      try {
        await _repository.createGoal(newGoal);
        return true; // Sucesso
      } catch (e) {
        // Tratar erro
        return false; // Falha
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
    return false;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    targetAmountController.dispose();
    super.dispose();
  }
}