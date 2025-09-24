// ignore_for_file: file_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:kifiya_challenge/core/network/dio/dio_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjector() async {
  //env
  await dotenv.load(fileName: ".env");

  // Dio
  getIt.registerLazySingleton(() => Dio(BaseOptions(connectTimeout: const Duration(seconds: 5))));

  getIt.registerLazySingleton(() => DioClient());
}
