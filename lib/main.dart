import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kifiya_challenge/core/di/dependency_Injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/account/account_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/transactions/transactions_bloc.dart';
import 'presentation/bloc/transfer/transfer_bloc.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  await getIt.allReady();
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
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckAuthStatus()), // 👈 check at startup
        ),
      ],
      child: MaterialApp(
        title: 'Banking App',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(), // 👈 Use wrapper instead of MainPage
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainPage();
        }
        if (state is AuthLoading || state is AuthInitial) {
          return const Center(
            child: CircularProgressIndicator(),
            // Set white background
          );
        }
        return const LoginPage();
      },
    );
  }
}
