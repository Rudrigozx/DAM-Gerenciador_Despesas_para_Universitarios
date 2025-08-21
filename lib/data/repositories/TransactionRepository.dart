import 'package:sqflite/sqflite.dart' hide Transaction;
import '../../Models/transaction_data.dart';
import '../services/DatabaseService.dart';

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

  // BUSCAR transações de um mês e ano específicos
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

    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  // Buscar todas
  Future<List<Transaction>> getAllTransactions() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }
}