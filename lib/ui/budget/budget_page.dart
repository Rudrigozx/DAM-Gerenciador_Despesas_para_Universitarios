import 'package:fin_plus/ui/budget/budget_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/models/goal_model.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BudgetViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orçamentos'),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.black,
        ),
        body: Consumer<BudgetViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.state == BudgetViewState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.state == BudgetViewState.error) {
              return const Center(child: Text('Erro ao carregar os dados.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMonthSelector(viewModel),
                  const SizedBox(height: 16),
                  _buildSummaryCards(viewModel),
                  const SizedBox(height: 24),
                  _buildMonthlyBalanceCard(viewModel),
                  const SizedBox(height: 24),
                  if (viewModel.mainGoal != null) _buildGoalsCard(context, viewModel.mainGoal!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BudgetViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => viewModel.changeMonth(-1)),
        Text(
          viewModel.formattedMonth,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => viewModel.changeMonth(1)),
      ],
    );
  }

  Widget _buildSummaryCards(BudgetViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _summaryCard('Receitas', viewModel.totalIncome, Colors.blue, Icons.arrow_downward)),
            const SizedBox(width: 16),
            Expanded(child: _summaryCard('Despesas', viewModel.totalExpenses, Colors.red, Icons.arrow_upward)),
          ],
        ),
        const SizedBox(height: 16),
        // A cor do saldo é determinada pela condição
        _summaryCard('Saldo', viewModel.balance, viewModel.balance < 0 ? Colors.red : Colors.green, Icons.account_balance_wallet, isLarge: true),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: isLarge ? 16 : 13),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'R\$ ${value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isLarge ? 22 : 18,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: isLarge ? 28 : 24,
              child: Icon(icon, color: color, size: isLarge ? 30 : 26),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBalanceCard(BudgetViewModel viewModel) {
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
                _balanceItem('Receitas', viewModel.totalIncome, Colors.blue),
                _balanceItem('Despesas', viewModel.totalExpenses, Colors.red),
                // A cor do Balanço é determinada pela condição
                _balanceItem('Balanço', viewModel.balance, viewModel.balance < 0 ? Colors.red : Colors.green),
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

  Widget _buildGoalsCard(BuildContext context, Goal goal) {
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
                onPressed: () => context.push('/goals'),
                child: const Text('VER MAIS'),
              ),
            )
          ],
        ),
      ),
    );
  }
}