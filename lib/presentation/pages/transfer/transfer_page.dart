import 'package:flutter/material.dart';
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
  List<Recipient> _recipients = [];
  Recipient? _selectedRecipient;

  @override
  void initState() {
    super.initState();
    _loadRecipients();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'From',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            const AccountSelector(accountNumber: '00342745928'),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'To',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
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
            CustomButton(text: 'Send', onPressed: _canTransfer() ? _handleTransfer : null),
          ],
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
      fromAccountId: '1',
      toRecipientId: _selectedRecipient!.id,
      amount: amount,
      purpose: _selectedPurpose,
      date: DateTime.now(),
    );

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Successful'),
        content: Text(
          'Transfer of \$${amount.toStringAsFixed(2)} to ${_selectedRecipient!.name} completed successfully.',
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
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
