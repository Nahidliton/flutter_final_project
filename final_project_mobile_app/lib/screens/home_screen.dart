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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              _buildHeader(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsSection(context, provider),
                      const SizedBox(height: 24),
                      _buildQuickActions(context, provider),
                      const SizedBox(height: 24),
                      _buildSearchAndFilters(context, provider),
                    ],
                  ),
                ),
              ),
              _buildExpensesList(context, provider),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()))
              .then((result) {
            if (result != null && result is Map) {
              final ok = result['ok'] == true;
              final message = result['message']?.toString() ?? '';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: ok ? Colors.green : Colors.red,
                ),
              );
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
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
              fontSize: 22,
            ),
          ),
          centerTitle: false,
          expandedTitleScale: 1.1,
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, ExpenseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Spending Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.trending_down,
                title: 'Total Spent',
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
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ExpenseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.add_circle_outline,
                label: 'Add',
                color: const Color(0xFF6366F1),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()))
                      .then((result) {
                    if (result != null && result is Map) {
                      final ok = result['ok'] == true;
                      final message = result['message']?.toString() ?? '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: ok ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.category,
                label: 'Filter',
                color: const Color(0xFF9C27B0),
                onTap: () {
                  _showFilterBottomSheet(context, provider);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.sort,
                label: 'Sort',
                color: const Color(0xFF2196F3),
                onTap: () {
                  _showSortBottomSheet(context, provider);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, ExpenseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(context, provider),
        const SizedBox(height: 16),
        _buildCategoryFilter(context, provider),
      ],
    );
  }

  Widget _buildExpensesList(BuildContext context, ExpenseProvider provider) {
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
                  'Tap "Add Expense" to record your first expense',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Text(
                  dateStr,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                ),
              ),
              ...dayExpenses.map((expense) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ExpenseCard(
                    expense: expense,
                    onEdit: () => _editExpense(context, expense),
                    onDelete: () => _deleteExpense(context, provider, expense.id!),
                  ),
                );
              }).toList(),
            ],
          );
        },
        childCount: groupedExpenses.length,
      ),
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

  void _showFilterBottomSheet(BuildContext context, ExpenseProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Category',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryFilterChip(
                    label: 'All',
                    isSelected: provider.categoryFilter == null,
                    onTap: () {
                      provider.setCategoryFilter(null);
                      Navigator.pop(context);
                    },
                  ),
                  ...kExpenseCategories.map((category) {
                    return CategoryFilterChip(
                      label: category,
                      color: kCategoryColors[category],
                      icon: kCategoryIcons[category],
                      isSelected: provider.categoryFilter == category,
                      onTap: () {
                        provider.setCategoryFilter(category);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, ExpenseProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Expenses',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...kSortOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    provider.setSortOption(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: provider.sortOption == option
                          ? const Color(0xFF6366F1).withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: provider.sortOption == option
                            ? const Color(0xFF6366F1)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          provider.sortOption == option
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: provider.sortOption == option
                              ? const Color(0xFF6366F1)
                              : Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
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
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
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
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, ExpenseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CategoryFilterChip(
              label: 'All',
              color: Colors.grey.shade700,
              icon: Icons.all_inclusive,
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
      ],
    );
  }


  void _editExpense(BuildContext context, expense) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddEditExpenseScreen(expense: expense)))
        .then((result) {
      if (result != null && result is Map) {
        final ok = result['ok'] == true;
        final message = result['message']?.toString() ?? '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: ok ? Colors.green : Colors.red,
          ),
        );
      }
    });
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
