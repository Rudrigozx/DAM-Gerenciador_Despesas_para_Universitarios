import 'dart:math';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/transaction_data.dart';
import '../models/wallet_model.dart';
import '../data/repositories/TransactionRepository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/wallet_repository.dart';

class DatabaseSeeder {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();
  final WalletRepository _walletRepo = WalletRepository();

  Future<void> seedDatabase() async {
    final wallets = await _seedWallets();
    final categories = await _seedCategories();

    final existingTransactions = await _transactionRepo.getAllTransactions();
    if (existingTransactions.isNotEmpty) {
      print('O banco de dados de transações já está populado. Seeding ignorado.');
      return;
    }

    print('Semeando transações...');
    final random = Random();
    final now = DateTime.now();

    for (int monthOffset = 0; monthOffset < 3; monthOffset++) {
      // Gera de 10 a 20 transações por mês
      int transactionsPerMonth = 10 + random.nextInt(11);

      for (int i = 0; i < transactionsPerMonth; i++) {
        // Gera uma data aleatória dentro do mês atual do loop
        final month = now.month - monthOffset;
        final year = now.year;
        final day = 1 + random.nextInt(28); // Simples, para evitar problemas com meses diferentes
        final date = DateTime(year, month, day, random.nextInt(24), random.nextInt(60));

        // Escolhe aleatoriamente uma categoria e carteira
        final randomCategory = categories[random.nextInt(categories.length)];
        final randomWallet = wallets[random.nextInt(wallets.length)];

        // Define o tipo e os dados da transação
        TransactionType type;
        String description;
        String? sourceAccount;
        String? destinationAccount;

        // Lógica para gerar dados mais realistas
        if (randomCategory.name == 'Salário') {
          type = TransactionType.income;
          description = 'Salário do Mês';
          sourceAccount = null;
          destinationAccount = randomWallet.name;
        } else {
          type = TransactionType.expense;
          description = _getRandomExpenseDescription();
          sourceAccount = randomWallet.name;
          destinationAccount = null;
        }

        final transaction = Transaction(
          description: description,
          amount: (20 + random.nextDouble() * 280).roundToDouble(), // Valor entre 20 e 300
          category: randomCategory.name,
          type: type,
          date: date,
          sourceAccount: sourceAccount,
          destinationAccount: destinationAccount,
        );

        await _transactionRepo.addTransaction(transaction);
      }
    }
    print('Semeação de transações concluída!');
  }

  Future<List<Wallet>> _seedWallets() async {
    var wallets = await _walletRepo.getAllWallets();
    if (wallets.isEmpty) {
      print('Semeando carteiras...');
      await _walletRepo.addWallet(Wallet(name: 'Carteira Principal', initialBalance: 150.0, iconCodePoint: Icons.account_balance_wallet.codePoint, colorValue: Colors.blue.value));
      await _walletRepo.addWallet(Wallet(name: 'Cartão de Crédito', initialBalance: 0.0, iconCodePoint: Icons.credit_card.codePoint, colorValue: Colors.orange.value));
      wallets = await _walletRepo.getAllWallets();
    }
    return wallets;
  }

  Future<List<Category>> _seedCategories() async {
    // A lógica de seeding já está no repositório de categoria, vamos apenas chamá-la.
    return await _categoryRepo.getAllCategories();
  }

  String _getRandomExpenseDescription() {
    final descriptions = [
      'Almoço no restaurante', 'Café da tarde', 'Compra no supermercado',
      'Conta de luz', 'Plano de internet', 'Gasolina', 'Cinema com amigos',
      'Uber para o trabalho', 'Farmácia', 'Livro novo',
    ];
    return descriptions[Random().nextInt(descriptions.length)];
  }
}