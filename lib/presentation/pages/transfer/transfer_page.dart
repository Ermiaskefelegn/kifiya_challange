import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kifiya_challenge/domain/entities/account.dart';
import 'package:kifiya_challenge/presentation/bloc/account/account_bloc.dart';
import 'package:kifiya_challenge/presentation/bloc/transfer/transfer_bloc.dart';
import '../../../core/di/dependency_Injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/transfer.dart';
import '../../../domain/repositories/transfer_repository.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_input_field.dart';
import '../../widgets/transfer/account_selector.dart';
import '../../widgets/transfer/recipient_selector.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _amountController = TextEditingController();
  String _selectedPurpose = 'Education';
  Account? _selectedAccount;
  List<Recipient> _recipients = [];
  Recipient? _selectedRecipient;

  @override
  void initState() {
    super.initState();
    _loadRecipients();
    loadAmount();
  }

  loadAmount() {
    context.read<AccountBloc>().add(LoadAccounts());
  }

  Future<void> _loadRecipients() async {
    final repository = getIt<TransferRepository>();
    final recipients = await repository.getRecipients();
    setState(() {
      _recipients = recipients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Transfer',
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is AccountLoaded) {
                setState(() {
                  _selectedAccount = state.accounts.first;
                });
              }
            },
          ),
          BlocListener<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is TransferSuccess) {
                // Show success message
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Transfer Successful'),
                    content: Text(
                      'Transfer of \$${_amountController.text} to ${_selectedRecipient!.name} completed successfully.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (state is TransferError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Transfer failed: ${state.message}')));
              }
            },
          ),
        ],
        child: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) {
            final isLoading = state is TransferLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AccountSelector(accountNumber: _selectedAccount?.number ?? ''),
                  const SizedBox(height: AppSpacing.xl),

                  const Text(
                    'To',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RecipientSelector(
                    recipients: _recipients,
                    selectedRecipient: _selectedRecipient,
                    onRecipientSelected: (recipient) {
                      setState(() {
                        _selectedRecipient = recipient;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  CustomInputField(
                    label: 'Amount',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    hint: '\$0.00',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  _buildPurposeDropdown(),
                  const SizedBox(height: AppSpacing.xxl),

                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(text: 'Send', onPressed: _canTransfer() ? _handleTransfer : null),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPurposeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Purpose',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPurpose,
              isExpanded: true,
              items: [
                'Education',
                'Business',
                'Personal',
                'Investment',
              ].map((purpose) => DropdownMenuItem(value: purpose, child: Text(purpose))).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPurpose = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _canTransfer() {
    return _amountController.text.isNotEmpty &&
        _selectedRecipient != null &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0;
  }

  void _handleTransfer() {
    if (!_canTransfer()) return;

    final amount = double.parse(_amountController.text);
    final transfer = Transfer(
      fromAccountId: _selectedAccount!.id,
      toRecipientId: _selectedRecipient!.id,
      amount: amount,
      purpose: _selectedPurpose,
      date: DateTime.now(),
    );

    // ✅ Dispatch SubmitTransfer event instead of directly showing dialog
    context.read<TransferBloc>().add(SubmitTransfer(transfer));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
