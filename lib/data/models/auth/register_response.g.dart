// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      message: json['message'] as String,
      username: json['username'] as String,
      userId: (json['userId'] as num).toInt(),
      initialAccountNumber: json['initialAccountNumber'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'username': instance.username,
      'userId': instance.userId,
      'initialAccountNumber': instance.initialAccountNumber,
    };
