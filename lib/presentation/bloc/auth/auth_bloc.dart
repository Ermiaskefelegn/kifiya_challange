import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
  final SharedPreferences _prefs;

  AuthBloc(this.loginUser, this.registerUser, this._prefs) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await loginUser(event.username, event.password);
      
      // Store tokens
      await _prefs.setString('access_token', response.accessToken);
      await _prefs.setString('refresh_token', response.refreshToken);
      await _prefs.setInt('user_id', response.userId);
      await _prefs.setString('username', response.username);
      
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
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('user_id');
    await _prefs.remove('username');
    
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    final token = _prefs.getString('access_token');
    if (token != null) {
      final username = _prefs.getString('username') ?? '';
      final userId = _prefs.getInt('user_id') ?? 0;
      
      final mockResponse = LoginResponse(
        message: 'Already authenticated',
        username: username,
        userId: userId,
        accessToken: token,
        refreshToken: _prefs.getString('refresh_token') ?? '',
      );
      
      emit(AuthAuthenticated(mockResponse));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}