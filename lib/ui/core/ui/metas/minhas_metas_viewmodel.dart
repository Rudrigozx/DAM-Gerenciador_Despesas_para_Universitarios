import 'package:fin_plus/data/repositories/meta_repository.dart';
import 'package:fin_plus/domain/models/meta_model.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class MinhasMetasViewModel extends ChangeNotifier {
  final IMetaRepository _repository;

  MinhasMetasViewModel(this._repository);

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  List<Meta> _metas = [];
  List<Meta> get metas => _metas;

  String _selectedCategory = 'Todas';
  String get selectedCategory => _selectedCategory;

  // Filtra as metas com base na categoria selecionada
  List<Meta> get filteredMetas {
    if (_selectedCategory == 'Todas') {
      return _metas;
    }
    return _metas.where((meta) => meta.categoria == _selectedCategory).toList();
  }

  Future<void> fetchMetas() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _metas = await _repository.getMetas();
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