import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  final Function(String) onActionTap;

  const QuickActions({Key? key, required this.onActionTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(icon: Icons.swap_horiz, label: 'Transfer', onTap: () => onActionTap('transfer')),
        _buildActionItem(icon: Icons.receipt_long, label: 'Bills', onTap: () => onActionTap('bills')),
        _buildActionItem(icon: Icons.phone_android, label: 'Recharge', onTap: () => onActionTap('recharge')),
        _buildActionItem(icon: Icons.more_horiz, label: 'More', onTap: () => onActionTap('more')),
      ],
    );
  }

  Widget _buildActionItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
