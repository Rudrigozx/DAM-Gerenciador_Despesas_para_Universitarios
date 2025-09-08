import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
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
  final DashboardViewModel _dashboardViewModel; // Dependência do Dashboard

  TransactionViewModel({
    required this.initialType,
    required DashboardViewModel dashboardViewModel, // Requerido no construtor
    this.onSaveSuccess,
  }) : _dashboardViewModel = dashboardViewModel {
    _currentType = initialType;
  }

  

  //-------------------------------------------------
  // ESTADO DA UI (UI STATE)
  //-------------------------------------------------

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

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

    final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;
    if (descriptionController.text.isEmpty || amount <= 0 || _selectedCategory == null) {
      print("Erro de validação: Campos obrigatórios não preenchidos.");
      _isLoading = false;
      notifyListeners();
      // TODO: Mostrar um erro para o usuário na UI
      return;
    }

    final newTransaction = Transaction(
      description: descriptionController.text,
      amount: amount,
      category: _selectedCategory!,
      type: _currentType,
      date: _selectedDate,
      sourceAccount: _selectedSourceAccount,
      destinationAccount: _selectedDestinationAccount,
    );

    try {
      await _repository.addTransaction(newTransaction);
      print('Transação salva com sucesso!');

      // ✅ ATUALIZAÇÃO PRINCIPAL AQUI:
      // Avisa o DashboardViewModel para recarregar seus dados.
      await _dashboardViewModel.fetchDashboardData();

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