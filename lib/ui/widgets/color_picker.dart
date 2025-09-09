import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color> availableColors;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.availableColors,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableColors.map((color) {
        final isSelected = selectedColor.value == color.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: color,
            ),
          ),
        );
      }).toList(),
    );
  }
}