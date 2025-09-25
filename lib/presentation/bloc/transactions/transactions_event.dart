part of 'transactions_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class FilterTransactions extends TransactionEvent {
  final TransactionType? type;

  const FilterTransactions(this.type);

  @override
  List<Object?> get props => [type];
}
