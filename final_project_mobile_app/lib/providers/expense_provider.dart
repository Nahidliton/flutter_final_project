import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  String? userId;

  // Load expenses for logged-in user
  Future<void> loadExpenses(String uid) async {
    userId = uid;
    final snapshot = await _db
        .collection('expenses')
        .doc(uid)
        .collection('userExpenses')
        .get();

    _expenses = snapshot.docs
        .map((doc) => Expense.fromMap(doc.id, doc.data()))
        .toList();

    notifyListeners();
  }

  // Add Expense
  Future<void> addExpense(Expense expense) async {
    if (userId == null) return;

    await _db
        .collection('expenses')
        .doc(userId)
        .collection('userExpenses')
        .add(expense.toMap());

    await loadExpenses(userId!);
  }

  // Delete Expense
  Future<void> deleteExpense(String id) async {
    if (userId == null) return;

    await _db
        .collection('expenses')
        .doc(userId)
        .collection('userExpenses')
        .doc(id)
        .delete();

    await loadExpenses(userId!);
  }
}
