import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/account.dart';
import '../common/custom_list_tile.dart';

class AccountSummary extends StatelessWidget {
  final List<Account> accounts;
  final VoidCallback onViewAll;

  const AccountSummary({Key? key, required this.accounts, required this.onViewAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Accounts',
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
            children: accounts.take(2).map((account) {
              return CustomListTile(
                leading: _buildAccountIcon(account.type),
                title: account.name,
                subtitle: account.number,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ETB ${account.balance.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      'last updated ${account.lastUpdated}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountIcon(String type) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: type == 'savings' ? AppColors.success.withOpacity(0.1) : AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        type == 'savings' ? Icons.savings_outlined : Icons.account_balance_wallet_outlined,
        color: type == 'savings' ? AppColors.success : AppColors.accent,
        size: 24,
      ),
    );
  }
}
