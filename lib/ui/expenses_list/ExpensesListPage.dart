
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../Models/transaction_data.dart';
import '../../data/repositories/TransactionRepository.dart';

class ExpensesListPage extends StatefulWidget {
  const ExpensesListPage({super.key});

  @override
  State<ExpensesListPage> createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  final TransactionRepository _repository = TransactionRepository();

  bool _isLoading = true;
  DateTime _selectedMonth = DateTime.now();
  List<Transaction> _transactions = [];

  // Getter para agrupar as transações por dia
  Map<DateTime, List<Transaction>> get groupedTransactions {
    final map = <DateTime, List<Transaction>>{};
    for (var tx in _transactions) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      if (map[day] == null) {
        map[day] = [];
      }
      map[day]!.add(tx);
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });
    final transactions = await _repository.getTransactionsByMonth(_selectedMonth);
    setState(() {
      _transactions = transactions;
      _isLoading = false;
    });
  }

  void changeMonth(int monthIncrement) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + monthIncrement, 1);
    });
    fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _repository.deleteTransaction(id);
    fetchTransactions();
  }

  void _showTransactionModal(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Detalhes da transação
              Text(transaction.description, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'R\$ ${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: transaction.type == TransactionType.expense ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 32),

              // Mais detalhes em linhas
              _buildDetailRow('Data:', DateFormat('dd/MM/yyyy').format(transaction.date)),
              _buildDetailRow('Categoria:', transaction.category),

              const SizedBox(height: 24),

              // Botões de Ação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('EDITAR'),
                    onPressed: () async {
                      Navigator.of(ctx).pop(); // Fecha o modal
                      await context.push('/transaction/edit/${transaction.id}');
                      fetchTransactions();
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      deleteTransaction(transaction.id!);
                      Navigator.of(ctx).pop(); // Fecha o modal
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Seletor de Mês
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => changeMonth(-1)),
                Text(
                  DateFormat('MMMM yyyy').format(_selectedMonth).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => changeMonth(1)),
              ],
            ),
          ),

          // Lista de Transações
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildTransactionList(),
          ),

          // TODO: Rodapé com totais
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final grouped = groupedTransactions;
    final days = grouped.keys.toList();

    if (days.isEmpty && !_isLoading) {
      return const Center(child: Text('Nenhuma transação encontrada para este mês.'));
    }

    return ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final transactionsForDay = grouped[day]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                DateFormat('dd \'de\' MMMM').format(day),
                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
            ),
            ...transactionsForDay.map((tx) => ListTile(
              leading: CircleAvatar(
                child: Icon(_getIconForCategory(tx.category)),
              ),
              title: Text(tx.description),
              subtitle: Text(tx.category),
              trailing: Text(
                'R\$ ${tx.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: tx.type == TransactionType.expense ? Colors.redAccent : Colors.green,
                ),
              ),
              onTap: () => _showTransactionModal(tx),
            )),
          ],
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    // Lógica simples para retornar um ícone com base na categoria
    switch (category.toLowerCase()) {
      case 'transporte': return Icons.directions_bus;
      case 'alimentação': return Icons.restaurant;
      case 'salário': return Icons.attach_money;
      case 'lazer': return Icons.sports_esports;
      case 'moradia': return Icons.home;
      case 'aluguel': return Icons.house;
      default: return Icons.shopping_bag_outlined;
    }
  }
}