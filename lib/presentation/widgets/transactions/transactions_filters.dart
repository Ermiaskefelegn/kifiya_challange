import 'package:flutter/material.dart';
import 'package:kifiya_challenge/domain/entities/transactions.dart';
import '../../../core/theme/app_theme.dart';

class TransactionFilters extends StatelessWidget {
  final TransactionType? selectedFilter;
  final Function(TransactionType?) onFilterChanged;

  const TransactionFilters({super.key, required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip(label: 'All', isSelected: selectedFilter == null, onTap: () => onFilterChanged(null)),
        const SizedBox(width: AppSpacing.md),
        _buildFilterChip(
          label: 'Income',
          isSelected: selectedFilter == TransactionType.income,
          onTap: () => onFilterChanged(TransactionType.income),
          color: AppColors.success,
        ),
        const SizedBox(width: AppSpacing.md),
        _buildFilterChip(
          label: 'Expense',
          isSelected: selectedFilter == TransactionType.expense,
          onTap: () => onFilterChanged(TransactionType.expense),
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? chipColor : chipColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: isSelected ? Colors.white : chipColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : chipColor, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
