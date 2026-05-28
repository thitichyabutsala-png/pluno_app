import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

String formatSaves(int saves) =>
    saves >= 1000 ? '${(saves / 1000).toStringAsFixed(1)}k' : saves.toString();

int parseBudget(String s) =>
    int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

Color tagColor(String tag) {
  switch (tag) {
    case 'Beach':
      return const Color(0xFF0288D1);
    case 'Luxury':
      return const Color(0xFF7B1FA2);
    case 'Romance':
      return const Color(0xFFE91E8C);
    case 'Adventure':
      return C.accent;
    case 'Mountain':
    case 'Hiking':
      return const Color(0xFF2E7D32);
    case 'Culture':
      return const Color(0xFFF57C00);
    case 'Food':
    case 'Food Tour':
      return const Color(0xFFD32F2F);
    case 'Budget':
      return const Color(0xFF00796B);
    case 'City':
      return const Color(0xFF455A64);
    case 'Nature':
    case 'Wellness':
      return C.primary;
    case 'Photography':
      return C.blue;
    default:
      return C.primary;
  }
}

Color activityColor(String type) {
  switch (type) {
    case 'food':
      return C.accent;
    case 'transport':
      return const Color(0xFF6B7FD4);
    case 'hotel':
      return C.blue;
    case 'photo':
      return C.purple;
    case 'coffee':
      return const Color(0xFF8B6B4A);
    default:
      return C.primary;
  }
}

IconData activityIcon(String type) {
  switch (type) {
    case 'food':
      return Icons.restaurant;
    case 'transport':
      return Icons.directions_bus;
    case 'hotel':
      return Icons.hotel;
    case 'photo':
      return Icons.camera_alt;
    case 'coffee':
      return Icons.local_cafe;
    default:
      return Icons.terrain;
  }
}

BoxDecoration softCard({double radius = 24}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.black.withOpacity(.04)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(.06),
        blurRadius: 12,
        offset: const Offset(0, 2),
      )
    ],
  );
}
