// lib/screens/add_edit_expense_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({this.expense, super.key});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _nameController.text = widget.expense!.name;
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
      _descriptionController.text = widget.expense!.description ?? '';
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    } else {
      _selectedCategory = kExpenseCategories.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    final newExpense = Expense(
      id: widget.expense?.id,
      name: _nameController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _selectedDate,
      category: _selectedCategory!,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: widget.expense?.createdAt ?? DateTime.now(),
    );

    try {
      // Protect against indefinitely waiting writes by using a timeout.
      if (widget.expense == null) {
        await provider.addExpense(newExpense)
            .timeout(const Duration(seconds: 10));

        if (!mounted) return;
        // Stop loading, show a success message here with an icon, then go home.
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Expense added successfully!')),
              ],
            ),
            duration: Duration(milliseconds: 900),
          ),
        );
        // Wait a short moment so the user sees the message, then navigate back.
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.of(context).pop(true);
      } else {
        await provider.updateExpense(newExpense)
            .timeout(const Duration(seconds: 10));

        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Expense updated successfully!')),
              ],
            ),
            duration: Duration(milliseconds: 900),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) Navigator.of(context).pop(true);
      }
    } on Exception catch (e) {
      // On timeout or other exception, show the error here so the user sees it
      // and remains on the Add/Edit screen to retry or cancel.
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving expense: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(
                  'Expense Name',
                  _buildTextInput(
                    controller: _nameController,
                    hintText: 'e.g., Coffee at Starbucks',
                    icon: Icons.shopping_bag,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an expense name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputSection(
                  'Amount',
                  _buildTextInput(
                    controller: _amountController,
                    hintText: '0.00',
                    icon: Icons.currency_exchange,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      try {
                        double.parse(value);
                      } catch (e) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputSection(
                  'Category',
                  _buildCategorySelector(),
                ),
                const SizedBox(height: 24),
                _buildInputSection(
                  'Date',
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 22, color: Colors.grey.shade600),
                              const SizedBox(width: 14),
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.expand_more,
                              color: Colors.grey.shade600, size: 22),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildInputSection(
                  'Description (Optional)',
                  _buildTextInput(
                    controller: _descriptionController,
                    hintText: 'Add notes...',
                    icon: Icons.note,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveExpense,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(isEditing ? 'Update Expense' : 'Add Expense'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: DropdownButton<String>(
        value: _selectedCategory,
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: (newValue) {
          setState(() => _selectedCategory = newValue);
        },
        items: kExpenseCategories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Row(
              children: [
                Icon(
                  kCategoryIcons[category],
                  color: kCategoryColors[category],
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
