// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String,
  name: json['name'] as String,
  number: json['number'] as String,
  balance: (json['balance'] as num).toDouble(),
  type: json['type'] as String,
  lastUpdated: json['lastUpdated'] as String,
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'balance': instance.balance,
      'type': instance.type,
      'lastUpdated': instance.lastUpdated,
    };
