import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/transfer.dart';

abstract class LocalDataSource {
  Future<List<Account>> getCachedAccounts();
  Future<void> cacheAccounts(List<Account> accounts);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<Account>> getCachedAccounts() async {
    // Return mock data for demonstration
    return [
      const Account(
        id: '1',
        name: 'Saving',
        number: '1000***548',
        balance: 2200.0,
        type: 'savings',
        lastUpdated: '01/24',
      ),
      const Account(
        id: '2',
        name: 'Checking',
        number: '1000***483',
        balance: 650.0,
        type: 'checking',
        lastUpdated: '04/23',
      ),
    ];
  }

  @override
  Future<void> cacheAccounts(List<Account> accounts) async {
    // Implementation for caching accounts
  }
}
