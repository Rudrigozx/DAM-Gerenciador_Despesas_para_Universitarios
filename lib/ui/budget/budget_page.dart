import 'package:fin_plus/data/repositories/sql_goal_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/TransactionRepository.dart';
import '../../domain/models/goal_model.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final SqlGoalRepositoryImpl _goalRepo = SqlGoalRepositoryImpl();

  bool _isLoading = true;
  DateTime _selectedMonth = DateTime.now();
  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  Goal? _mainGoal;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    final income = await _transactionRepo.getSumOfIncomesByMonth(_selectedMonth);
    final expenses = await _transactionRepo.getSumOfExpensesByMonth(_selectedMonth);
    final goals = await _goalRepo.getGoals();

    setState(() {
      _totalIncome = income;
      _totalExpenses = expenses;
      _mainGoal = goals.isNotEmpty ? goals.first : null;
      _isLoading = false;
    });
  }

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + increment, 1);
    });
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamentos'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 16),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildMonthlyBalanceCard(),
            const SizedBox(height: 24),
            if (_mainGoal != null) _buildGoalsCard(_mainGoal!),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _changeMonth(-1)),
        Text(
          DateFormat('MMMM yyyy').format(_selectedMonth).toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _changeMonth(1)),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final balance = _totalIncome - _totalExpenses;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _summaryCard('Receitas', _totalIncome, Colors.blue, Icons.arrow_downward)),
            const SizedBox(width: 16),
            Expanded(child: _summaryCard('Despesas', _totalExpenses, Colors.red, Icons.arrow_upward)),
          ],
        ),
        const SizedBox(height: 16),
        _summaryCard('Saldo', balance, Colors.green, Icons.account_balance_wallet, isLarge: true),
      ],
    );
  }

  Widget _summaryCard(String title, double value, Color color, IconData icon, {bool isLarge = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // Use Expanded para o Column de texto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: isLarge ? 16 : 13),
                  ),
                  FittedBox( // Use FittedBox para garantir que o valor caiba
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'R\$ ${value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isLarge ? 22 : 18, // Reduz um pouco o tamanho
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Espaço entre o texto e o ícone
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: isLarge ? 28 : 24, // Ajusta o tamanho do CircleAvatar
              child: Icon(icon, color: color, size: isLarge ? 30 : 26), // Ajusta o tamanho do ícone
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBalanceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Balanço Mensal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _balanceItem('Receitas', _totalIncome, Colors.blue),
                _balanceItem('Despesas', _totalExpenses, Colors.red),
                _balanceItem('Balanço', _totalIncome - _totalExpenses, Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _balanceItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          'R\$ ${value.toStringAsFixed(2)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }

  Widget _buildGoalsCard(Goal goal) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Objetivos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: goal.progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Center(child: Text('${(goal.progress * 100).toStringAsFixed(0)}%')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: goal.progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 10,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${goal.currentAmount.toStringAsFixed(2)} de R\$ ${goal.targetAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () { /* TODO: Navegar para a tela de lista de objetivos */ },
                child: const Text('VER MAIS'),
              ),
            )
          ],
        ),
      ),
    );
  }
}