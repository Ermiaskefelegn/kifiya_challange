import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../common/custom_list_tile.dart';

class AccountActions extends StatelessWidget {
  const AccountActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          CustomListTile(
            leading: _buildActionIcon(Icons.receipt_outlined, AppColors.primary),
            title: 'View Statement',
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border),
          CustomListTile(
            leading: _buildActionIcon(Icons.lock_outlined, AppColors.warning),
            title: 'Change Pin',
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border),
          CustomListTile(
            leading: _buildActionIcon(Icons.delete_outline, AppColors.error),
            title: 'Remove Card',
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
