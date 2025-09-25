import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/api_service.dart';

class AccountRepositoryImpl implements AccountRepository {
  final ApiRemoteDataSource apiRemoteDataSource;
  final LocalDataSource localDataSource;

  AccountRepositoryImpl(this.apiRemoteDataSource, this.localDataSource);

  @override
  Future<List<Account>> getAccounts() async {
    try {
      final accounts = await apiRemoteDataSource.getAccounts();
      await localDataSource.cacheAccounts(accounts);
      return accounts;
    } catch (e) {
      return await localDataSource.getCachedAccounts();
    }
  }

  @override
  Future<Account> getAccountById(String id) async {
    final accounts = await getAccounts();
    return accounts.firstWhere((account) => account.id == id);
  }
}
