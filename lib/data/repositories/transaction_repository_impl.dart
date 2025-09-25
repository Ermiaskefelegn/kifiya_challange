import '../../domain/entities/transactions.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/api_service.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final ApiRemoteDataSource apiRemoteDataSource;
  final LocalDataSource localDataSource;

  TransactionRepositoryImpl(this.apiRemoteDataSource, this.localDataSource);

  @override
  Future<List<Transaction>> getTransactions() async {
    return await apiRemoteDataSource.getTransactions();
  }

  @override
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final transactions = await getTransactions();
    return transactions.where((t) => t.type == type).toList();
  }
}
