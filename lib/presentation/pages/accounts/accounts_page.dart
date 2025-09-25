import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kifiya_challenge/presentation/widgets/common/common_app_bar.dart';

import '../../../core/theme/app_theme.dart';
import '../../bloc/account/account_bloc.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/accounts/account_card.dart';
import '../../widgets/accounts/account_actions.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'My Accounts'),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountLoaded && state.accounts.isNotEmpty) {
            final account = state.accounts.first;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  AccountCard(account: account),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPaymentDue(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildActionButtons(),
                  const SizedBox(height: AppSpacing.lg),
                  const AccountActions(),
                ],
              ),
            );
          }

          return const Center(child: Text('No accounts available'));
        },
      ),
    );
  }

  Widget _buildPaymentDue() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make a Payment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              SizedBox(height: 4),
              Text('Due: Feb 10, 2022', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
          const Text(
            '\$220',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(text: 'Settings', type: ButtonType.secondary, onPressed: () {}),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: CustomButton(text: 'Transactions', type: ButtonType.secondary, onPressed: () {}),
        ),
      ],
    );
  }
}
