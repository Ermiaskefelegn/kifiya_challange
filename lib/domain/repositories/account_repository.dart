import '../entities/account.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts();
  Future<Account> getAccountById(String id);
}