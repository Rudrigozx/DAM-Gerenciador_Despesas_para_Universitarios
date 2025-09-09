import 'package:sqflite/sqflite.dart' hide Transaction;
import '../../Models/transaction_data.dart';
import '../services/DatabaseService.dart';
import '../../domain/models/report_data_model.dart';

class TransactionRepository {
  final dbService = DatabaseService();

  // Adicionar uma nova transação
  Future<int> addTransaction(Transaction transaction) async {
    final db = await dbService.database;
    return await db.insert('transactions', transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ATUALIZAR uma transação existente
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await dbService.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Deletar uma transação
  Future<void> deleteTransaction(int id) async {
    final db = await dbService.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

   // Calcula o saldo total (Receitas - Despesas)
  Future<double> getTotalBalance() async {
    final db = await dbService.database;
    final totalIncome = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type = ?",
        [TransactionType.income.index]);
    final totalExpense = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type = ?",
        [TransactionType.expense.index]);

    final income = (totalIncome.first['total'] as num?)?.toDouble() ?? 0.0;
    final expense = (totalExpense.first['total'] as num?)?.toDouble() ?? 0.0;

    return income - expense;
  }

  Future<ReportData> getReportData(DateTime startDate, DateTime endDate) async {
    final db = await dbService.database;
    final start = startDate.toIso8601String();
    final end = endDate.toIso8601String();

    // 1. Total de Receitas
    final incomeResult = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ?",
      [TransactionType.income.index, start, end]);
    final totalIncome = (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0;
    
    // 2. Total de Despesas
    final expenseResult = await db.rawQuery(
      "SELECT SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ?",
      [TransactionType.expense.index, start, end]);
    final totalExpenses = (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // 3. Despesas por Categoria (para o gráfico de pizza)
    final categoryResult = await db.rawQuery(
      "SELECT category, SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ? GROUP BY category",
      [TransactionType.expense.index, start, end]);
    final expensesByCategory = { for (var row in categoryResult) row['category'] as String : (row['total'] as num).toDouble() };

    // 4. Evolução Mensal (para o gráfico de barras)
    final evolutionResult = await db.rawQuery(
      "SELECT strftime('%Y-%m', date) as month, SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ? GROUP BY month ORDER BY month",
      [TransactionType.expense.index, start, end]);
    final monthlyEvolution = { for (var row in evolutionResult) row['month'] as String : (row['total'] as num).toDouble() };

    return ReportData(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      expensesByCategory: expensesByCategory,
      monthlyEvolution: monthlyEvolution,
    );
  }

  Future<List<Map<String, dynamic>>> getBalanceEvolution({int days = 7}) async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> dailyBalances = [];
    final today = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final dateString = date.toIso8601String();

      // Calcula o saldo total (receitas - despesas) até o final daquele dia específico
      final result = await db.rawQuery('''
        SELECT SUM(
          CASE
            WHEN type = ${TransactionType.income.index} THEN amount
            WHEN type = ${TransactionType.expense.index} THEN -amount
            ELSE 0
          END
        ) as totalBalance
        FROM transactions
        WHERE date <= ?
      ''', [dateString]);
      
      final balance = (result.first['totalBalance'] as num?)?.toDouble() ?? 0.0;
      dailyBalances.add({'date': date, 'balance': balance});
    }

    // A lista estará do dia mais recente para o mais antigo, então invertemos
    return dailyBalances.reversed.toList();
  }

  Future<double> getExpensesForMonth(DateTime month) async {
    final db = await dbService.database;
    final firstDay = DateTime(month.year, month.month, 1).toIso8601String();
    final lastDay = DateTime(month.year, month.month + 1, 0).toIso8601String();

    final result = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ?",
        [TransactionType.expense.index, firstDay, lastDay]);
    
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, double>> getExpensesByCategoryForMonth(DateTime month) async {
    final db = await dbService.database;
    final firstDay = DateTime(month.year, month.month, 1).toIso8601String();
    final lastDay = DateTime(month.year, month.month + 1, 0).toIso8601String();

    final result = await db.rawQuery(
      "SELECT category, SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ? GROUP BY category",
      [TransactionType.expense.index, firstDay, lastDay]);

    return { for (var row in result) row['category'] as String : (row['total'] as num).toDouble() };
  }

  Future<List<Transaction>> getTransactionsByMonth(DateTime date) async {
    final db = await dbService.database;
    
    // Formata o início e o fim do mês para a consulta SQL
    final firstDayOfMonth = DateTime(date.year, date.month, 1).toIso8601String();
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59).toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [firstDayOfMonth, lastDayOfMonth],
      orderBy: 'date DESC', // Ordena pela data mais recente primeiro
    );

    // Converte a lista de Maps em uma lista de objetos Transaction
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  // Buscar todas
  Future<List<Transaction>> getAllTransactions() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<double> getCurrentBalanceForWallet(String walletName) async {
    final db = await dbService.database;
    double balance = 0.0;

    final List<Map<String, dynamic>> incomeMaps = await db.query(
      'transactions',
      columns: ['amount'],
      where: 'destinationAccount = ? AND type = ?',
      whereArgs: [walletName, TransactionType.income.index],
    );
    for (var map in incomeMaps) {
      balance += (map['amount'] as double);
    }

    final List<Map<String, dynamic>> expenseMaps = await db.query(
      'transactions',
      columns: ['amount'],
      where: 'sourceAccount = ? AND type = ?',
      whereArgs: [walletName, TransactionType.expense.index],
    );
    for (var map in expenseMaps) {
      balance -= (map['amount'] as double);
    }

    final List<Map<String, dynamic>> transferInMaps = await db.query(
      'transactions',
      columns: ['amount'],
      where: 'destinationAccount = ? AND type = ?',
      whereArgs: [walletName, TransactionType.transfer.index],
    );
    for (var map in transferInMaps) {
      balance += (map['amount'] as double);
    }

    final List<Map<String, dynamic>> transferOutMaps = await db.query(
      'transactions',
      columns: ['amount'],
      where: 'sourceAccount = ? AND type = ?',
      whereArgs: [walletName, TransactionType.transfer.index],
    );
    for (var map in transferOutMaps) {
      balance -= (map['amount'] as double);
    }
    return balance;
  }

  Future<double> _getSumByTypeAndMonth(TransactionType type, DateTime date) async {
    final db = await dbService.database;
    final firstDayOfMonth = DateTime(date.year, date.month, 1).toIso8601String();
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND date BETWEEN ? AND ?',
        [type.index, firstDayOfMonth, lastDayOfMonth]
    );

    final total = result.first['total'];
    return (total is double) ? total : 0.0;
  }

  Future<double> getSumOfIncomesByMonth(DateTime date) async {
    return _getSumByTypeAndMonth(TransactionType.income, date);
  }

  Future<double> getSumOfExpensesByMonth(DateTime date) async {
    return _getSumByTypeAndMonth(TransactionType.expense, date);
  }
}