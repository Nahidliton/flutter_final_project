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
  'Food': const Color(0xFFFF6B35),      // Vibrant Orange
  'Transport': const Color(0xFF004E89), // Deep Blue
  'Entertainment': const Color(0xFFD62828), // Bold Red
  'Shopping': const Color(0xFF06A77D),  // Teal Green
  'Bills': const Color(0xFFF77F00),     // Dark Orange
  'Other': const Color(0xFF6C757D),     // Neutral Gray
};

Map<String, IconData> kCategoryIcons = {
  'Food': Icons.fastfood,           // Fast food icon
  'Transport': Icons.directions_car, // Car icon
  'Entertainment': Icons.movie,     // Movie icon
  'Shopping': Icons.shopping_bag,   // Shopping bag icon
  'Bills': Icons.receipt,           // Receipt icon
  'Other': Icons.category,          // Category icon
};

const List<Color> kGradientColors = [
  Color(0xFF6366F1),
  Color(0xFF8B5CF6),
];
