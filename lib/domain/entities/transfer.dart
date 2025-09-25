import 'package:equatable/equatable.dart';

class Transfer extends Equatable {
  final String fromAccountId;
  final String toRecipientId;
  final double amount;
  final String purpose;
  final DateTime date;

  const Transfer({
    required this.fromAccountId,
    required this.toRecipientId,
    required this.amount,
    required this.purpose,
    required this.date,
  });

  @override
  List<Object?> get props => [fromAccountId, toRecipientId, amount, purpose, date];
}

class Recipient extends Equatable {
  final String id;
  final String name;
  final String avatar;

  const Recipient({required this.id, required this.name, required this.avatar});

  @override
  List<Object?> get props => [id, name, avatar];
}
