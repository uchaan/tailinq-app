// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  species:
      $enumDecodeNullable(_$PetSpeciesEnumMap, json['species']) ??
      PetSpecies.dog,
  breed: json['breed'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  deviceId: json['deviceId'] as String?,
);

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'species': _$PetSpeciesEnumMap[instance.species]!,
  'breed': instance.breed,
  'birthDate': instance.birthDate?.toIso8601String(),
  'deviceId': instance.deviceId,
};

const _$PetSpeciesEnumMap = {
  PetSpecies.dog: 'dog',
  PetSpecies.cat: 'cat',
  PetSpecies.bird: 'bird',
  PetSpecies.rabbit: 'rabbit',
  PetSpecies.other: 'other',
};
