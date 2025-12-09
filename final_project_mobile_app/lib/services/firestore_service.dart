// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirestoreService {
  late final FirebaseFirestore _db;
  late final CollectionReference _expenseCollection;

  FirestoreService() {
    _db = FirebaseFirestore.instance;
    // Note: We are using a single collection for simplicity.
    // In a real app with user auth, you'd scope this by user ID:
    // _expenseCollection = _db.collection('users').doc(userId).collection('expenses');
    _expenseCollection = _db.collection('expenses');
  }

  // --- Real-Time Stream of Expenses (READ) ---
  Stream<List<Expense>> streamExpenses() {
    // Basic sorting by date
    return _expenseCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // --- Add New Expense (CREATE) ---
  Future<void> addExpense(Expense expense) {
    return _expenseCollection.add(expense.toMap());
  }

  // --- Update Existing Expense (UPDATE) ---
  Future<void> updateExpense(Expense expense) {
    if (expense.id == null) {
      throw Exception("Expense ID cannot be null for update.");
    }
    return _expenseCollection.doc(expense.id).update(expense.toMap());
  }

  // --- Delete Expense (DELETE) ---
  Future<void> deleteExpense(String expenseId) {
    return _expenseCollection.doc(expenseId).delete();
  }
}
