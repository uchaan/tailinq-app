// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyDataPoint _$DailyDataPointFromJson(Map<String, dynamic> json) {
  return _DailyDataPoint.fromJson(json);
}

/// @nodoc
mixin _$DailyDataPoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  /// Serializes this DailyDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyDataPointCopyWith<DailyDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyDataPointCopyWith<$Res> {
  factory $DailyDataPointCopyWith(
    DailyDataPoint value,
    $Res Function(DailyDataPoint) then,
  ) = _$DailyDataPointCopyWithImpl<$Res, DailyDataPoint>;
  @useResult
  $Res call({DateTime date, double value});
}

/// @nodoc
class _$DailyDataPointCopyWithImpl<$Res, $Val extends DailyDataPoint>
    implements $DailyDataPointCopyWith<$Res> {
  _$DailyDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyDataPointImplCopyWith<$Res>
    implements $DailyDataPointCopyWith<$Res> {
  factory _$$DailyDataPointImplCopyWith(
    _$DailyDataPointImpl value,
    $Res Function(_$DailyDataPointImpl) then,
  ) = __$$DailyDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double value});
}

/// @nodoc
class __$$DailyDataPointImplCopyWithImpl<$Res>
    extends _$DailyDataPointCopyWithImpl<$Res, _$DailyDataPointImpl>
    implements _$$DailyDataPointImplCopyWith<$Res> {
  __$$DailyDataPointImplCopyWithImpl(
    _$DailyDataPointImpl _value,
    $Res Function(_$DailyDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? value = null}) {
    return _then(
      _$DailyDataPointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyDataPointImpl implements _DailyDataPoint {
  const _$DailyDataPointImpl({required this.date, required this.value});

  factory _$DailyDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyDataPointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double value;

  @override
  String toString() {
    return 'DailyDataPoint(date: $date, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyDataPointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, value);

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyDataPointImplCopyWith<_$DailyDataPointImpl> get copyWith =>
      __$$DailyDataPointImplCopyWithImpl<_$DailyDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyDataPointImplToJson(this);
  }
}

abstract class _DailyDataPoint implements DailyDataPoint {
  const factory _DailyDataPoint({
    required final DateTime date,
    required final double value,
  }) = _$DailyDataPointImpl;

  factory _DailyDataPoint.fromJson(Map<String, dynamic> json) =
      _$DailyDataPointImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get value;

  /// Create a copy of DailyDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyDataPointImplCopyWith<_$DailyDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthMetric _$HealthMetricFromJson(Map<String, dynamic> json) {
  return _HealthMetric.fromJson(json);
}

/// @nodoc
mixin _$HealthMetric {
  String get petId => throw _privateConstructorUsedError;
  HealthMetricType get type => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get currentValue => throw _privateConstructorUsedError;
  double get changePercent => throw _privateConstructorUsedError;
  List<DailyDataPoint> get dailyData => throw _privateConstructorUsedError;

  /// Serializes this HealthMetric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthMetricCopyWith<HealthMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthMetricCopyWith<$Res> {
  factory $HealthMetricCopyWith(
    HealthMetric value,
    $Res Function(HealthMetric) then,
  ) = _$HealthMetricCopyWithImpl<$Res, HealthMetric>;
  @useResult
  $Res call({
    String petId,
    HealthMetricType type,
    String unit,
    double currentValue,
    double changePercent,
    List<DailyDataPoint> dailyData,
  });
}

/// @nodoc
class _$HealthMetricCopyWithImpl<$Res, $Val extends HealthMetric>
    implements $HealthMetricCopyWith<$Res> {
  _$HealthMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petId = null,
    Object? type = null,
    Object? unit = null,
    Object? currentValue = null,
    Object? changePercent = null,
    Object? dailyData = null,
  }) {
    return _then(
      _value.copyWith(
            petId: null == petId
                ? _value.petId
                : petId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as HealthMetricType,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as double,
            changePercent: null == changePercent
                ? _value.changePercent
                : changePercent // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyData: null == dailyData
                ? _value.dailyData
                : dailyData // ignore: cast_nullable_to_non_nullable
                      as List<DailyDataPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HealthMetricImplCopyWith<$Res>
    implements $HealthMetricCopyWith<$Res> {
  factory _$$HealthMetricImplCopyWith(
    _$HealthMetricImpl value,
    $Res Function(_$HealthMetricImpl) then,
  ) = __$$HealthMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String petId,
    HealthMetricType type,
    String unit,
    double currentValue,
    double changePercent,
    List<DailyDataPoint> dailyData,
  });
}

/// @nodoc
class __$$HealthMetricImplCopyWithImpl<$Res>
    extends _$HealthMetricCopyWithImpl<$Res, _$HealthMetricImpl>
    implements _$$HealthMetricImplCopyWith<$Res> {
  __$$HealthMetricImplCopyWithImpl(
    _$HealthMetricImpl _value,
    $Res Function(_$HealthMetricImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petId = null,
    Object? type = null,
    Object? unit = null,
    Object? currentValue = null,
    Object? changePercent = null,
    Object? dailyData = null,
  }) {
    return _then(
      _$HealthMetricImpl(
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as HealthMetricType,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as double,
        changePercent: null == changePercent
            ? _value.changePercent
            : changePercent // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyData: null == dailyData
            ? _value._dailyData
            : dailyData // ignore: cast_nullable_to_non_nullable
                  as List<DailyDataPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthMetricImpl implements _HealthMetric {
  const _$HealthMetricImpl({
    required this.petId,
    required this.type,
    required this.unit,
    required this.currentValue,
    required this.changePercent,
    required final List<DailyDataPoint> dailyData,
  }) : _dailyData = dailyData;

  factory _$HealthMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthMetricImplFromJson(json);

  @override
  final String petId;
  @override
  final HealthMetricType type;
  @override
  final String unit;
  @override
  final double currentValue;
  @override
  final double changePercent;
  final List<DailyDataPoint> _dailyData;
  @override
  List<DailyDataPoint> get dailyData {
    if (_dailyData is EqualUnmodifiableListView) return _dailyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyData);
  }

  @override
  String toString() {
    return 'HealthMetric(petId: $petId, type: $type, unit: $unit, currentValue: $currentValue, changePercent: $changePercent, dailyData: $dailyData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthMetricImpl &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            const DeepCollectionEquality().equals(
              other._dailyData,
              _dailyData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    petId,
    type,
    unit,
    currentValue,
    changePercent,
    const DeepCollectionEquality().hash(_dailyData),
  );

  /// Create a copy of HealthMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthMetricImplCopyWith<_$HealthMetricImpl> get copyWith =>
      __$$HealthMetricImplCopyWithImpl<_$HealthMetricImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthMetricImplToJson(this);
  }
}

abstract class _HealthMetric implements HealthMetric {
  const factory _HealthMetric({
    required final String petId,
    required final HealthMetricType type,
    required final String unit,
    required final double currentValue,
    required final double changePercent,
    required final List<DailyDataPoint> dailyData,
  }) = _$HealthMetricImpl;

  factory _HealthMetric.fromJson(Map<String, dynamic> json) =
      _$HealthMetricImpl.fromJson;

  @override
  String get petId;
  @override
  HealthMetricType get type;
  @override
  String get unit;
  @override
  double get currentValue;
  @override
  double get changePercent;
  @override
  List<DailyDataPoint> get dailyData;

  /// Create a copy of HealthMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthMetricImplCopyWith<_$HealthMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
