import 'package:flutter/material.dart';

class TransacoesPlaceholderView extends StatelessWidget {
  const TransacoesPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tela de Transações', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}