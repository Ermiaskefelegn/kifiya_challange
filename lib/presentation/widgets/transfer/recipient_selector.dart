import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/transfer.dart';

class RecipientSelector extends StatelessWidget {
  final List<Recipient> recipients;
  final Recipient? selectedRecipient;
  final Function(Recipient) onRecipientSelected;

  const RecipientSelector({
    Key? key,
    required this.recipients,
    required this.selectedRecipient,
    required this.onRecipientSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipients.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddRecipientButton();
          }

          final recipient = recipients[index - 1];
          final isSelected = selectedRecipient?.id == recipient.id;

          return GestureDetector(
            onTap: () => onRecipientSelected(recipient),
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.md),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: AppColors.primary, width: 3) : null,
                    ),
                    child: CircleAvatar(
                      radius: isSelected ? 27 : 30,
                      backgroundImage: NetworkImage(recipient.avatar),
                      backgroundColor: AppColors.border,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    recipient.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddRecipientButton() {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(Icons.add, color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Add', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
