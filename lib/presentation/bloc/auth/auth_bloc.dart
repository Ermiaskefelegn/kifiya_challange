import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kifiya_challenge/core/services/hive_storage_service.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/register_user.dart';
import '../../../data/models/auth/login_response.dart';
import '../../../data/models/auth/register_response.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final SecureStorageService secureStorageService;
  final HiveStorageService hiveStorageService;

  AuthBloc(this.loginUser, this.registerUser, this.secureStorageService, this.hiveStorageService)
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await loginUser(event.username, event.password);

      // Persist tokens & user info
      await secureStorageService.write(key: 'access_token', value: response.accessToken);
      await secureStorageService.write(key: 'refresh_token', value: response.refreshToken);
      await hiveStorageService.set('user_id', response.userId.toString());
      await hiveStorageService.set('username', response.username);

      emit(AuthAuthenticated(response));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await registerUser(
        username: event.username,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumber: event.phoneNumber,
      );
      emit(AuthRegistered(response));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await secureStorageService.delete(key: 'access_token');
    await secureStorageService.delete(key: 'refresh_token');
    await hiveStorageService.delete('user_id');
    await hiveStorageService.delete('username');
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final token = await secureStorageService.read(key: 'access_token');
    if (token != null) {
      final username = await hiveStorageService.get('username') ?? '';
      final userId = int.tryParse(hiveStorageService.get('user_id') ?? '0') ?? 0;

      final mockResponse = LoginResponse(
        message: 'Already authenticated',
        username: username,
        userId: userId,
        accessToken: token,
        refreshToken: await secureStorageService.read(key: 'refresh_token') ?? '',
      );

      emit(AuthAuthenticated(mockResponse));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
