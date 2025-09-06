import 'package:flutter/material.dart';

class HomePlaceholderView extends StatelessWidget {
  const HomePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tela Principal (Home)', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}