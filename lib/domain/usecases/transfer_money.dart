import '../entities/transfer.dart';
import '../repositories/transfer_repository.dart';

class TransferMoney {
  final TransferRepository repository;

  TransferMoney(this.repository);

  Future<bool> call(Transfer transfer) async {
    return await repository.transferMoney(transfer);
  }
}