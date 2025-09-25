import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/transactions/transactions_bloc.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/transactions/transactions_filters.dart';
import '../../widgets/transactions/transactions_list.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Transactions'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    return TransactionFilters(
                      selectedFilter: state is TransactionLoaded ? state.selectedFilter : null,
                      onFilterChanged: (filter) {
                        context.read<TransactionBloc>().add(FilterTransactions(filter));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TransactionLoaded) {
                  return TransactionList(transactions: state.transactions);
                }

                if (state is TransactionError) {
                  return Center(
                    child: Text(state.message, style: const TextStyle(color: AppColors.error)),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        TextButton(
          onPressed: () {
            // Show date range picker
          },
          child: const Text(
            'Select Time Range',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
