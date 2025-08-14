import 'package:flutter/material.dart';

class CarteiraPlaceholderView extends StatelessWidget {
  const CarteiraPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tela da Carteira', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}