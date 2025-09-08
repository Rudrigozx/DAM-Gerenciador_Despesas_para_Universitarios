import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel()..fetchDashboardData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fin+', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
          actions: [
            IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(radius: 16), // Placeholder
            ),
          ],
        ),
        body: Consumer<DashboardViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.state == ViewState.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.state == ViewState.error) {
              return const Center(child: Text('Erro ao carregar dados.'));
            }

            final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildBalanceCard('Saldo total', currencyFormat.format(viewModel.totalBalance), 'Contas'),
                const SizedBox(height: 16),
                _buildCategoryPieChartCard(context, viewModel.categoryExpenses),
                const SizedBox(height: 16),
                _buildBalanceCard('Gastos Mensais', currencyFormat.format(viewModel.monthlyExpenses), 'Ver transações'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String value, String buttonText) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ActionChip(
              label: Text(buttonText),
              onPressed: () {},
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChartCard(BuildContext context, Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, item) => sum + item);
    final sections = data.entries.map((entry) {
      final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        // TODO: Mapear categorias para cores
        color: Colors.primaries[data.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        radius: 60,
        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gastos por Categoria', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: sections.isEmpty
                  ? Center(child: Text('Sem dados de gastos para este mês.'))
                  : PieChart(PieChartData(sections: sections)),
            ),
             // TODO: Adicionar legenda de cores e categorias
          ],
        ),
      ),
    );
  }
}