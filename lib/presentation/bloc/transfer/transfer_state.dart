part of 'transfer_bloc.dart';

abstract class TransferState extends Equatable {
  const TransferState();

  @override
  List<Object> get props => [];
}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferSuccess extends TransferState {}

class TransferError extends TransferState {
  final String message;

  const TransferError(this.message);

  @override
  List<Object> get props => [message];
}
