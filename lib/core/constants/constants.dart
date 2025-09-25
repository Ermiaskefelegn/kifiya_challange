class Constants {
  static const String baseUrl = 'https://challenge-api.qena.dev';
  static const String apiVersion = '/api';

  // Auth endpoints
  static const String login = '$apiVersion/auth/login';
  static const String register = '$apiVersion/auth/register';
  static const String refreshToken = '$apiVersion/auth/refresh-token';

  // Account endpoints
  static const String accounts = '$apiVersion/accounts';
  static const String createAccount = '$apiVersion/accounts';
  static const String transfer = '$apiVersion/accounts/transfer';
  static const String payBill = '$apiVersion/accounts/pay-bill';

  // Transaction endpoints
  static const String transactions = '$apiVersion/transactions';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
