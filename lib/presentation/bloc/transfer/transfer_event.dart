part of 'transfer_bloc.dart';

abstract class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipients extends TransferEvent {}

class SubmitTransfer extends TransferEvent {
  final Transfer transfer;

  const SubmitTransfer(this.transfer);

  @override
  List<Object> get props => [transfer];
}
