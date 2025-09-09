

import '../../models/wallet_model.dart';
import '../services/DatabaseService.dart';

class WalletRepository {
  final dbService = DatabaseService();

  Future<int> addWallet(Wallet wallet) async {
    final db = await dbService.database;
    return await db.insert('wallets', wallet.toMap());
  }

  Future<int> updateWallet(Wallet wallet) async {
    final db = await dbService.database;
    return await db.update(
      'wallets',
      wallet.toMap(),
      where: 'id = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<void> deleteWallet(int id) async {
    final db = await dbService.database;
    await db.delete('wallets', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Wallet>> getAllWallets() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('wallets', orderBy: 'name ASC');

    return List.generate(maps.length, (i) => Wallet.fromMap(maps[i]));
  }
}