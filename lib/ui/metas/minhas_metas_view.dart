// lib/ui/home/minhas_metas_view.dart
import 'package:fin_plus/data/repositories/mock_meta_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/meta_card.dart';
import 'minhas_metas_viewmodel.dart';
import 'nova_meta_view.dart';

class MinhasMetasView extends StatelessWidget {
  const MinhasMetasView({super.key});

  @override
  Widget build(BuildContext context) {
    // Injeta o ViewModel na árvore de widgets
    return ChangeNotifierProvider(
      create: (_) => MinhasMetasViewModel(MockMetaRepositoryImpl())..fetchMetas(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Metas'),
        ),
        body: Consumer<MinhasMetasViewModel>(
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NovaMetaView()),
            ).then((_) {
              // Recarrega as metas quando voltar da tela de criação
              Provider.of<MinhasMetasViewModel>(context, listen: false).fetchMetas();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context, MinhasMetasViewModel viewModel) {
    const categories = ['Todas', 'Viagens', 'Estudos', 'Veículo'];
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

  Widget _buildBody(BuildContext context, MinhasMetasViewModel viewModel) {
    if (viewModel.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.state == ViewState.error) {
      return const Center(child: Text('Ocorreu um erro ao buscar suas metas.'));
    }
    if (viewModel.filteredMetas.isEmpty) {
        return const Center(child: Text('Nenhuma meta encontrada.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: viewModel.filteredMetas.length,
      itemBuilder: (context, index) {
        final meta = viewModel.filteredMetas[index];
        return MetaCard(meta: meta);
      },
    );
  }
}