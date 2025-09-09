class ReportData {
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> expensesByCategory;
  final Map<String, double> monthlyEvolution; // Ex: {'JAN': 1500, 'FEV': 1200}

  double get balance => totalIncome - totalExpenses;

  ReportData({
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
    this.expensesByCategory = const {},
    this.monthlyEvolution = const {},
  });
}