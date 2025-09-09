import '../transactions/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/transaction_data.dart';
import 'expenses_list_viewmodel.dart';

class ExpensesListPage extends StatelessWidget {
  final String? walletName;

  const ExpensesListPage({super.key, this.walletName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpensesListViewModel(),
      child: Consumer<ExpensesListViewModel>(
        builder: (context, viewModel, child) {
          final emptyListMessage = walletName != null
              ? 'Nenhuma transação para a carteira "$walletName" neste mês.'
              : 'Nenhuma transação encontrada para este mês.';

          return Scaffold(
            appBar: AppBar(
              title: Text(walletName ?? 'Minhas Transações'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => viewModel.changeMonth(-1)),
                      Text(
                        DateFormat('MMMM yyyy', 'pt_BR')
                            .format(viewModel.selectedMonth)
                            .toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => viewModel.changeMonth(1)),
                    ],
                  ),
                ),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.transactions.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(emptyListMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600])),
                    ),
                  )
                      : _buildTransactionList(context, viewModel),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TransactionsPage(
                          initialType: TransactionType.expense)),
                ).then((_) {
                  viewModel.fetchTransactions();
                });
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(
      BuildContext context, ExpensesListViewModel viewModel) {
    final grouped = viewModel.groupedTransactions;
    final days = grouped.keys.toList();

    if (days.isEmpty && !viewModel.isLoading) {
      return const Center(
          child: Text('Nenhuma transação encontrada para este mês.'));
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
                DateFormat('dd \'de\' MMMM', 'pt_BR').format(day),
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
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
                  color: tx.type == TransactionType.expense
                      ? Colors.redAccent
                      : Colors.green,
                ),
              ),
              onTap: () => _showTransactionModal(context, tx, viewModel),
            )),
          ],
        );
      },
    );
  }

  void _showTransactionModal(BuildContext context, Transaction transaction,
      ExpensesListViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.description,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'R\$ ${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: transaction.type == TransactionType.expense
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 32),
              _buildDetailRow(
                  'Data:', DateFormat('dd/MM/yyyy').format(transaction.date)),
              _buildDetailRow('Categoria:', transaction.category),
              if (transaction.type != TransactionType.income)
                _buildDetailRow(
                    'Conta de Origem:', transaction.sourceAccount ?? 'N/A'),
              if (transaction.type != TransactionType.expense)
                _buildDetailRow('Conta de Destino:',
                    transaction.destinationAccount ?? 'N/A'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('EDITAR'),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await context.push('/transaction/edit/${transaction.id}');
                      viewModel.fetchTransactions();
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label:
                    const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      viewModel.deleteTransaction(transaction.id!);
                      Navigator.of(ctx).pop();
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

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'transporte':
        return Icons.directions_bus;
      case 'alimentação':
        return Icons.restaurant;
      case 'salário':
        return Icons.attach_money;
      case 'lazer':
        return Icons.sports_esports;
      case 'moradia':
        return Icons.home;
      case 'aluguel':
        return Icons.house;
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}