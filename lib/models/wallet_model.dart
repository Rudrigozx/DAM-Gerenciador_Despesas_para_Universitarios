import 'package:flutter/cupertino.dart';

class Wallet {
  final int? id;
  final String name;
  final double initialBalance; // Saldo inicial da carteira/conta
  final int iconCodePoint;
  final int colorValue;

  Wallet({
    this.id,
    required this.name,
    required this.initialBalance,
    required this.iconCodePoint,
    required this.colorValue,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  // Métodos para conversão (essenciais para o SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'initialBalance': initialBalance,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'],
      name: map['name'],
      initialBalance: map['initialBalance'],
      iconCodePoint: map['iconCodePoint'],
      colorValue: map['colorValue'],
    );
  }
}