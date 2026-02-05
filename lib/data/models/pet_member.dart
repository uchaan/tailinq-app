import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_member.freezed.dart';
part 'pet_member.g.dart';

enum PetMemberRole {
  owner,
  family,
  caretaker,
}

@freezed
class PetMember with _$PetMember {
  const factory PetMember({
    required String id,
    required String petId,
    required String userId,
    @Default(PetMemberRole.owner) PetMemberRole role,
    @Default(false) bool isPrimary,
    String? userName,
    String? userEmail,
    required DateTime joinedAt,
  }) = _PetMember;

  factory PetMember.fromJson(Map<String, dynamic> json) =>
      _$PetMemberFromJson(json);
}
