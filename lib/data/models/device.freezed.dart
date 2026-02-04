// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return _Device.fromJson(json);
}

/// @nodoc
mixin _$Device {
  String get id => throw _privateConstructorUsedError;
  int get batteryLevel => throw _privateConstructorUsedError;
  DeviceStatus get status => throw _privateConstructorUsedError;
  bool get isLiveMode => throw _privateConstructorUsedError;
  String? get petId => throw _privateConstructorUsedError;
  double get safeZoneRadius => throw _privateConstructorUsedError;
  Location? get lastLocation => throw _privateConstructorUsedError;

  /// Serializes this Device to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceCopyWith<Device> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceCopyWith<$Res> {
  factory $DeviceCopyWith(Device value, $Res Function(Device) then) =
      _$DeviceCopyWithImpl<$Res, Device>;
  @useResult
  $Res call({
    String id,
    int batteryLevel,
    DeviceStatus status,
    bool isLiveMode,
    String? petId,
    double safeZoneRadius,
    Location? lastLocation,
  });

  $LocationCopyWith<$Res>? get lastLocation;
}

/// @nodoc
class _$DeviceCopyWithImpl<$Res, $Val extends Device>
    implements $DeviceCopyWith<$Res> {
  _$DeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batteryLevel = null,
    Object? status = null,
    Object? isLiveMode = null,
    Object? petId = freezed,
    Object? safeZoneRadius = null,
    Object? lastLocation = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            batteryLevel: null == batteryLevel
                ? _value.batteryLevel
                : batteryLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DeviceStatus,
            isLiveMode: null == isLiveMode
                ? _value.isLiveMode
                : isLiveMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            petId: freezed == petId
                ? _value.petId
                : petId // ignore: cast_nullable_to_non_nullable
                      as String?,
            safeZoneRadius: null == safeZoneRadius
                ? _value.safeZoneRadius
                : safeZoneRadius // ignore: cast_nullable_to_non_nullable
                      as double,
            lastLocation: freezed == lastLocation
                ? _value.lastLocation
                : lastLocation // ignore: cast_nullable_to_non_nullable
                      as Location?,
          )
          as $Val,
    );
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res>? get lastLocation {
    if (_value.lastLocation == null) {
      return null;
    }

    return $LocationCopyWith<$Res>(_value.lastLocation!, (value) {
      return _then(_value.copyWith(lastLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeviceImplCopyWith<$Res> implements $DeviceCopyWith<$Res> {
  factory _$$DeviceImplCopyWith(
    _$DeviceImpl value,
    $Res Function(_$DeviceImpl) then,
  ) = __$$DeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int batteryLevel,
    DeviceStatus status,
    bool isLiveMode,
    String? petId,
    double safeZoneRadius,
    Location? lastLocation,
  });

  @override
  $LocationCopyWith<$Res>? get lastLocation;
}

/// @nodoc
class __$$DeviceImplCopyWithImpl<$Res>
    extends _$DeviceCopyWithImpl<$Res, _$DeviceImpl>
    implements _$$DeviceImplCopyWith<$Res> {
  __$$DeviceImplCopyWithImpl(
    _$DeviceImpl _value,
    $Res Function(_$DeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? batteryLevel = null,
    Object? status = null,
    Object? isLiveMode = null,
    Object? petId = freezed,
    Object? safeZoneRadius = null,
    Object? lastLocation = freezed,
  }) {
    return _then(
      _$DeviceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        batteryLevel: null == batteryLevel
            ? _value.batteryLevel
            : batteryLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DeviceStatus,
        isLiveMode: null == isLiveMode
            ? _value.isLiveMode
            : isLiveMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        petId: freezed == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String?,
        safeZoneRadius: null == safeZoneRadius
            ? _value.safeZoneRadius
            : safeZoneRadius // ignore: cast_nullable_to_non_nullable
                  as double,
        lastLocation: freezed == lastLocation
            ? _value.lastLocation
            : lastLocation // ignore: cast_nullable_to_non_nullable
                  as Location?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceImpl implements _Device {
  const _$DeviceImpl({
    required this.id,
    required this.batteryLevel,
    required this.status,
    required this.isLiveMode,
    this.petId,
    this.safeZoneRadius = 100.0,
    this.lastLocation,
  });

  factory _$DeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceImplFromJson(json);

  @override
  final String id;
  @override
  final int batteryLevel;
  @override
  final DeviceStatus status;
  @override
  final bool isLiveMode;
  @override
  final String? petId;
  @override
  @JsonKey()
  final double safeZoneRadius;
  @override
  final Location? lastLocation;

  @override
  String toString() {
    return 'Device(id: $id, batteryLevel: $batteryLevel, status: $status, isLiveMode: $isLiveMode, petId: $petId, safeZoneRadius: $safeZoneRadius, lastLocation: $lastLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLiveMode, isLiveMode) ||
                other.isLiveMode == isLiveMode) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.safeZoneRadius, safeZoneRadius) ||
                other.safeZoneRadius == safeZoneRadius) &&
            (identical(other.lastLocation, lastLocation) ||
                other.lastLocation == lastLocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    batteryLevel,
    status,
    isLiveMode,
    petId,
    safeZoneRadius,
    lastLocation,
  );

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceImplCopyWith<_$DeviceImpl> get copyWith =>
      __$$DeviceImplCopyWithImpl<_$DeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceImplToJson(this);
  }
}

abstract class _Device implements Device {
  const factory _Device({
    required final String id,
    required final int batteryLevel,
    required final DeviceStatus status,
    required final bool isLiveMode,
    final String? petId,
    final double safeZoneRadius,
    final Location? lastLocation,
  }) = _$DeviceImpl;

  factory _Device.fromJson(Map<String, dynamic> json) = _$DeviceImpl.fromJson;

  @override
  String get id;
  @override
  int get batteryLevel;
  @override
  DeviceStatus get status;
  @override
  bool get isLiveMode;
  @override
  String? get petId;
  @override
  double get safeZoneRadius;
  @override
  Location? get lastLocation;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceImplCopyWith<_$DeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
