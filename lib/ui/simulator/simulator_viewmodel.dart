import 'dart:math';

import 'package:fin_plus/data/repositories/simulation_repository.dart';
import 'package:fin_plus/domain/models/simulation_model.dart';
import 'package:flutter/material.dart';

class SimulatorViewModel extends ChangeNotifier {
  
  final SimulationRepository _repository;

  SimulatorViewModel({SimulationRepository? repositoryForTest})
      : _repository = repositoryForTest ?? SimulationRepository();

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
    final initialAmount = double.tryParse(initialAmountController.text.replaceAll(',', '.')) ?? 0.0;
    final monthlyContribution = double.tryParse(monthlyContributionController.text.replaceAll(',', '.')) ?? 0.0;
    final annualRate = (double.tryParse(annualRateController.text.replaceAll(',', '.')) ?? 0.0) / 100;
    final periodInMonths = int.tryParse(periodController.text) ?? 0;

    if (periodInMonths <= 0 || annualRate <= 0) return;

    
    final monthlyRate = pow(1 + annualRate, 1 / 12) - 1;

    
    final finalAmountFromInitial = initialAmount * pow(1 + monthlyRate, periodInMonths);
    final finalAmountFromContributions = monthlyContribution * (((pow(1 + monthlyRate, periodInMonths)) - 1) / monthlyRate);
    final futureValue = finalAmountFromInitial + finalAmountFromContributions;

    // Calcula os resultados finais
    _finalAmount = futureValue;
    _totalInvested = initialAmount + (monthlyContribution * periodInMonths);
    _totalInterest = _finalAmount! - _totalInvested!;

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