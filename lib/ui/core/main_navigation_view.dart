// lib/ui/core/main_navigation_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_navigation_viewmodel.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainNavigationViewModel(),
      child: Consumer<MainNavigationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // O body agora é dinâmico, vindo do ViewModel.
            // Isso troca a tela inteira quando a aba muda.
            body: IndexedStack(
              index: viewModel.currentIndex,
              children: viewModel.screens, // Reutiliza a lista de telas do ViewModel
            ),
            
            bottomNavigationBar: BottomNavigationBar(
              // O índice atual também vem do ViewModel
              currentIndex: viewModel.currentIndex,
              
              // A função de callback chama o método do ViewModel
              onTap: viewModel.onTabTapped,

              // Estilo para manter os ícones visíveis mesmo quando não selecionados
              type: BottomNavigationBarType.fixed, 
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              
              // Lista de itens da barra de navegação
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.track_changes), // Ícone de alvo
                  label: 'Metas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz),
                  label: 'Transações',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Carteira',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}