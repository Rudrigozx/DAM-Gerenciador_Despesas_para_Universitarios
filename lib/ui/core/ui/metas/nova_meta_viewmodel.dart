// lib/ui/home/nova_meta_viewmodel.dart
import 'package:fin_plus/data/repositories/meta_repository.dart';
import 'package:fin_plus/domain/models/meta_model.dart';
import 'package:flutter/material.dart';


class NovaMetaViewModel extends ChangeNotifier {
  final IMetaRepository _repository;

  NovaMetaViewModel(this._repository);

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final objetivoController = TextEditingController();

  String _selectedCategory = 'Viagem'; // Valor inicial
  String get selectedCategory => _selectedCategory;
  final List<String> categorias = ['Viagem', 'Estudos', 'Veículo', 'Outro'];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setSelectedCategory(String? newCategory) {
    if (newCategory != null) {
      _selectedCategory = newCategory;
      notifyListeners();
    }
  }

  Future<bool> createMeta() async {
    if (formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      notifyListeners();

      final valorObjetivo = double.tryParse(objetivoController.text) ?? 0.0;
      
      final novaMeta = Meta(
        id: '', // O repositório irá gerar o ID
        descricao: descricaoController.text,
        categoria: _selectedCategory,
        valorObjetivo: valorObjetivo,
      );

      try {
        await _repository.createMeta(novaMeta);
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
    descricaoController.dispose();
    objetivoController.dispose();
    super.dispose();
  }
}