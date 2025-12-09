// lib/utils/constants.dart

import 'package:flutter/material.dart';

const List<String> kExpenseCategories = [
  'Food',
  'Transport',
  'Entertainment',
  'Shopping',
  'Bills',
  'Other',
];

const List<String> kSortOptions = [
  'Date (Newest First)',
  'Date (Oldest First)',
  'Amount (High to Low)',
  'Amount (Low to High)',
];

Map<String, Color> kCategoryColors = {
  'Food': const Color(0xFFFF9800),
  'Transport': const Color(0xFF2196F3),
  'Entertainment': const Color(0xFF9C27B0),
  'Shopping': const Color(0xFF4CAF50),
  'Bills': const Color(0xFFF44336),
  'Other': const Color(0xFF757575),
};

Map<String, IconData> kCategoryIcons = {
  'Food': Icons.restaurant,
  'Transport': Icons.directions_car,
  'Entertainment': Icons.movie,
  'Shopping': Icons.shopping_bag,
  'Bills': Icons.description,
  'Other': Icons.category,
};

const List<Color> kGradientColors = [
  Color(0xFF6366F1),
  Color(0xFF8B5CF6),
];
