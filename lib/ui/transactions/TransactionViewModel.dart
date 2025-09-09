import 'package:fin_plus/Models/category.dart';
import 'package:fin_plus/Models/transaction_data.dart';
import 'package:fin_plus/Models/wallet_model.dart';
import 'package:fin_plus/data/repositories/TransactionRepository.dart';
import 'package:fin_plus/data/repositories/category_repository.dart';
import 'package:fin_plus/data/repositories/wallet_repository.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


enum Repetition { none, fixed, installment }

class TransactionViewModel extends ChangeNotifier {
  //-------------------------------------------------
  // DEPENDÊNCIAS E CONSTRUTOR
  //-------------------------------------------------

  final TransactionRepository _transactionRepository = TransactionRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final WalletRepository _walletRepository = WalletRepository();
  final DashboardViewModel _dashboardViewModel;
  final Transaction? _transactionToEdit;

  TransactionViewModel({
    required TransactionType initialType,
    required DashboardViewModel dashboardViewModel,
    Transaction? transactionToEdit,
  })  : _dashboardViewModel = dashboardViewModel,
        _transactionToEdit = transactionToEdit {
    _currentType = _transactionToEdit?.type ?? initialType;
    loadInitialData();
  }

  //-------------------------------------------------
  // ESTADO DA UI (UI STATE)
  //-------------------------------------------------

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late TabController tabController;

  late TransactionType _currentType;
  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;
  String? _selectedSourceAccount;
  String? _selectedDestinationAccount;
  Repetition _repetition = Repetition.none;
  bool _isLoading = false;
  List<Category> _availableCategories = [];
  List<Wallet> _availableWallets = [];

  //-------------------------------------------------
  // GETTERS (Para a View ler o estado)
  //-------------------------------------------------
  bool get isEditMode => _transactionToEdit != null;
  TransactionType get currentType => _currentType;
  DateTime get selectedDate => _selectedDate;
  Category? get selectedCategory => _selectedCategory;
  String? get selectedSourceAccount => _selectedSourceAccount;
  String? get selectedDestinationAccount => _selectedDestinationAccount;
  Repetition get repetition => _repetition;
  bool get isLoading => _isLoading;
  List<Category> get availableCategories => _availableCategories;
  List<Wallet> get availableWallets => _availableWallets;
  Color get headerColor {
    switch (_currentType) {
      case TransactionType.income: return Colors.green;
      case TransactionType.expense: return Colors.red;
      case TransactionType.transfer: return Colors.blue;
    }
  }
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (selectedDay == today) return 'Hoje';
    if (selectedDay == yesterday) return 'Ontem';
    return DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  //-------------------------------------------------
  // MÉTODOS (Para a View interagir)
  //-------------------------------------------------

  void setTabController(TabController controller) {
    tabController = controller;
    tabController.index = _currentType.index;
    tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!tabController.indexIsChanging) {
      _currentType = TransactionType.values[tabController.index];
      notifyListeners();
    }
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    _availableCategories = await _categoryRepository.getAllCategories();
    _availableWallets = await _walletRepository.getAllWallets();

    if (isEditMode) {
      final tx = _transactionToEdit!;
      descriptionController.text = tx.description;
      amountController.text = tx.amount.toStringAsFixed(2).replaceAll('.', ',');
      _selectedDate = tx.date;
      _selectedSourceAccount = tx.sourceAccount;
      _selectedDestinationAccount = tx.destinationAccount;
      try {
        _selectedCategory = _availableCategories.firstWhere((cat) => cat.name == tx.category);
      } catch (e) {
        _selectedCategory = null;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  void selectCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectWallet({required bool isSource, required String walletName}) {
    if (isSource) {
      _selectedSourceAccount = walletName;
    } else {
      _selectedDestinationAccount = walletName;
    }
    notifyListeners();
  }
  
  void setRepetition(int index) {
      _repetition = Repetition.values[index];
      notifyListeners();
  }

  Future<void> saveOrUpdateTransaction() async {
    // Validações
    if (_selectedCategory == null || descriptionController.text.isEmpty) {
      // TODO: Exibir erro na UI
      return;
    }

    _isLoading = true;
    notifyListeners();

    final amount = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;
    final transaction = Transaction(
      id: _transactionToEdit?.id,
      description: descriptionController.text,
      amount: amount,
      category: _selectedCategory!.name,
      type: _currentType,
      date: _selectedDate,
      sourceAccount: _selectedSourceAccount,
      destinationAccount: _selectedDestinationAccount,
    );

    if (isEditMode) {
      await _transactionRepository.updateTransaction(transaction);
    } else {
      await _transactionRepository.addTransaction(transaction);
    }

    await _dashboardViewModel.fetchDashboardData();
    _isLoading = false;
    notifyListeners();
  }

  //-------------------------------------------------
  // LIMPEZA (CLEANUP)
  //-------------------------------------------------

  @override
  void dispose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }
}