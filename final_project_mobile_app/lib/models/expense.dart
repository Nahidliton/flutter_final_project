class Expense {
  String id;
  String name;
  double amount;
  DateTime date;
  String category;
  String description;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Convert from Firestore Map
  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),
      category: map['category'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
