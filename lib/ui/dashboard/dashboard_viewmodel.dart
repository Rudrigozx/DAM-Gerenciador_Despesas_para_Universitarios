import 'package:fin_plus/data/repositories/TransactionRepository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class DashboardViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  double _monthlyExpenses = 0.0;
  double get monthlyExpenses => _monthlyExpenses;

  List<FlSpot> _balanceEvolution = [];
  List<FlSpot> get balanceEvolution => _balanceEvolution;

  // Propriedade para guardar as datas do eixo X
  List<DateTime> _balanceEvolutionDates = [];
  List<DateTime> get balanceEvolutionDates => _balanceEvolutionDates;

  // Método principal para carregar todos os dados do dashboard
  Future<void> fetchDashboardData() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final now = DateTime.now();
      // Executa todas as buscas em paralelo para mais performance
      final results = await Future.wait([
        _repository.getTotalBalance(),
        _repository.getExpensesForMonth(now),
        _repository.getBalanceEvolution(days: 8),
      ]);

      _totalBalance = results[0] as double;
      _monthlyExpenses = results[1] as double;

      // Processa os dados para o gráfico
      final evolutionData = results[2] as List<Map<String, dynamic>>;

      // Preenche a nova lista de datas
      _balanceEvolutionDates = evolutionData.map((d) => d['date'] as DateTime).toList();

      _balanceEvolution = evolutionData.asMap().entries.map((entry) {
        final index = entry.key.toDouble(); // Eixo X (0, 1, 2, 3...)
        final balance = entry.value['balance'] as double; // Eixo Y (saldo)
        return FlSpot(index, balance);
      }).toList();

      _state = ViewState.success;
    } catch (e) {
      print("Erro ao buscar dados do dashboard: $e");
      _state = ViewState.error;
    }
    // Notifica novamente com os dados carregados ou com o estado de erro
    notifyListeners();
  }
}