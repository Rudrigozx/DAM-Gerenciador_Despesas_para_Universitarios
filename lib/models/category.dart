import 'package:flutter/material.dart';

class Category {
  final int? id;
  final String name;
  final int iconCodePoint; // Armazena o 'codePoint' do Ícone (ex: Icons.shopping_cart.codePoint)
  final int colorValue;    // Armazena o valor da cor (ex: Colors.blue.value)

  Category({
    this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
  });

  // Construtores 'get' para facilitar o uso do ícone e da cor na UI
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconCodePoint: map['iconCodePoint'],
      colorValue: map['colorValue'],
    );
  }
}