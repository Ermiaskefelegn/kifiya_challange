import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final String message;
  final String username;
  final int userId;
  final String initialAccountNumber;

  const RegisterResponse({
    required this.message,
    required this.username,
    required this.userId,
    required this.initialAccountNumber,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}