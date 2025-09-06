//
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../Models/category.dart';
import '../services/DatabaseService.dart';

class CategoryRepository {
  final dbService = DatabaseService();

  Future<void> _seedInitialCategories(Database db) async {
    final List<Category> initialCategories = [
      Category(name: 'Alimentação', iconCodePoint: Icons.restaurant.codePoint, colorValue: Colors.red.value),
      Category(name: 'Transporte', iconCodePoint: Icons.directions_bus.codePoint, colorValue: Colors.blue.value),
      Category(name: 'Moradia', iconCodePoint: Icons.home.codePoint, colorValue: Colors.orange.value),
      Category(name: 'Lazer', iconCodePoint: Icons.sports_esports.codePoint, colorValue: Colors.green.value),
      Category(name: 'Salário', iconCodePoint: Icons.attach_money.codePoint, colorValue: Colors.teal.value),
      Category(name: 'Educação', iconCodePoint: Icons.school.codePoint, colorValue: Colors.purple.value),
    ];

    for (var category in initialCategories) {
      await db.insert('categories', category.toMap());
    }
  }

  Future<int> addCategory(Category category) async {
    final db = await dbService.database;
    return await db.insert('categories', category.toMap());
  }

  Future<int> updateCategory(Category category) async {
    final db = await dbService.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await dbService.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('categories', orderBy: 'name ASC');

    if (maps.isEmpty) {
      await _seedInitialCategories(db);
      final newMaps = await db.query('categories', orderBy: 'name ASC');
      return List.generate(newMaps.length, (i) => Category.fromMap(newMaps[i]));
    }

    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }
}