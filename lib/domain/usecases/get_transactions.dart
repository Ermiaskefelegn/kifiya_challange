import '../entities/transactions.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call({TransactionType? type}) async {
    if (type != null) {
      return await repository.getTransactionsByType(type);
    }
    return await repository.getTransactions();
  }
}
