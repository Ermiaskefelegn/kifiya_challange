import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kifiya_challenge/core/di/dependency_Injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/account/account_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/transactions/transactions_bloc.dart';
import 'presentation/bloc/transfer/transfer_bloc.dart';
import 'presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AccountBloc>()..add(LoadAccounts())),
        BlocProvider(create: (_) => getIt<TransactionBloc>()..add(LoadTransactions())),
        BlocProvider(create: (_) => getIt<TransferBloc>()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Banking App',
        theme: AppTheme.lightTheme,
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
