import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/transactions/transactions_bloc.dart';
import '../../widgets/home/balance_card.dart';
import '../../widgets/home/quick_actions.dart';
import '../../widgets/home/account_summary.dart';
import '../../widgets/home/recent_transactions.dart';
import '../transfer/transfer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  if (state is AccountLoaded && state.accounts.isNotEmpty) {
                    final totalBalance = state.accounts.map((a) => a.balance).reduce((a, b) => a + b);
                    return BalanceCard(balance: totalBalance);
                  }
                  return const BalanceCard(balance: 0.0);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              QuickActions(
                onActionTap: (action) {
                  if (action == 'transfer') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TransferPage()));
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  if (state is AccountLoaded) {
                    return AccountSummary(
                      accounts: state.accounts,
                      onViewAll: () {
                        // Navigate to accounts page
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoaded) {
                    return RecentTransactions(
                      transactions: state.transactions.take(2).toList(),
                      onViewAll: () {
                        // Navigate to transactions page
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: AppColors.primary.withOpacity(0.1)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=150',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, color: AppColors.primary, size: 24);
              },
            ),
          ),
        ),
      ],
    );
  }
}
