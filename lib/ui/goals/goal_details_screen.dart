import 'package:fin_plus/domain/models/goal_model.dart';
import 'package:fin_plus/ui/goals/my_goals_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GoalDetailsScreen extends StatelessWidget {
  final int goalId;
  const GoalDetailsScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    // Usamos o ViewModel global que já existe
    final viewModel = context.watch<MyGoalsViewModel>();

    // O FutureBuilder agora envolve toda a lógica da tela
    return FutureBuilder<Goal?>(
      future: viewModel.getGoalById(goalId),
      builder: (context, snapshot) {
        
        // Estado de Carregamento: Mostra um Scaffold simples com um spinner.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Carregando...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Estado de Erro ou Sem Dados
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: const Center(child: Text('Meta não encontrada.')),
          );
        }

        // Estado de Sucesso: construímos o Scaffold completo, pois já temos a meta.
        final goal = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes da Meta'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Agora 'goal' está acessível aqui e a navegação funciona.
                  context.push('/goals/edit/${goal.id}', extra: goal);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmation(context, viewModel, goalId),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.description, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text(
                  'R\$ ${goal.currentAmount.toStringAsFixed(2)} / R\$ ${goal.targetAmount.toStringAsFixed(2)}',
                   style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: goal.progress,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                Text('${(goal.progress * 100).toStringAsFixed(1)}% completo'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.savings_outlined),
                    label: const Text('ADICIONAR VALOR'),
                    onPressed: () => _showAddValueDialog(context, viewModel, goal),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Lógica para o diálogo de adicionar valor
  void _showAddValueDialog(BuildContext context, MyGoalsViewModel viewModel, Goal goal) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Guardar Dinheiro'),
        content: TextField(
          controller: amountController,
          decoration: const InputDecoration(labelText: 'Valor a adicionar (R\$)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('CANCELAR')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (amount > 0) {
                viewModel.addValueToGoal(goal, amount);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  // Lógica para o diálogo de confirmação de exclusão
  void _showDeleteConfirmation(BuildContext context, MyGoalsViewModel viewModel, int goalId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir esta meta? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('CANCELAR')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              viewModel.deleteGoal(goalId);
              Navigator.of(ctx).pop(); // Fecha o diálogo
              context.pop(); // Volta para a lista de metas
            },
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }
}