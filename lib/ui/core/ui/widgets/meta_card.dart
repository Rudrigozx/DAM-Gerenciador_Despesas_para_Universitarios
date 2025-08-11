// lib/ui/widgets/meta_card.dart
import 'package:fin_plus/domain/models/meta_model.dart';
import 'package:flutter/material.dart';

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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(_getIconForCategory(meta.categoria), size: 30, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meta.descricao, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('R\$ ${meta.valorAtual.toStringAsFixed(2)} / R\$ ${meta.valorObjetivo.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: meta.progresso,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(meta.progresso * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
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