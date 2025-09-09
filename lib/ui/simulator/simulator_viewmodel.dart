

import 'dart:math';

import 'package:fin_plus/data/repositories/simulation_repository.dart';
import 'package:fin_plus/domain/models/simulation_model.dart';
import 'package:flutter/material.dart';

class SimulatorViewModel extends ChangeNotifier {
  final SimulationRepository _repository = SimulationRepository();

  final initialAmountController = TextEditingController(text: '1000');
  final monthlyContributionController = TextEditingController(text: '100');
  final annualRateController = TextEditingController(text: '10.0');
  final periodController = TextEditingController(text: '24');

  double? _totalInvested;
  double? _totalInterest;
  double? _finalAmount;

  double? get totalInvested => _totalInvested;
  double? get totalInterest => _totalInterest;
  double? get finalAmount => _finalAmount;

  List<InvestmentSimulation> _history = [];
  List<InvestmentSimulation> get history => _history;

  Future<void> calculateAndSaveSimulation() async {
    final initialAmount = double.tryParse(initialAmountController.text) ?? 0.0;
    final monthlyContribution = double.tryParse(monthlyContributionController.text) ?? 0.0;
    final annualRate = (double.tryParse(annualRateController.text) ?? 0.0) / 100;
    final periodInMonths = int.tryParse(periodController.text) ?? 0;

    if (periodInMonths <= 0 || annualRate <= 0) return;

    // A taxa é anual, mas as aplicações são mensais. Precisamos converter a taxa.
    final monthlyRate = pow(1 + annualRate, 1/12) - 1;

    double futureValue = initialAmount;
    for (int i = 0; i < periodInMonths; i++) {
      futureValue = (futureValue + monthlyContribution) * (1 + monthlyRate);
    }
    
    // Calcula os resultados finais
    _finalAmount = futureValue;
    _totalInvested = initialAmount + (monthlyContribution * periodInMonths);
    _totalInterest = _finalAmount! - _totalInvested!;
    
    // Cria o objeto para o histórico
    final simulation = InvestmentSimulation(
      date: DateTime.now(),
      initialAmount: initialAmount,
      monthlyContribution: monthlyContribution,
      annualRate: annualRate * 100, // Salva em %
      periodInMonths: periodInMonths,
      totalInvested: _totalInvested!,
      totalInterest: _totalInterest!,
      finalAmount: _finalAmount!,
    );

    await _repository.saveSimulation(simulation);
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    _history = await _repository.getAllSimulations();
    notifyListeners();
  }
  
  @override
  void dispose() {
    initialAmountController.dispose();
    monthlyContributionController.dispose();
    annualRateController.dispose();
    periodController.dispose();
    super.dispose();
  }
}