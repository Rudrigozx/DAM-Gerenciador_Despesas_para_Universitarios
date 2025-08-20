//TransactionsViewModel.dart

import 'package:flutter/material.dart';
import '../../../Models/transaction_data.dart';
import '../../data/repositories/TransactionRepository.dart';

enum Repetition { none, fixed, installment }

class TransactionViewModel extends ChangeNotifier {
  //-------------------------------------------------
  // DEPENDÊNCIAS E CONSTRUTOR
  //-------------------------------------------------

  final TransactionRepository _repository = TransactionRepository();
  final TransactionType initialType;
  final VoidCallback? onSaveSuccess;

  TransactionViewModel({
    required this.initialType,
    this.onSaveSuccess,
  }) {
    _currentType = initialType;
  }

  //-------------------------------------------------
  // ESTADO DA UI (UI STATE)
  //-------------------------------------------------

  // Controllers para campos de texto
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Estado interno da ViewModel
  late TransactionType _currentType;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String? _selectedSourceAccount;
  String? _selectedDestinationAccount;
  Repetition _repetition = Repetition.none;
  bool _isLoading = false;

  //-------------------------------------------------
  // GETTERS (Para a View ler o estado)
  //-------------------------------------------------

  TransactionType get currentType => _currentType;
  DateTime get selectedDate => _selectedDate;
  String? get selectedCategory => _selectedCategory;
  String? get selectedSourceAccount => _selectedSourceAccount;
  String? get selectedDestinationAccount => _selectedDestinationAccount;
  Repetition get repetition => _repetition;
  bool get isLoading => _isLoading;

  //-------------------------------------------------
  // MÉTODOS (Para a View atualizar o estado)
  //-------------------------------------------------

  void changeTransactionType(TransactionType newType) {
    _currentType = newType;
    // Limpa os campos que podem mudar para evitar inconsistências
    _selectedSourceAccount = null;
    _selectedDestinationAccount = null;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedSourceAccount(String? account) {
    _selectedSourceAccount = account;
    notifyListeners();
  }

  void setSelectedDestinationAccount(String? account) {
    _selectedDestinationAccount = account;
    notifyListeners();
  }

  void setRepetition(Repetition repetition) {
    _repetition = repetition;
    notifyListeners();
  }

  //-------------------------------------------------
  // LÓGICA DE NEGÓCIO (BUSINESS LOGIC)
  //-------------------------------------------------

  Future<void> saveTransaction() async {
    _isLoading = true;
    notifyListeners();

    // Validação dos dados de entrada
    final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;
    if (descriptionController.text.isEmpty || amount <= 0 || _selectedCategory == null) {
      print("Erro de validação: Campos obrigatórios não preenchidos.");
      _isLoading = false;
      notifyListeners();
      // TODO: Mostrar um erro para o usuário na UI
      return;
    }

    // Cria o objeto do modelo com os dados do estado atual
    final newTransaction = Transaction(
      description: descriptionController.text,
      amount: amount,
      category: _selectedCategory!,
      type: _currentType,
      date: _selectedDate,
      sourceAccount: _selectedSourceAccount,
      destinationAccount: _selectedDestinationAccount,
      // TODO: Adicionar a lógica de repetição ao modelo se necessário
    );

    // Chama o repositório para salvar os dados no SQLite
    try {
      await _repository.addTransaction(newTransaction);
      print('Transação salva com sucesso!');

      // Chama o callback para notificar a View que a operação foi bem-sucedida (para navegação)
      onSaveSuccess?.call();

    } catch (e) {
      print('Ocorreu um erro ao salvar a transação: $e');
      // TODO: Tratar o erro e notificar o usuário
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //-------------------------------------------------
  // LIMPEZA (CLEANUP)
  //-------------------------------------------------

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }
}