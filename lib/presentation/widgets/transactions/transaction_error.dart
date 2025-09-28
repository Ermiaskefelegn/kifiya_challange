import 'package:flutter/material.dart';

class TransactionErrorWidget extends StatelessWidget {
  const TransactionErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'An error occurred while loading transactions.',
        style: TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
