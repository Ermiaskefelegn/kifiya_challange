import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kifiya_challenge/domain/entities/transactions.dart';

import '../../../domain/usecases/get_transactions.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;

  TransactionBloc(this.getTransactions) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<FilterTransactions>(_onFilterTransactions);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final transactions = await getTransactions();
      emit(TransactionLoaded(transactions, null));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onFilterTransactions(FilterTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final transactions = await getTransactions(type: event.type);
      emit(TransactionLoaded(transactions, event.type));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
