import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String name;
  final String number;
  final double balance;
  final String type;
  final String lastUpdated;

  const Account({
    required this.id,
    required this.name,
    required this.number,
    required this.balance,
    required this.type,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [id, name, number, balance, type, lastUpdated];
}
