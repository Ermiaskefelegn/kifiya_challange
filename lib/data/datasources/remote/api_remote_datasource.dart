import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/network/dio/dio_client.dart';
import 'package:kifiya_challenge/core/network/dio/network_exception_hundler.dart';
import 'package:kifiya_challenge/core/services/log_service.dart';
import 'package:kifiya_challenge/domain/entities/transactions.dart';
import '../../../core/constants/constants.dart';
import '../../models/account/account_model.dart';
import '../../models/transaction/transaction_model.dart';
import '../../models/transfer/transfer_request.dart';
import '../../models/transfer/transfer_response.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/entities/transfer.dart';

class ApiRemoteDataSource {
  final DioClient dioClient;
  final LogService logService;

  ApiRemoteDataSource({required this.dioClient, required this.logService});

  Future<List<Account>> getAccounts() async {
    try {
      final response = await dioClient.get(Constants.accounts);
      final List<dynamic> data = response.data['content'] ?? response.data;
      return data.map((json) => AccountModel.fromJson(json)).toList();
    } catch (e) {
      throw parseDioError(e);
    }
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final accounts = await getAccounts();
      if (accounts.isEmpty) return [];

      final response = await dioClient.get('${Constants.transactions}/${accounts.first.id}');
      final List<dynamic> data = response.data['content'] ?? response.data;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      throw parseDioError(e);
    }
  }

  Future<List<Recipient>> getRecipients() async {
    try {
      // Mocked recipients as API doesn’t provide endpoint
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        const Recipient(
          id: '1',
          name: 'Aliya',
          avatar: 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=150',
        ),
        const Recipient(
          id: '2',
          name: 'Calira',
          avatar: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=150',
        ),
        const Recipient(
          id: '3',
          name: 'Bob',
          avatar: 'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=150',
        ),
        const Recipient(
          id: '4',
          name: 'Samy',
          avatar: 'https://images.pexels.com/photos/1845534/pexels-photo-1845534.jpeg?auto=compress&cs=tinysrgb&w=150',
        ),
        const Recipient(
          id: '5',
          name: 'Sara',
          avatar: 'https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&w=150',
        ),
      ];
    } catch (e) {
      throw parseDioError(e);
    }
  }

  Future<TransferResponse> transferMoney(TransferRequest request) async {
    try {
      final response = await dioClient.post(Constants.transfer, data: request.toJson());
      return TransferResponse.fromJson(response.data);
    } catch (e) {
      throw parseDioError(e);
    }
  }
}
