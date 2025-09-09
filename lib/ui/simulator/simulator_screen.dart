import 'package:fin_plus/domain/models/simulation_model.dart';
import 'package:fin_plus/ui/simulator/simulator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SimulatorScreen extends StatelessWidget {
  const SimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimulatorViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Simulador de Rendimentos'),
          actions: [
            Consumer<SimulatorViewModel>(
              builder: (context, viewModel, _) => IconButton(
                icon: const Icon(Icons.history_outlined),
                onPressed: () async {
                  await viewModel.fetchHistory();
                  _showHistoryModal(context, viewModel.history);
                },
              ),
            ),
          ],
        ),
        body: Consumer<SimulatorViewModel>(
          builder: (context, viewModel, _) {
            return ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildTextField(viewModel.initialAmountController, 'Valor Inicial (R\$)'),
                _buildTextField(viewModel.monthlyContributionController, 'Aplicação Mensal (R\$)'),
                _buildTextField(viewModel.annualRateController, 'Taxa de Juros (% a.a.)'),
                _buildTextField(viewModel.periodController, 'Período (Meses)', isInteger: true),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: viewModel.calculateAndSaveSimulation,
                  child: const Text('Simular'),
                ),
                if (viewModel.finalAmount != null) ...[
                  const SizedBox(height: 32),
                  const Text('Resultados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildResultCard('Valor Investido:', viewModel.totalInvested!),
                  _buildResultCard('Total em Juros:', viewModel.totalInterest!),
                  _buildResultCard('Montante Final:', viewModel.finalAmount!, isFinal: true),
                  const SizedBox(height: 16),
                  Text(
                    '*Lembre-se: esta é apenas uma simulação. A rentabilidade pode variar.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isInteger = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
      ),
    );
  }
  
  Widget _buildResultCard(String title, double value, {bool isFinal = false}) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Card(
  color: isFinal ? Colors.green[700] : Colors.green,
  margin: const EdgeInsets.symmetric(vertical: 6.0),
  // ✅ 1. O child do Card agora é o DefaultTextStyle
  child: DefaultTextStyle(
    // ✅ 2. Defina o estilo padrão aqui
    style: const TextStyle(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Os Text widgets herdarão a cor branca automaticamente
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(format.format(value), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  ),
);
  }
  
  void _showHistoryModal(BuildContext context, List<InvestmentSimulation> history) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Histórico de Simulações', style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text('Nenhuma simulação no histórico.'))
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final sim = history[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('Montante Final: ${format.format(sim.finalAmount)}'),
                            subtitle: Text(
                              '${format.format(sim.initialAmount)} + ${format.format(sim.monthlyContribution)}/mês a ${sim.annualRate.toStringAsFixed(1)}% a.a. por ${sim.periodInMonths} meses',
                            ),
                            trailing: Text(DateFormat('dd/MM/yy').format(sim.date)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}