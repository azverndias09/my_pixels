import 'package:flutter/material.dart';

class GenderBadge extends StatelessWidget {
  final String? gender;
  final double size;

  const GenderBadge({super.key, this.gender, this.size = 20});

  @override
  Widget build(BuildContext context) {
    // Determine color and icon based on gender
    final isFemale = gender == 'Female';
    final color = isFemale ? Colors.pink : Colors.blue;
    final icon = isFemale ? Icons.favorite : Icons.star;
    final iconColor = isFemale ? Colors.white : Colors.yellowAccent;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: size, color: iconColor),
    );
  }
}
