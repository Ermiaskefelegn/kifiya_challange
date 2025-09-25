import '../models/transfer/transfer_request.dart';
import '../../domain/entities/transfer.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/api_remote_datasource.dart';

class TransferRepositoryImpl implements TransferRepository {
  final ApiRemoteDataSource apiRemoteDataSource;
  final LocalDataSource localDataSource;

  TransferRepositoryImpl(this.apiRemoteDataSource, this.localDataSource);

  @override
  Future<List<Recipient>> getRecipients() async {
    return await apiRemoteDataSource.getRecipients();
  }

  @override
  Future<bool> transferMoney(Transfer transfer) async {
    try {
      final request = TransferRequest(
        fromAccountNumber: transfer.fromAccountId,
        toAccountNumber: transfer.toRecipientId,
        amount: transfer.amount,
      );

      await apiRemoteDataSource.transferMoney(request);
      return true;
    } catch (e) {
      return false;
    }
  }
}
