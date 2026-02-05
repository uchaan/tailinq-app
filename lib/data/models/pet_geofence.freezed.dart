// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_geofence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PetGeofence _$PetGeofenceFromJson(Map<String, dynamic> json) {
  return _PetGeofence.fromJson(json);
}

/// @nodoc
mixin _$PetGeofence {
  String get id => throw _privateConstructorUsedError;
  String get petId => throw _privateConstructorUsedError;
  String get geofenceId => throw _privateConstructorUsedError;
  DateTime get assignedAt => throw _privateConstructorUsedError;

  /// Serializes this PetGeofence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetGeofence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetGeofenceCopyWith<PetGeofence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetGeofenceCopyWith<$Res> {
  factory $PetGeofenceCopyWith(
    PetGeofence value,
    $Res Function(PetGeofence) then,
  ) = _$PetGeofenceCopyWithImpl<$Res, PetGeofence>;
  @useResult
  $Res call({String id, String petId, String geofenceId, DateTime assignedAt});
}

/// @nodoc
class _$PetGeofenceCopyWithImpl<$Res, $Val extends PetGeofence>
    implements $PetGeofenceCopyWith<$Res> {
  _$PetGeofenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetGeofence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? geofenceId = null,
    Object? assignedAt = null,
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
            geofenceId: null == geofenceId
                ? _value.geofenceId
                : geofenceId // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedAt: null == assignedAt
                ? _value.assignedAt
                : assignedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PetGeofenceImplCopyWith<$Res>
    implements $PetGeofenceCopyWith<$Res> {
  factory _$$PetGeofenceImplCopyWith(
    _$PetGeofenceImpl value,
    $Res Function(_$PetGeofenceImpl) then,
  ) = __$$PetGeofenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String petId, String geofenceId, DateTime assignedAt});
}

/// @nodoc
class __$$PetGeofenceImplCopyWithImpl<$Res>
    extends _$PetGeofenceCopyWithImpl<$Res, _$PetGeofenceImpl>
    implements _$$PetGeofenceImplCopyWith<$Res> {
  __$$PetGeofenceImplCopyWithImpl(
    _$PetGeofenceImpl _value,
    $Res Function(_$PetGeofenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PetGeofence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? geofenceId = null,
    Object? assignedAt = null,
  }) {
    return _then(
      _$PetGeofenceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        geofenceId: null == geofenceId
            ? _value.geofenceId
            : geofenceId // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedAt: null == assignedAt
            ? _value.assignedAt
            : assignedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetGeofenceImpl implements _PetGeofence {
  const _$PetGeofenceImpl({
    required this.id,
    required this.petId,
    required this.geofenceId,
    required this.assignedAt,
  });

  factory _$PetGeofenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetGeofenceImplFromJson(json);

  @override
  final String id;
  @override
  final String petId;
  @override
  final String geofenceId;
  @override
  final DateTime assignedAt;

  @override
  String toString() {
    return 'PetGeofence(id: $id, petId: $petId, geofenceId: $geofenceId, assignedAt: $assignedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetGeofenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.geofenceId, geofenceId) ||
                other.geofenceId == geofenceId) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, petId, geofenceId, assignedAt);

  /// Create a copy of PetGeofence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetGeofenceImplCopyWith<_$PetGeofenceImpl> get copyWith =>
      __$$PetGeofenceImplCopyWithImpl<_$PetGeofenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetGeofenceImplToJson(this);
  }
}

abstract class _PetGeofence implements PetGeofence {
  const factory _PetGeofence({
    required final String id,
    required final String petId,
    required final String geofenceId,
    required final DateTime assignedAt,
  }) = _$PetGeofenceImpl;

  factory _PetGeofence.fromJson(Map<String, dynamic> json) =
      _$PetGeofenceImpl.fromJson;

  @override
  String get id;
  @override
  String get petId;
  @override
  String get geofenceId;
  @override
  DateTime get assignedAt;

  /// Create a copy of PetGeofence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetGeofenceImplCopyWith<_$PetGeofenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
