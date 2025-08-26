// lib/ui/home/new_goal_view.dart
import 'package:fin_plus/data/repositories/goal_repository.dart';
import 'package:fin_plus/data/repositories/mock_goal_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'new_goal_viewmodel.dart';

class NewGoalView extends StatelessWidget {
  const NewGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewGoalViewModel(MockGoalRepositoryImpl() as IGoalRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Meta'), // Texto da UI em português
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Consumer<NewGoalViewModel>(
          builder: (context, viewModel, child) {
            return Form(
              key: viewModel.formKey,
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  TextFormField(
                    controller: viewModel.descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição'), // UI
                    validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null, // UI
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: viewModel.selectedCategory,
                    decoration: const InputDecoration(labelText: 'Categoria'), // UI
                    items: viewModel.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) => viewModel.setSelectedCategory(newValue),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: viewModel.targetAmountController,
                    decoration:  InputDecoration(labelText: 'Objetivo (R\$)'), // UI
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório'; // UI
                      if (double.tryParse(value!) == null) return 'Valor inválido'; // UI
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () async {
                      final success = await viewModel.createGoal();
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meta criada com sucesso!'), backgroundColor: Colors.green), // UI
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao criar meta.'), backgroundColor: Colors.red), // UI
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
                        : const Text('Criar'), // UI
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