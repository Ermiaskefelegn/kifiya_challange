import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String username;
  final String passwordHash;
  final String firstName;
  final String lastName;
  final String? email;
  final String phoneNumber;

  const RegisterRequest({
    required this.username,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    this.email,
    required this.phoneNumber,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}