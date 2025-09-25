import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/account.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel extends Account {
  const AccountModel({
    required super.id,
    required super.name,
    required super.number,
    required super.balance,
    required super.type,
    required super.lastUpdated,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'].toString(),
      name: _getAccountTypeName(json['accountType']),
      number: json['accountNumber'],
      balance: (json['balance'] as num).toDouble(),
      type: json['accountType'],
      lastUpdated: DateTime.now().toString().substring(0, 5), // Format as MM/YY
    );
  }

  static String _getAccountTypeName(String type) {
    switch (type) {
      case 'CHECKING':
        return 'Checking';
      case 'SAVINGS':
        return 'Savings';
      case 'MONEY_MARKET':
        return 'Money Market';
      case 'INDIVIDUAL_RETIREMENT_ACCOUNT':
        return 'IRA';
      case 'FIXED_TIME_DEPOSIT':
        return 'Fixed Deposit';
      case 'SPECIAL_BLOCKED_ACCOUNT':
        return 'Special Account';
      default:
        return 'Account';
    }
  }

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}