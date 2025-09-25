import '../entities/transactions.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<List<Transaction>> getTransactionsByType(TransactionType type);
}
