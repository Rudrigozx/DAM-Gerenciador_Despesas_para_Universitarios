import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final IconData selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  final List<IconData> availableIcons;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.availableIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableIcons.map((icon) {
        final isSelected = selectedIcon == icon;
        return GestureDetector(
          onTap: () => onIconSelected(icon),
          child: Container(
            padding: const EdgeInsets.all(4), // Espaço para a borda
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(icon, size: 28, color: isSelected ? Colors.blue : Colors.grey[700]),
            ),
          ),
        );
      }).toList(),
    );
  }
}