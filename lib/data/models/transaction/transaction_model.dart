import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/transactions.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.type,
    required super.category,
    required super.date,
    super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final isCredit = json['direction'] == 'CREDIT';
    final amount = (json['amount'] as num).toDouble();

    return TransactionModel(
      id: json['id'].toString(),
      title: _getTransactionTitle(json['type'], json['description']),
      amount: isCredit ? amount : -amount,
      type: isCredit ? TransactionType.income : TransactionType.expense,
      category: _getTransactionCategory(json['type']),
      date: DateTime.parse(json['timestamp']),
      description: json['description'],
    );
  }

  static String _getTransactionTitle(String type, String? description) {
    if (description != null && description.isNotEmpty) {
      return description;
    }

    switch (type) {
      case 'FUND_TRANSFER':
        return 'Transfer';
      case 'BILL_PAYMENT':
        return 'Bill Payment';
      case 'TELLER_DEPOSIT':
        return 'Deposit';
      case 'ATM_WITHDRAWAL':
        return 'ATM Withdrawal';
      case 'PURCHASE':
        return 'Purchase';
      case 'REFUND':
        return 'Refund';
      case 'INTEREST_EARNED':
        return 'Interest';
      case 'LOAN_PAYMENT':
        return 'Loan Payment';
      default:
        return 'Transaction';
    }
  }

  static String _getTransactionCategory(String type) {
    switch (type) {
      case 'FUND_TRANSFER':
        return 'Transfer';
      case 'BILL_PAYMENT':
        return 'Bills';
      case 'TELLER_DEPOSIT':
      case 'INTEREST_EARNED':
        return 'Income';
      case 'ATM_WITHDRAWAL':
      case 'PURCHASE':
        return 'Shopping';
      case 'LOAN_PAYMENT':
        return 'Loan';
      default:
        return 'Other';
    }
  }

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
