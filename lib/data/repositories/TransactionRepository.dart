import '../../Models/transaction_data.dart';
import '../services/DatabaseService.dart';

class TransactionRepository {
  final dbService = DatabaseService();

  // Adicionar uma nova transação
  Future<int> addTransaction(Transaction transaction) async {
    final db = await dbService.database;
    // O método insert retorna o ID do novo registro inserido.
    return await db.insert('transactions', transaction.toMap());
  }

  // Buscar todas as transações
  Future<List<Transaction>> getAllTransactions() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  // Atualizar uma transação
  Future<void> updateTransaction(Transaction transaction) async {
    final db = await dbService.database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Deletar uma transação
  Future<void> deleteTransaction(int id) async {
    final db = await dbService.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}