class InvestmentSimulation {
  final int? id;
  final DateTime date;
  final double initialAmount;
  final double monthlyContribution;
  final double annualRate;
  final int periodInMonths;
  final double totalInvested;
  final double totalInterest;
  final double finalAmount;

  InvestmentSimulation({
    this.id,
    required this.date,
    required this.initialAmount,
    required this.monthlyContribution,
    required this.annualRate,
    required this.periodInMonths,
    required this.totalInvested,
    required this.totalInterest,
    required this.finalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'initialAmount': initialAmount,
      'monthlyContribution': monthlyContribution,
      'annualRate': annualRate,
      'periodInMonths': periodInMonths,
      'totalInvested': totalInvested,
      'totalInterest': totalInterest,
      'finalAmount': finalAmount,
    };
  }

  factory InvestmentSimulation.fromMap(Map<String, dynamic> map) {
    return InvestmentSimulation(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      initialAmount: map['initialAmount'] as double,
      monthlyContribution: map['monthlyContribution'] as double,
      annualRate: map['annualRate'] as double,
      periodInMonths: map['periodInMonths'] as int,
      totalInvested: map['totalInvested'] as double,
      totalInterest: map['totalInterest'] as double,
      finalAmount: map['finalAmount'] as double,
    );
  }
}