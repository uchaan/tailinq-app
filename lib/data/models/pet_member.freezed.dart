// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PetMember _$PetMemberFromJson(Map<String, dynamic> json) {
  return _PetMember.fromJson(json);
}

/// @nodoc
mixin _$PetMember {
  String get id => throw _privateConstructorUsedError;
  String get petId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  PetMemberRole get role => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this PetMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetMemberCopyWith<PetMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetMemberCopyWith<$Res> {
  factory $PetMemberCopyWith(PetMember value, $Res Function(PetMember) then) =
      _$PetMemberCopyWithImpl<$Res, PetMember>;
  @useResult
  $Res call({
    String id,
    String petId,
    String userId,
    PetMemberRole role,
    DateTime joinedAt,
  });
}

/// @nodoc
class _$PetMemberCopyWithImpl<$Res, $Val extends PetMember>
    implements $PetMemberCopyWith<$Res> {
  _$PetMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? userId = null,
    Object? role = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            petId: null == petId
                ? _value.petId
                : petId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as PetMemberRole,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PetMemberImplCopyWith<$Res>
    implements $PetMemberCopyWith<$Res> {
  factory _$$PetMemberImplCopyWith(
    _$PetMemberImpl value,
    $Res Function(_$PetMemberImpl) then,
  ) = __$$PetMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String petId,
    String userId,
    PetMemberRole role,
    DateTime joinedAt,
  });
}

/// @nodoc
class __$$PetMemberImplCopyWithImpl<$Res>
    extends _$PetMemberCopyWithImpl<$Res, _$PetMemberImpl>
    implements _$$PetMemberImplCopyWith<$Res> {
  __$$PetMemberImplCopyWithImpl(
    _$PetMemberImpl _value,
    $Res Function(_$PetMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PetMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? userId = null,
    Object? role = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _$PetMemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as PetMemberRole,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetMemberImpl implements _PetMember {
  const _$PetMemberImpl({
    required this.id,
    required this.petId,
    required this.userId,
    this.role = PetMemberRole.owner,
    required this.joinedAt,
  });

  factory _$PetMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String petId;
  @override
  final String userId;
  @override
  @JsonKey()
  final PetMemberRole role;
  @override
  final DateTime joinedAt;

  @override
  String toString() {
    return 'PetMember(id: $id, petId: $petId, userId: $userId, role: $role, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, petId, userId, role, joinedAt);

  /// Create a copy of PetMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetMemberImplCopyWith<_$PetMemberImpl> get copyWith =>
      __$$PetMemberImplCopyWithImpl<_$PetMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetMemberImplToJson(this);
  }
}

abstract class _PetMember implements PetMember {
  const factory _PetMember({
    required final String id,
    required final String petId,
    required final String userId,
    final PetMemberRole role,
    required final DateTime joinedAt,
  }) = _$PetMemberImpl;

  factory _PetMember.fromJson(Map<String, dynamic> json) =
      _$PetMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get petId;
  @override
  String get userId;
  @override
  PetMemberRole get role;
  @override
  DateTime get joinedAt;

  /// Create a copy of PetMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetMemberImplCopyWith<_$PetMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
