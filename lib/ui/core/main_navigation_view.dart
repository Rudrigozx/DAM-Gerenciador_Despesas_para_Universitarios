// lib/ui/core/main_navigation_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_navigation_viewmodel.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainNavigationViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: viewModel.currentIndex,
        children: viewModel.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.currentIndex,
        onTap: viewModel.onTabTapped,

        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        
        items: viewModel.items, 
      ),
    );
  }
}