// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Geofence _$GeofenceFromJson(Map<String, dynamic> json) {
  return _Geofence.fromJson(json);
}

/// @nodoc
mixin _$Geofence {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get radiusMeters => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this Geofence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Geofence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeofenceCopyWith<Geofence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceCopyWith<$Res> {
  factory $GeofenceCopyWith(Geofence value, $Res Function(Geofence) then) =
      _$GeofenceCopyWithImpl<$Res, Geofence>;
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    double radiusMeters,
    int color,
  });
}

/// @nodoc
class _$GeofenceCopyWithImpl<$Res, $Val extends Geofence>
    implements $GeofenceCopyWith<$Res> {
  _$GeofenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Geofence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            radiusMeters: null == radiusMeters
                ? _value.radiusMeters
                : radiusMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeofenceImplCopyWith<$Res>
    implements $GeofenceCopyWith<$Res> {
  factory _$$GeofenceImplCopyWith(
    _$GeofenceImpl value,
    $Res Function(_$GeofenceImpl) then,
  ) = __$$GeofenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    double radiusMeters,
    int color,
  });
}

/// @nodoc
class __$$GeofenceImplCopyWithImpl<$Res>
    extends _$GeofenceCopyWithImpl<$Res, _$GeofenceImpl>
    implements _$$GeofenceImplCopyWith<$Res> {
  __$$GeofenceImplCopyWithImpl(
    _$GeofenceImpl _value,
    $Res Function(_$GeofenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Geofence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radiusMeters = null,
    Object? color = null,
  }) {
    return _then(
      _$GeofenceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        radiusMeters: null == radiusMeters
            ? _value.radiusMeters
            : radiusMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeofenceImpl implements _Geofence {
  const _$GeofenceImpl({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.color = 0xFF4CAF50,
  });

  factory _$GeofenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeofenceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double radiusMeters;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'Geofence(id: $id, name: $name, latitude: $latitude, longitude: $longitude, radiusMeters: $radiusMeters, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radiusMeters, radiusMeters) ||
                other.radiusMeters == radiusMeters) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    latitude,
    longitude,
    radiusMeters,
    color,
  );

  /// Create a copy of Geofence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofenceImplCopyWith<_$GeofenceImpl> get copyWith =>
      __$$GeofenceImplCopyWithImpl<_$GeofenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeofenceImplToJson(this);
  }
}

abstract class _Geofence implements Geofence {
  const factory _Geofence({
    required final String id,
    required final String name,
    required final double latitude,
    required final double longitude,
    required final double radiusMeters,
    final int color,
  }) = _$GeofenceImpl;

  factory _Geofence.fromJson(Map<String, dynamic> json) =
      _$GeofenceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get radiusMeters;
  @override
  int get color;

  /// Create a copy of Geofence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeofenceImplCopyWith<_$GeofenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
