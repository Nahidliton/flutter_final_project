// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_card.dart';
import '../widgets/category_filter_chip.dart';
import '../widgets/stats_card.dart';
import 'add_edit_expense_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Consumer<ExpenseProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(context, provider),
                      const SizedBox(height: 16),
                      _buildStatsRow(context, provider),
                      const SizedBox(height: 16),
                      _buildCategoryFilter(context, provider),
                      const SizedBox(height: 16),
                      _buildSortOptions(context, provider),
                    ],
                  );
                },
              ),
            ),
          ),
          Consumer<ExpenseProvider>(
            builder: (context, provider, _) {
              final expenses = provider.filteredAndSortedExpenses;

              if (expenses.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No expenses yet',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first expense to get started',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final groupedExpenses = _groupExpensesByDate(expenses);

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final dateStr = groupedExpenses.keys.toList()[index];
                    final dayExpenses = groupedExpenses[dateStr]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Text(
                            dateStr,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        ...dayExpenses.map((expense) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ExpenseCard(
                              expense: expense,
                              onEdit: () => _editExpense(context, expense),
                              onDelete: () => _deleteExpense(
                                  context, provider, expense.id!),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                  childCount: groupedExpenses.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddEditExpenseScreen(),
          ));
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: kGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FlexibleSpaceBar(
          title: const Text(
            'ExpenseTrack',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: false,
          expandedTitleScale: 1.2,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ExpenseProvider provider) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        provider.setSearchQuery(value);
      },
      decoration: InputDecoration(
        hintText: 'Search expenses...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  provider.setSearchQuery('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, ExpenseProvider provider) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            icon: Icons.trending_down,
            title: 'Total',
            amount: '\$${provider.totalExpense.toStringAsFixed(2)}',
            color: const Color(0xFFF44336),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            icon: Icons.shopping_bag,
            title: 'Shopping',
            amount:
                '\$${provider.getCategoryTotal('Shopping').toStringAsFixed(2)}',
            color: const Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context, ExpenseProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryFilterChip(
            label: 'All',
            isSelected: provider.categoryFilter == null,
            onTap: () => provider.setCategoryFilter(null),
          ),
          ...kExpenseCategories.map((category) {
            return CategoryFilterChip(
              label: category,
              color: kCategoryColors[category],
              icon: kCategoryIcons[category],
              isSelected: provider.categoryFilter == category,
              onTap: () => provider.setCategoryFilter(category),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSortOptions(BuildContext context, ExpenseProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sort by:',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        PopupMenuButton(
          onSelected: (value) => provider.setSortOption(value),
          itemBuilder: (context) {
            return kSortOptions.map((option) {
              return PopupMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.sortOption,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.expand_more, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, List> _groupExpensesByDate(List expenses) {
    final grouped = <String, List>{};
    for (var expense in expenses) {
      final dateStr = DateFormat('EEE, MMM dd').format(expense.date);
      grouped.putIfAbsent(dateStr, () => []);
      grouped[dateStr]!.add(expense);
    }
    return grouped;
  }

  void _editExpense(BuildContext context, expense) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddEditExpenseScreen(expense: expense),
    ));
  }

  void _deleteExpense(
      BuildContext context, ExpenseProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteExpense(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expense deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
