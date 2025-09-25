import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/common_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: Center(
        child: Text('Profile Page', style: TextStyle(fontSize: 24, color: AppColors.textPrimary)),
      ),
    );
  }
}
