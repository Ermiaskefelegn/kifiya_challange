import 'package:flutter/material.dart';
import 'package:kifiya_challenge/domain/entities/transactions.dart';
import '../../../core/theme/app_theme.dart';
import '../common/custom_list_tile.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onViewAll;

  const RecentTransactions({Key? key, required this.transactions, required this.onViewAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text(
                'View All',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: transactions.map((transaction) {
              return CustomListTile(
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
              );
            }).toList(),
          ),
        ),
      ],
    );
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
      decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }
}
