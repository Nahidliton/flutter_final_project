// lib/models/expense.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id; // Firestore Document ID
  final String name;
  final double amount;
  final DateTime date;
  final String category;
  final String? description;
  final DateTime createdAt;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    this.description,
    required this.createdAt,
  });

  // --- Factory Constructor: Convert Firestore Map to Expense Object ---
  factory Expense.fromMap(Map<String, dynamic> data, String id) {
    return Expense(
      id: id,
      name: data['name'] as String? ?? 'N/A',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] as String? ?? 'Other',
      description: data['description'] as String?,
      // Convert Firestore Timestamp to Dart DateTime
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // --- Method: Convert Expense Object to Firestore Map ---
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'description': description,
      // Convert Dart DateTime to Firestore Timestamp
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Helper for updating/editing
  Expense copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? date,
    String? category,
    String? description,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
