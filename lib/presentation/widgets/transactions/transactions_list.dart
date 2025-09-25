import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kifiya_challenge/domain/entities/transactions.dart';

import '../../../core/theme/app_theme.dart';
import '../common/custom_list_tile.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate(transactions);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final entry = groupedTransactions.entries.elementAt(index);
        final dateLabel = entry.key;
        final dayTransactions = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                dateLabel,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: dayTransactions.asMap().entries.map((entry) {
                  final transactionIndex = entry.key;
                  final transaction = entry.value;
                  final isLast = transactionIndex == dayTransactions.length - 1;

                  return Column(
                    children: [
                      CustomListTile(
                        leading: _buildTransactionIcon(transaction),
                        title: transaction.title,
                        subtitle: transaction.category,
                        trailing: Text(
                          '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: transaction.amount > 0 ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                      if (!isLast) const Divider(height: 1, color: AppColors.border),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        );
      },
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<String, List<Transaction>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final transaction in transactions) {
      final transactionDate = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);

      String dateLabel;
      if (transactionDate == today) {
        dateLabel = 'Today';
      } else if (transactionDate == yesterday) {
        dateLabel = 'Yesterday';
      } else {
        dateLabel = DateFormat('MMM dd, yyyy').format(transactionDate);
      }

      if (!grouped.containsKey(dateLabel)) {
        grouped[dateLabel] = [];
      }
      grouped[dateLabel]!.add(transaction);
    }

    return grouped;
  }

  Widget _buildTransactionIcon(Transaction transaction) {
    IconData iconData;
    Color iconColor;

    switch (transaction.category.toLowerCase()) {
      case 'shopping':
        iconData = Icons.shopping_cart_outlined;
        iconColor = AppColors.warning;
        break;
      case 'bills':
        iconData = Icons.receipt_outlined;
        iconColor = AppColors.error;
        break;
      case 'salary':
        iconData = Icons.attach_money;
        iconColor = AppColors.success;
        break;
      default:
        iconData = Icons.account_balance_wallet_outlined;
        iconColor = AppColors.primary;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }
}
