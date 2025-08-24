import 'package:flutter/material.dart';
import '../../../Models/transaction_data.dart';
import '../../data/repositories/TransactionRepository.dart';

class ExpensesListViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  List<Transaction> _transactions = [];
  // Agrupa as transações por data para a UI
  Map<DateTime, List<Transaction>> get groupedTransactions {
    final map = <DateTime, List<Transaction>>{};
    for (var tx in _transactions) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      if (map[day] == null) {
        map[day] = [];
      }
      map[day]!.add(tx);
    }
    return map;
  }

  ExpensesListViewModel() {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();
    _transactions = await _repository.getTransactionsByMonth(_selectedMonth);
    _isLoading = false;
    notifyListeners();
  }

  void changeMonth(int monthIncrement) {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + monthIncrement, 1);
    fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _repository.deleteTransaction(id);
    // Após deletar, busca os dados novamente para atualizar a lista
    fetchTransactions();
  }
}