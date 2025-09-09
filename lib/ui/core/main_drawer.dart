import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        // Remove qualquer padding da ListView
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              // Usando o logo que você já tem nos assets
              child: Image.asset('assets/logos/Logo_fin.png', height: 40),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.calculate_outlined,
            text: 'Orçamentos',
            routeName: '/budgets', // Rota a ser criada
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.receipt_long_outlined,
            text: 'Contas Fixas',
            routeName: '/fixed-bills', // Rota a ser criada
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.trending_up_outlined,
            text: 'Simulador de Rendimentos',
            routeName: '/simulator', // Rota a ser criada
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.bar_chart_outlined,
            text: 'Relatórios',
            routeName: '/reports', // Rota a ser criada
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar os itens do menu de forma consistente
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required String routeName,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text),
      onTap: () {
        // Primeiro, fecha o drawer
        Navigator.of(context).pop();
        // Depois, navega para a rota desejada
        context.push(routeName);
      },
    );
  }
}