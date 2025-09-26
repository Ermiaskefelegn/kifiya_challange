import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kifiya_challenge/core/services/hive_storage_service.dart';
import 'package:kifiya_challenge/core/services/secure_storage_service.dart';
import 'package:kifiya_challenge/domain/usecases/refresh_token.dart';

import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/register_user.dart';
import '../../../data/models/auth/login_response.dart';
import '../../../data/models/auth/register_response.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final RefreshToken refreshToken;
  final SecureStorageService secureStorageService;
  final HiveStorageService hiveStorageService;

  AuthBloc(this.loginUser, this.registerUser, this.secureStorageService, this.hiveStorageService, this.refreshToken)
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
    final accessToken = await secureStorageService.read(key: 'access_token');
    final refreshTokenValue = await secureStorageService.read(key: 'refresh_token');

    if (accessToken != null) {
      try {
        // ✅ Check if token is expired
        final isExpired = _isTokenExpired(accessToken);
        log('Access token expired: $isExpired');
        if (isExpired && refreshTokenValue != null && refreshTokenValue.isNotEmpty) {
          // 🔄 Try refreshing the token
          final newTokenResponse = await refreshToken();

          // Persist new tokens
          await secureStorageService.write(key: 'access_token', value: newTokenResponse.accessToken);
          await secureStorageService.write(key: 'refresh_token', value: newTokenResponse.refreshToken);

          // Retrieve persisted user info
          final username = await hiveStorageService.get('username') ?? '';
          final userId = int.tryParse(hiveStorageService.get('user_id') ?? '0') ?? 0;

          final refreshedResponse = LoginResponse(
            message: 'Token refreshed',
            username: username,
            userId: userId,
            accessToken: newTokenResponse.accessToken,
            refreshToken: newTokenResponse.refreshToken,
          );

          emit(AuthAuthenticated(refreshedResponse));
          return;
        }

        // ✅ Token valid → restore session
        final username = await hiveStorageService.get('username') ?? '';
        final userId = int.tryParse(hiveStorageService.get('user_id') ?? '0') ?? 0;

        final mockResponse = LoginResponse(
          message: 'Already authenticated',
          username: username,
          userId: userId,
          accessToken: accessToken,
          refreshToken: refreshTokenValue ?? '',
        );

        emit(AuthAuthenticated(mockResponse));
      } catch (e) {
        // ❌ Refresh token also failed → logout
        await secureStorageService.delete(key: 'access_token');
        await secureStorageService.delete(key: 'refresh_token');
        await hiveStorageService.delete('user_id');
        await hiveStorageService.delete('username');
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Decode JWT and check expiration
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      final exp = payloadMap['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (_) {
      return true; // Assume expired if parsing fails
    }
  }
}
