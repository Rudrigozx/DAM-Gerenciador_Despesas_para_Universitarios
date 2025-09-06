import 'package:flutter/material.dart';

import '../../Models/category.dart';
import '../../data/repositories/category_repository.dart';

class CategoryListViewModel extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CategoryListViewModel() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    _categories = await _repository.getAllCategories();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrUpdateCategory(Category category) async {
    if (category.id == null) {
      await _repository.addCategory(category);
    } else {
      await _repository.updateCategory(category);
    }
    // Recarrega a lista para refletir a mudança
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    await loadCategories();
  }
}