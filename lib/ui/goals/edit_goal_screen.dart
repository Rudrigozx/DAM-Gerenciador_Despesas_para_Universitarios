import 'package:fin_plus/domain/models/goal_model.dart';
import 'package:fin_plus/ui/goals/my_goals_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Usaremos um StatefulWidget para gerenciar o estado do formulário facilmente
class EditGoalScreen extends StatefulWidget {
  final Goal initialGoal; // 1. Recebe a meta a ser editada
  const EditGoalScreen({super.key, required this.initialGoal});

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _targetAmountController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    // 2. Pré-preenche os campos com os dados da meta existente
    _descriptionController = TextEditingController(text: widget.initialGoal.description);
    _targetAmountController = TextEditingController(text: widget.initialGoal.targetAmount.toString());
    _selectedCategory = widget.initialGoal.category;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o ViewModel global
    final viewModel = context.read<MyGoalsViewModel>();
    const categories = ['Viagem', 'Estudos', 'Veículo', 'Outro'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Meta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(value: category, child: Text(category));
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => _selectedCategory = newValue);
                }
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _targetAmountController,
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
              onPressed: () {
                // 3. Valida o formulário e chama o método de ATUALIZAÇÃO
                if (_formKey.currentState?.validate() ?? false) {
                  final updatedGoal = widget.initialGoal.copyWith(
                    description: _descriptionController.text,
                    category: _selectedCategory,
                    targetAmount: double.parse(_targetAmountController.text),
                  );
                  viewModel.updateGoal(updatedGoal);
                  Navigator.of(context).pop(); // Volta para a tela de detalhes
                }
              },
              child: const Text('SALVAR ALTERAÇÕES'),
            ),
          ],
        ),
      ),
    );
  }
}