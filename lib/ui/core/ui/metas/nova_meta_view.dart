// lib/ui/home/nova_meta_view.dart
import 'package:fin_plus/data/repositories/mock_meta_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'nova_meta_viewmodel.dart';

class NovaMetaView extends StatelessWidget {
  const NovaMetaView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NovaMetaViewModel(MockMetaRepositoryImpl()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Meta'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Consumer<NovaMetaViewModel>(
          builder: (context, viewModel, child) {
            return Form(
              key: viewModel.formKey,
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  TextFormField(
                    controller: viewModel.descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: viewModel.selectedCategory,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: viewModel.categorias.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) => viewModel.setSelectedCategory(newValue),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: viewModel.objetivoController,
                    decoration: const InputDecoration(labelText: 'Objetivo (R\$)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório';
                      if (double.tryParse(value!) == null) return 'Valor inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () async {
                      final success = await viewModel.createMeta();
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meta criada com sucesso!'), backgroundColor: Colors.green),
                        );
                      } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao criar meta.'), backgroundColor: Colors.red),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Criar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}