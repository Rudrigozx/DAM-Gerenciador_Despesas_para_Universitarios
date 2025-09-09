import 'package:fin_plus/ui/expenses_list/ExpensesListPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Models/wallet_model.dart';
import '../../data/repositories/TransactionRepository.dart';
import '../../data/repositories/wallet_repository.dart';
import '../widgets/color_picker.dart';
import '../widgets/icon_picker.dart';

class WalletListPage extends StatefulWidget {
  const WalletListPage({super.key});

  @override
  State<WalletListPage> createState() => _WalletListPageState();
}

class _WalletListPageState extends State<WalletListPage> {
  final WalletRepository _walletRepository = WalletRepository();
  final TransactionRepository _transactionRepository = TransactionRepository();
  bool _isLoading = true;
  List<Wallet> _wallets = [];
  Map<int, double> _walletBalances = {};

  @override
  void initState() {
    super.initState();
    loadWalletsAndBalances();
  }

  Future<void> loadWalletsAndBalances() async {
    setState(() => _isLoading = true);

    final wallets = await _walletRepository.getAllWallets();
    final balances = <int, double>{};
    for (var wallet in wallets) {
      final transactionSum = await _transactionRepository.getCurrentBalanceForWallet(wallet.name);
      balances[wallet.id!] = wallet.initialBalance + transactionSum;
    }

    setState(() {
      _wallets = wallets;
      _walletBalances = balances;
      _isLoading = false;
    });
  }

  Future<void> _deleteWallet(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir esta carteira?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('CANCELAR')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('EXCLUIR')),
        ],
      ),
    );

    if (confirmed == true) {
      await _walletRepository.deleteWallet(id);
      loadWalletsAndBalances();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Carteiras'),
      ),
      // Lógica para exibir a lista ou a mensagem de lista vazia
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wallets.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma carteira encontrada.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Clique no botão + para adicionar sua primeira carteira.',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _wallets.length,
        itemBuilder: (context, index) {
          final wallet = _wallets[index];
          final currentBalance = _walletBalances[wallet.id] ?? 0.0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: wallet.color.withOpacity(0.2),
                child: Icon(wallet.icon, color: wallet.color),
              ),
              title: Text(wallet.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Saldo: R\$ ${currentBalance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: currentBalance < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.receipt_long_outlined, color: Colors.blueGrey),
                    tooltip: 'Ver transações',
                    onPressed: () {
                      Navigator.of(context).pushNamed('expenses-list', arguments: {'walletName': wallet.name});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Excluir carteira',
                    onPressed: () => _deleteWallet(wallet.id!),
                  ),
                ],
              ),
              onTap: () {
                _showWalletFormDialog(wallet: wallet).then((_) => loadWalletsAndBalances());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWalletFormDialog().then((_) => loadWalletsAndBalances());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showWalletFormDialog({Wallet? wallet}) async {
    final isEditing = wallet != null;
    final nameController = TextEditingController(text: wallet?.name ?? '');
    final balanceController = TextEditingController(text: wallet?.initialBalance.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00');

    IconData selectedIcon = wallet?.icon ?? Icons.account_balance_wallet;
    Color selectedColor = wallet?.color ?? Colors.teal;

    final List<IconData> icons = [
      Icons.account_balance_wallet, Icons.credit_card, Icons.savings,
      Icons.monetization_on, Icons.business, Icons.account_balance,
      Icons.attach_money, Icons.account_circle, Icons.payments, Icons.wallet,
      Icons.currency_exchange, Icons.store, Icons.laptop_chromebook,
    ];
    final List<Color> colors = [
      Colors.teal, Colors.blueGrey, Colors.green, Colors.indigo,
      Colors.brown, Colors.deepOrange, Colors.cyan, Colors.purple,
      Colors.amber, Colors.lime, Colors.grey, Colors.black,
    ];

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar Carteira' : 'Nova Carteira'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nome da Carteira'),
                      autofocus: true,
                    ),
                    TextField(
                      controller: balanceController,
                      decoration: const InputDecoration(labelText: 'Saldo Inicial', prefixText: 'R\$ '),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 20),
                    Text('Ícone', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    IconPicker(
                      selectedIcon: selectedIcon,
                      onIconSelected: (icon) => setDialogState(() => selectedIcon = icon),
                      availableIcons: icons,
                    ),
                    const SizedBox(height: 20),
                    Text('Cor', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    ColorPicker(
                      selectedColor: selectedColor,
                      onColorSelected: (color) => setDialogState(() => selectedColor = color),
                      availableColors: colors,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('O nome da carteira não pode ser vazio.'), backgroundColor: Colors.red),
                      );
                      return;
                    }
                    final balance = double.tryParse(balanceController.text.replaceAll(',', '.')) ?? 0.0;
                    final newWallet = Wallet(
                      id: wallet?.id,
                      name: nameController.text.trim(),
                      initialBalance: balance,
                      iconCodePoint: selectedIcon.codePoint,
                      colorValue: selectedColor.value,
                    );
                    if (isEditing) {
                      await _walletRepository.updateWallet(newWallet);
                    } else {
                      await _walletRepository.addWallet(newWallet);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('SALVAR'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}