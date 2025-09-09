import 'package:fin_plus/domain/models/report_data_model.dart';
import 'package:fin_plus/ui/reports/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A tela agora consome o ViewModel global
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        actions: [
          Consumer<ReportsViewModel>(
            builder: (context, viewModel, _) => IconButton(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: viewModel.reportData != null ? viewModel.exportPdf : null,
              tooltip: 'Exportar PDF',
            ),
          ),
        ],
      ),
      body: Consumer<ReportsViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              _buildDatePickers(context, viewModel),
              Expanded(
                child: viewModel.state == ViewState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.state == ViewState.error || viewModel.reportData == null
                        ? const Center(child: Text('Erro ao carregar dados.'))
                        : _buildReportContent(context, viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDatePickers(BuildContext context, ReportsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _DatePickerField(
              label: 'Data Início',
              date: viewModel.startDate,
              onDateSelected: (newDate) {
                if (newDate.isBefore(viewModel.endDate) || newDate.isAtSameMomentAs(viewModel.endDate)) {
                  viewModel.setDateRange(newDate, viewModel.endDate);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _DatePickerField(
              label: 'Data Fim',
              date: viewModel.endDate,
              onDateSelected: (newDate) {
                if (newDate.isAfter(viewModel.startDate) || newDate.isAtSameMomentAs(viewModel.startDate)) {
                  viewModel.setDateRange(viewModel.startDate, newDate);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(BuildContext context, ReportsViewModel viewModel) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSummaryCard(context, viewModel.reportData!, currencyFormat),
        const SizedBox(height: 16),
        _buildCategoryPieChart(context, viewModel.categoryExpensesData, currencyFormat),
        const SizedBox(height: 16),
        _buildMonthlyEvolutionBarChart(context, viewModel.reportData!.monthlyEvolution),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, ReportData data, NumberFormat format) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _summaryRow('Receitas:', format.format(data.totalIncome)),
            const Divider(color: Colors.white54),
            _summaryRow('Despesas:', format.format(data.totalExpenses)),
            const Divider(color: Colors.white54),
            _summaryRow('Saldo:', format.format(data.balance), isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value, {bool isBold = false}) {
    var style = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: style), Text(value, style: style)],
      ),
    );
  }

  Widget _buildCategoryPieChart(BuildContext context, List<CategoryExpense> data, NumberFormat currencyFormat) {
    final theme = Theme.of(context);
    final total = data.fold<double>(0.0, (sum, item) => sum + item.amount);

    final sections = data.map((item) {
      final percentage = total > 0 ? (item.amount / total) * 100 : 0.0;
      return PieChartSectionData(
        value: item.amount,
        title: '${percentage.toStringAsFixed(0)}%',
        color: item.category.color,
        radius: 50,
        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gastos por Categoria', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            data.isEmpty
                ? const SizedBox(height: 150, child: Center(child: Text('Sem dados de gastos neste período.')))
                : Row(
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: PieChart(PieChartData(
                          sections: sections,
                          centerSpaceRadius: 45,
                          sectionsSpace: 2,
                        )),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: data.map((item) {
                            return _buildLegendItem(
                              color: item.category.color,
                              text: item.category.name,
                              value: currencyFormat.format(item.amount),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String text, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildMonthlyEvolutionBarChart(BuildContext context, Map<String, double> data) {
    final theme = Theme.of(context);
    final barGroups = data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final amount = entry.value.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 22,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evolução Mensal de Gastos', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: barGroups.isEmpty
                  ? const Center(child: Text('Sem dados de evolução para este período.'))
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: barGroups,
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < data.keys.length) {
                                  final monthStr = DateFormat('MMM', 'pt_BR').format(DateTime.parse('${data.keys.elementAt(index)}-01'));
                                  return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 4,
                                      child: Text(monthStr.toUpperCase(), style: theme.textTheme.bodySmall));
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final monthYear = DateFormat('MMMM yyyy', 'pt_BR').format(DateTime.parse('${data.keys.elementAt(group.x)}-01'));
                              return BarTooltipItem(
                                '$monthYear\n',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(rod.toY),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para os campos de data
class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  const _DatePickerField({required this.label, required this.date, required this.onDateSelected});

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yyyy').format(date), style: Theme.of(context).textTheme.bodyLarge),
                const Icon(Icons.calendar_today_outlined, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}