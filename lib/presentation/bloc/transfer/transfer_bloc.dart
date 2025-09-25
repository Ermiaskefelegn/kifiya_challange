import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/transfer.dart';
import '../../../domain/usecases/transfer_money.dart';
part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferMoney transferMoney;

  TransferBloc(this.transferMoney) : super(TransferInitial()) {
    on<LoadRecipients>(_onLoadRecipients);
    on<SubmitTransfer>(_onSubmitTransfer);
  }

  Future<void> _onLoadRecipients(LoadRecipients event, Emitter<TransferState> emit) async {
    // Implementation for loading recipients
  }

  Future<void> _onSubmitTransfer(SubmitTransfer event, Emitter<TransferState> emit) async {
    emit(TransferLoading());
    try {
      final success = await transferMoney(event.transfer);
      if (success) {
        emit(TransferSuccess());
      } else {
        emit(const TransferError('Transfer failed'));
      }
    } catch (e) {
      emit(TransferError(e.toString()));
    }
  }
}
