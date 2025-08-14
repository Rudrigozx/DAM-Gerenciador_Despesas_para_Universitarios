import 'package:flutter/material.dart';
import '../../domain/models/meta_model.dart';

class MetaCard extends StatelessWidget {
  final Meta meta;
  const MetaCard({super.key, required this.meta});

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Viagens': return Icons.airplanemode_active;
      case 'Estudos': return Icons.school;
      case 'Veículo': return Icons.directions_car;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Pega o tema atual

    return Card(
      color: theme.colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(_getIconForCategory(meta.categoria), size: 30, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meta.descricao, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${meta.valorAtual.toStringAsFixed(2)} / R\$ ${meta.valorObjetivo.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: meta.progresso,
                          backgroundColor: theme.colorScheme.surfaceVariant, // Cor de fundo da barra
                          color: theme.colorScheme.primary, // Cor de progresso da barra
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(meta.progresso * 100).toStringAsFixed(1)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}