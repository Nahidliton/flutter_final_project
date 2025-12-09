// lib/providers/expense_provider.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

class ExpenseProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Expense> _allExpenses = [];

  // --- Filters State ---
  String? _categoryFilter;
  String _sortOption = kSortOptions.first;
  String _searchQuery = '';

  ExpenseProvider() {
    _initStream();
  }

  // ----------------------------------------------------
  // I. Stream Initialization & Data Management
  // ----------------------------------------------------

  void _initStream() {
    // Listen to the Firestore stream and update local state
    _firestoreService.streamExpenses().listen((expenses) {
      _allExpenses = expenses;
      notifyListeners();
    });
  }

  // CRUD Operations
  Future<void> addExpense(Expense expense) =>
      _firestoreService.addExpense(expense);
  Future<void> updateExpense(Expense expense) =>
      _firestoreService.updateExpense(expense);
  Future<void> deleteExpense(String expenseId) =>
      _firestoreService.deleteExpense(expenseId);

  // ----------------------------------------------------
  // II. Getters & Calculations
  // ----------------------------------------------------

  String? get categoryFilter => _categoryFilter;
  String get sortOption => _sortOption;
  String get searchQuery => _searchQuery;

  double get totalExpense {
    return _allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getCategoryTotal(String category) {
    return _allExpenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // ----------------------------------------------------
  // III. Filtering and Sorting Logic
  // ----------------------------------------------------

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setSortOption(String sort) {
    _sortOption = sort;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<Expense> get filteredAndSortedExpenses {
    List<Expense> result = _allExpenses;

    // 1. Filtering by Category
    if (_categoryFilter != null) {
      result = result.where((e) => e.category == _categoryFilter).toList();
    }

    // 2. Filtering by Search Query (Name)
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((e) => e.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    // 3. Sorting
    result.sort((a, b) {
      switch (_sortOption) {
        case 'Date (Newest First)':
          return b.date.compareTo(a.date);
        case 'Date (Oldest First)':
          return a.date.compareTo(b.date);
        case 'Amount (High to Low)':
          return b.amount.compareTo(a.amount);
        case 'Amount (Low to High)':
          return a.amount.compareTo(b.amount);
        default:
          return b.date.compareTo(a.date); // Default to newest date
      }
    });

    return result;
  }
}
