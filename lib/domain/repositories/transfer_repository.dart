import '../entities/transfer.dart';

abstract class TransferRepository {
  Future<List<Recipient>> getRecipients();
  Future<bool> transferMoney(Transfer transfer);
}