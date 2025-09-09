// lib/ui/home/my_goals_view.dart
import 'package:fin_plus/ui/goals/my_goals_viewModel.dart';
import 'package:fin_plus/ui/widgets/goal_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class MyGoalsView extends StatelessWidget {
  const MyGoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Injeta o ViewModel na árvore de widgets
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Metas'),
      ),
      body: Consumer<MyGoalsViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              _buildCategoryFilters(context, viewModel),
              Expanded(child: _buildBody(context, viewModel)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'my_goals_fab',
        onPressed: () async {
          await context.push('/goals/new');
    
          if(!context.mounted) return;
          
            Provider.of<MyGoalsViewModel>(context, listen: false).fetchGoals();
        
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context, MyGoalsViewModel viewModel) {
    const categories = ['Todas', 'Viagem', 'Estudos', 'Veículo'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = viewModel.selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => viewModel.selectCategory(category),
              // O tema cuida das cores e estilos de texto
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 8),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyGoalsViewModel viewModel) {
    if (viewModel.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.state == ViewState.error) {
      return const Center(child: Text('Ocorreu um erro ao buscar suas metas.'));
    }
    if (viewModel.filteredGoals.isEmpty) {
      return const Center(child: Text('Nenhuma meta encontrada.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: viewModel.filteredGoals.length,
      itemBuilder: (context, index) {
        final goal = viewModel.filteredGoals[index];
        return GoalCard(goal: goal);
      },
    );
  }
}