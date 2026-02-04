// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetMemberImpl _$$PetMemberImplFromJson(Map<String, dynamic> json) =>
    _$PetMemberImpl(
      id: json['id'] as String,
      petId: json['petId'] as String,
      userId: json['userId'] as String,
      role:
          $enumDecodeNullable(_$PetMemberRoleEnumMap, json['role']) ??
          PetMemberRole.owner,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$PetMemberImplToJson(_$PetMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'petId': instance.petId,
      'userId': instance.userId,
      'role': _$PetMemberRoleEnumMap[instance.role]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };

const _$PetMemberRoleEnumMap = {
  PetMemberRole.owner: 'owner',
  PetMemberRole.family: 'family',
  PetMemberRole.caretaker: 'caretaker',
};
