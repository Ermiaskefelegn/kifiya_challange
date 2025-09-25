// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/network/dio/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kifiya_challenge/core/services/hive_storage_service.dart';
import 'package:kifiya_challenge/core/services/log_service.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/api_service.dart';
import '../../data/datasources/remote/auth_datasource.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/repositories/transfer_repository_impl.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../../domain/usecases/get_accounts.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/transfer_money.dart';
import '../../presentation/bloc/account/account_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/transactions/transactions_bloc.dart';
import '../../presentation/bloc/transfer/transfer_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Network

  getIt.registerLazySingleton(() => Dio(BaseOptions(connectTimeout: const Duration(seconds: 5))));
  getIt.registerLazySingleton(() => DioClient());

  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Data sources
  getIt.registerSingletonAsync<SecureStorageService>(() => SecureStorageService.getInstance());
  getIt.registerSingletonAsync<HiveStorageService>(() async {
    return await HiveStorageService.getInstance();
  });
  getIt.registerSingletonAsync<LogService>(() => LogService.getInstance());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton<TransferRepository>(() => TransferRepositoryImpl(getIt(), getIt()));

  // Use cases
  getIt.registerLazySingleton(() => GetAccounts(getIt()));
  getIt.registerLazySingleton(() => GetTransactions(getIt()));
  getIt.registerLazySingleton(() => TransferMoney(getIt()));

  // BLoCs
  getIt.registerFactory(() => AuthBloc(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => AccountBloc(getIt()));
  getIt.registerFactory(() => TransactionBloc(getIt()));
  getIt.registerFactory(() => TransferBloc(getIt()));
}
