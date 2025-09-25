import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/usecases/get_accounts.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccounts getAccounts;

  AccountBloc(this.getAccounts) : super(AccountInitial()) {
    on<LoadAccounts>(_onLoadAccounts);
  }

  Future<void> _onLoadAccounts(LoadAccounts event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      final accounts = await getAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
