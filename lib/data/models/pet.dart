import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

enum PetSpecies {
  dog,
  cat,
  bird,
  rabbit,
  other,
}

@freezed
class Pet with _$Pet {
  const factory Pet({
    required String id,
    required String name,
    String? imageUrl,
    @Default(PetSpecies.dog) PetSpecies species,
    String? breed,
    DateTime? birthDate,
    String? deviceId,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
