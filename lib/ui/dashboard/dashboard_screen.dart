import 'package:fin_plus/ui/core/main_drawer.dart';
import 'package:fin_plus/ui/dashboard/dashboard_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A tela agora apenas "ouve" o ViewModel global
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text('Fin+', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
         leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Este comando abre o drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {
            context.push('\teste');
          }),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
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

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchDashboardData(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildBalanceCard(context, 'Saldo total', currencyFormat.format(viewModel.totalBalance)),
                const SizedBox(height: 16),
                _buildBalanceLineChartCard(context, viewModel.balanceEvolution, currencyFormat),
                const SizedBox(height: 16),
                _buildMonthlyExpensesCard(context, currencyFormat.format(viewModel.monthlyExpenses)),
              ],
            ),
          );
        },
      ),
    );
  }

  // Card de Saldo com melhorias visuais
  Widget _buildBalanceCard(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 16),
            // ActionChip(
            //   label: Text(buttonText),
            //   onPressed: () {},
            //   backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            //   labelStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }

  // Card de Gastos Mensais com melhorias visuais
  Widget _buildMonthlyExpensesCard(BuildContext context, String value) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gastos Mensais', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
            const SizedBox(height: 16),
            // ActionChip(
            //   label: const Text('Ver transações'),
            //   onPressed: () {},
            //   backgroundColor: theme.colorScheme.error.withOpacity(0.1),
            //   labelStyle: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }

  // Gráfico de Linhas com melhorias visuais e funcionais
  Widget _buildBalanceLineChartCard(BuildContext context, List<FlSpot> spots, NumberFormat currencyFormat) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Calcula o valor máximo do eixo Y dinamicamente para um bom enquadramento
    double maxY = 100; // Valor mínimo para não achatar o gráfico
    if (spots.isNotEmpty) {
      final maxBalance = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
      maxY = (maxBalance * 1.2).ceilToDouble(); // 20% de margem acima do maior valor
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evolução do Saldo', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 200, // Altura aumentada para melhor visualização
              child: spots.isEmpty
                  ? const Center(child: Text('Dados insuficientes para gerar o gráfico.'))
                  : LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final int index = value.toInt();
                                if (index >= 0 && index < spots.length) {
                                  final DateTime date = DateTime.now().subtract(Duration(days: (spots.length - 1) - index));
                                  // Mostra apenas o primeiro e o último dia para não poluir
                                  if (index == 0 || index == spots.length - 1) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 8,
                                      child: Text(DateFormat('dd/MM').format(date), style: theme.textTheme.bodySmall),
                                    );
                                  }
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45, // Espaço para os rótulos do eixo Y
                              getTitlesWidget: (value, meta) {
                                if (value == 0 || value == maxY) return const SizedBox(); // Não mostra min/max
                                return Text(NumberFormat.compact().format(value), style: theme.textTheme.bodySmall, textAlign: TextAlign.left);
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: primaryColor,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.3),
                                  primaryColor.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (touchedSpot) => theme.colorScheme.primary.withOpacity(0.8),
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                final date = DateTime.now().subtract(Duration(days: (spots.length - 1) - spot.x.toInt()));
                                return LineTooltipItem(
                                  '${DateFormat('dd/MM/yy').format(date)}\n${currencyFormat.format(spot.y)}',
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                );
                              }).toList();
                            },
                          ),
                          handleBuiltInTouches: true,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}