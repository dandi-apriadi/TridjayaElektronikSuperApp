// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DriverDashboardMetrics _$DriverDashboardMetricsFromJson(
    Map<String, dynamic> json) {
  return _DriverDashboardMetrics.fromJson(json);
}

/// @nodoc
mixin _$DriverDashboardMetrics {
  @JsonKey(name: 'pending_deliveries')
  int get pendingDeliveries => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_progress_deliveries')
  int get inProgressDeliveries => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_deliveries')
  int get completedDeliveries => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_rate')
  double get completionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_distance')
  double get totalDistance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DriverDashboardMetricsCopyWith<DriverDashboardMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverDashboardMetricsCopyWith<$Res> {
  factory $DriverDashboardMetricsCopyWith(DriverDashboardMetrics value,
          $Res Function(DriverDashboardMetrics) then) =
      _$DriverDashboardMetricsCopyWithImpl<$Res, DriverDashboardMetrics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'pending_deliveries') int pendingDeliveries,
      @JsonKey(name: 'in_progress_deliveries') int inProgressDeliveries,
      @JsonKey(name: 'completed_deliveries') int completedDeliveries,
      @JsonKey(name: 'completion_rate') double completionRate,
      @JsonKey(name: 'total_distance') double totalDistance});
}

/// @nodoc
class _$DriverDashboardMetricsCopyWithImpl<$Res,
        $Val extends DriverDashboardMetrics>
    implements $DriverDashboardMetricsCopyWith<$Res> {
  _$DriverDashboardMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingDeliveries = null,
    Object? inProgressDeliveries = null,
    Object? completedDeliveries = null,
    Object? completionRate = null,
    Object? totalDistance = null,
  }) {
    return _then(_value.copyWith(
      pendingDeliveries: null == pendingDeliveries
          ? _value.pendingDeliveries
          : pendingDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      inProgressDeliveries: null == inProgressDeliveries
          ? _value.inProgressDeliveries
          : inProgressDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      completedDeliveries: null == completedDeliveries
          ? _value.completedDeliveries
          : completedDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DriverDashboardMetricsImplCopyWith<$Res>
    implements $DriverDashboardMetricsCopyWith<$Res> {
  factory _$$DriverDashboardMetricsImplCopyWith(
          _$DriverDashboardMetricsImpl value,
          $Res Function(_$DriverDashboardMetricsImpl) then) =
      __$$DriverDashboardMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'pending_deliveries') int pendingDeliveries,
      @JsonKey(name: 'in_progress_deliveries') int inProgressDeliveries,
      @JsonKey(name: 'completed_deliveries') int completedDeliveries,
      @JsonKey(name: 'completion_rate') double completionRate,
      @JsonKey(name: 'total_distance') double totalDistance});
}

/// @nodoc
class __$$DriverDashboardMetricsImplCopyWithImpl<$Res>
    extends _$DriverDashboardMetricsCopyWithImpl<$Res,
        _$DriverDashboardMetricsImpl>
    implements _$$DriverDashboardMetricsImplCopyWith<$Res> {
  __$$DriverDashboardMetricsImplCopyWithImpl(
      _$DriverDashboardMetricsImpl _value,
      $Res Function(_$DriverDashboardMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingDeliveries = null,
    Object? inProgressDeliveries = null,
    Object? completedDeliveries = null,
    Object? completionRate = null,
    Object? totalDistance = null,
  }) {
    return _then(_$DriverDashboardMetricsImpl(
      pendingDeliveries: null == pendingDeliveries
          ? _value.pendingDeliveries
          : pendingDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      inProgressDeliveries: null == inProgressDeliveries
          ? _value.inProgressDeliveries
          : inProgressDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      completedDeliveries: null == completedDeliveries
          ? _value.completedDeliveries
          : completedDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverDashboardMetricsImpl implements _DriverDashboardMetrics {
  const _$DriverDashboardMetricsImpl(
      {@JsonKey(name: 'pending_deliveries') required this.pendingDeliveries,
      @JsonKey(name: 'in_progress_deliveries')
      required this.inProgressDeliveries,
      @JsonKey(name: 'completed_deliveries') required this.completedDeliveries,
      @JsonKey(name: 'completion_rate') required this.completionRate,
      @JsonKey(name: 'total_distance') required this.totalDistance});

  factory _$DriverDashboardMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverDashboardMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'pending_deliveries')
  final int pendingDeliveries;
  @override
  @JsonKey(name: 'in_progress_deliveries')
  final int inProgressDeliveries;
  @override
  @JsonKey(name: 'completed_deliveries')
  final int completedDeliveries;
  @override
  @JsonKey(name: 'completion_rate')
  final double completionRate;
  @override
  @JsonKey(name: 'total_distance')
  final double totalDistance;

  @override
  String toString() {
    return 'DriverDashboardMetrics(pendingDeliveries: $pendingDeliveries, inProgressDeliveries: $inProgressDeliveries, completedDeliveries: $completedDeliveries, completionRate: $completionRate, totalDistance: $totalDistance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverDashboardMetricsImpl &&
            (identical(other.pendingDeliveries, pendingDeliveries) ||
                other.pendingDeliveries == pendingDeliveries) &&
            (identical(other.inProgressDeliveries, inProgressDeliveries) ||
                other.inProgressDeliveries == inProgressDeliveries) &&
            (identical(other.completedDeliveries, completedDeliveries) ||
                other.completedDeliveries == completedDeliveries) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pendingDeliveries,
      inProgressDeliveries, completedDeliveries, completionRate, totalDistance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverDashboardMetricsImplCopyWith<_$DriverDashboardMetricsImpl>
      get copyWith => __$$DriverDashboardMetricsImplCopyWithImpl<
          _$DriverDashboardMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverDashboardMetricsImplToJson(
      this,
    );
  }
}

abstract class _DriverDashboardMetrics implements DriverDashboardMetrics {
  const factory _DriverDashboardMetrics(
      {@JsonKey(name: 'pending_deliveries')
      required final int pendingDeliveries,
      @JsonKey(name: 'in_progress_deliveries')
      required final int inProgressDeliveries,
      @JsonKey(name: 'completed_deliveries')
      required final int completedDeliveries,
      @JsonKey(name: 'completion_rate') required final double completionRate,
      @JsonKey(name: 'total_distance')
      required final double totalDistance}) = _$DriverDashboardMetricsImpl;

  factory _DriverDashboardMetrics.fromJson(Map<String, dynamic> json) =
      _$DriverDashboardMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'pending_deliveries')
  int get pendingDeliveries;
  @override
  @JsonKey(name: 'in_progress_deliveries')
  int get inProgressDeliveries;
  @override
  @JsonKey(name: 'completed_deliveries')
  int get completedDeliveries;
  @override
  @JsonKey(name: 'completion_rate')
  double get completionRate;
  @override
  @JsonKey(name: 'total_distance')
  double get totalDistance;
  @override
  @JsonKey(ignore: true)
  _$$DriverDashboardMetricsImplCopyWith<_$DriverDashboardMetricsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Delivery _$DeliveryFromJson(Map<String, dynamic> json) {
  return _Delivery.fromJson(json);
}

/// @nodoc
mixin _$Delivery {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_id')
  String? get driverId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, in_progress, completed, failed
  @JsonKey(name: 'scheduled_time')
  String? get scheduledTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeliveryCopyWith<Delivery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryCopyWith<$Res> {
  factory $DeliveryCopyWith(Delivery value, $Res Function(Delivery) then) =
      _$DeliveryCopyWithImpl<$Res, Delivery>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'driver_id') String? driverId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      String address,
      double? latitude,
      double? longitude,
      String status,
      @JsonKey(name: 'scheduled_time') String? scheduledTime,
      @JsonKey(name: 'completed_at') String? completedAt,
      String? notes,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$DeliveryCopyWithImpl<$Res, $Val extends Delivery>
    implements $DeliveryCopyWith<$Res> {
  _$DeliveryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? address = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = null,
    Object? scheduledTime = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeliveryImplCopyWith<$Res>
    implements $DeliveryCopyWith<$Res> {
  factory _$$DeliveryImplCopyWith(
          _$DeliveryImpl value, $Res Function(_$DeliveryImpl) then) =
      __$$DeliveryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'driver_id') String? driverId,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      String address,
      double? latitude,
      double? longitude,
      String status,
      @JsonKey(name: 'scheduled_time') String? scheduledTime,
      @JsonKey(name: 'completed_at') String? completedAt,
      String? notes,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$DeliveryImplCopyWithImpl<$Res>
    extends _$DeliveryCopyWithImpl<$Res, _$DeliveryImpl>
    implements _$$DeliveryImplCopyWith<$Res> {
  __$$DeliveryImplCopyWithImpl(
      _$DeliveryImpl _value, $Res Function(_$DeliveryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driverId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? address = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = null,
    Object? scheduledTime = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DeliveryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryImpl implements _Delivery {
  const _$DeliveryImpl(
      {required this.id,
      @JsonKey(name: 'driver_id') this.driverId,
      @JsonKey(name: 'customer_name') required this.customerName,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      required this.address,
      this.latitude,
      this.longitude,
      required this.status,
      @JsonKey(name: 'scheduled_time') this.scheduledTime,
      @JsonKey(name: 'completed_at') this.completedAt,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$DeliveryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'driver_id')
  final String? driverId;
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  final String address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String status;
// pending, in_progress, completed, failed
  @override
  @JsonKey(name: 'scheduled_time')
  final String? scheduledTime;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'Delivery(id: $id, driverId: $driverId, customerName: $customerName, customerPhone: $customerPhone, address: $address, latitude: $latitude, longitude: $longitude, status: $status, scheduledTime: $scheduledTime, completedAt: $completedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      driverId,
      customerName,
      customerPhone,
      address,
      latitude,
      longitude,
      status,
      scheduledTime,
      completedAt,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      __$$DeliveryImplCopyWithImpl<_$DeliveryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryImplToJson(
      this,
    );
  }
}

abstract class _Delivery implements Delivery {
  const factory _Delivery(
          {required final String id,
          @JsonKey(name: 'driver_id') final String? driverId,
          @JsonKey(name: 'customer_name') required final String customerName,
          @JsonKey(name: 'customer_phone') final String? customerPhone,
          required final String address,
          final double? latitude,
          final double? longitude,
          required final String status,
          @JsonKey(name: 'scheduled_time') final String? scheduledTime,
          @JsonKey(name: 'completed_at') final String? completedAt,
          final String? notes,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$DeliveryImpl;

  factory _Delivery.fromJson(Map<String, dynamic> json) =
      _$DeliveryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'driver_id')
  String? get driverId;
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  String get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String get status;
  @override // pending, in_progress, completed, failed
  @JsonKey(name: 'scheduled_time')
  String? get scheduledTime;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$DeliveryImplCopyWith<_$DeliveryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) {
  return _RouteInfo.fromJson(json);
}

/// @nodoc
mixin _$RouteInfo {
  @JsonKey(name: 'total_deliveries')
  int get totalDeliveries => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_completion_time')
  String get estimatedCompletionTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_distance')
  double get totalDistance => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_location')
  Map<String, double> get currentLocation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RouteInfoCopyWith<RouteInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteInfoCopyWith<$Res> {
  factory $RouteInfoCopyWith(RouteInfo value, $Res Function(RouteInfo) then) =
      _$RouteInfoCopyWithImpl<$Res, RouteInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_deliveries') int totalDeliveries,
      @JsonKey(name: 'estimated_completion_time')
      String estimatedCompletionTime,
      @JsonKey(name: 'total_distance') double totalDistance,
      @JsonKey(name: 'current_location') Map<String, double> currentLocation});
}

/// @nodoc
class _$RouteInfoCopyWithImpl<$Res, $Val extends RouteInfo>
    implements $RouteInfoCopyWith<$Res> {
  _$RouteInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDeliveries = null,
    Object? estimatedCompletionTime = null,
    Object? totalDistance = null,
    Object? currentLocation = null,
  }) {
    return _then(_value.copyWith(
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedCompletionTime: null == estimatedCompletionTime
          ? _value.estimatedCompletionTime
          : estimatedCompletionTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      currentLocation: null == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteInfoImplCopyWith<$Res>
    implements $RouteInfoCopyWith<$Res> {
  factory _$$RouteInfoImplCopyWith(
          _$RouteInfoImpl value, $Res Function(_$RouteInfoImpl) then) =
      __$$RouteInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_deliveries') int totalDeliveries,
      @JsonKey(name: 'estimated_completion_time')
      String estimatedCompletionTime,
      @JsonKey(name: 'total_distance') double totalDistance,
      @JsonKey(name: 'current_location') Map<String, double> currentLocation});
}

/// @nodoc
class __$$RouteInfoImplCopyWithImpl<$Res>
    extends _$RouteInfoCopyWithImpl<$Res, _$RouteInfoImpl>
    implements _$$RouteInfoImplCopyWith<$Res> {
  __$$RouteInfoImplCopyWithImpl(
      _$RouteInfoImpl _value, $Res Function(_$RouteInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDeliveries = null,
    Object? estimatedCompletionTime = null,
    Object? totalDistance = null,
    Object? currentLocation = null,
  }) {
    return _then(_$RouteInfoImpl(
      totalDeliveries: null == totalDeliveries
          ? _value.totalDeliveries
          : totalDeliveries // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedCompletionTime: null == estimatedCompletionTime
          ? _value.estimatedCompletionTime
          : estimatedCompletionTime // ignore: cast_nullable_to_non_nullable
              as String,
      totalDistance: null == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double,
      currentLocation: null == currentLocation
          ? _value._currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteInfoImpl implements _RouteInfo {
  const _$RouteInfoImpl(
      {@JsonKey(name: 'total_deliveries') required this.totalDeliveries,
      @JsonKey(name: 'estimated_completion_time')
      required this.estimatedCompletionTime,
      @JsonKey(name: 'total_distance') required this.totalDistance,
      @JsonKey(name: 'current_location')
      required final Map<String, double> currentLocation})
      : _currentLocation = currentLocation;

  factory _$RouteInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteInfoImplFromJson(json);

  @override
  @JsonKey(name: 'total_deliveries')
  final int totalDeliveries;
  @override
  @JsonKey(name: 'estimated_completion_time')
  final String estimatedCompletionTime;
  @override
  @JsonKey(name: 'total_distance')
  final double totalDistance;
  final Map<String, double> _currentLocation;
  @override
  @JsonKey(name: 'current_location')
  Map<String, double> get currentLocation {
    if (_currentLocation is EqualUnmodifiableMapView) return _currentLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currentLocation);
  }

  @override
  String toString() {
    return 'RouteInfo(totalDeliveries: $totalDeliveries, estimatedCompletionTime: $estimatedCompletionTime, totalDistance: $totalDistance, currentLocation: $currentLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteInfoImpl &&
            (identical(other.totalDeliveries, totalDeliveries) ||
                other.totalDeliveries == totalDeliveries) &&
            (identical(
                    other.estimatedCompletionTime, estimatedCompletionTime) ||
                other.estimatedCompletionTime == estimatedCompletionTime) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            const DeepCollectionEquality()
                .equals(other._currentLocation, _currentLocation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalDeliveries,
      estimatedCompletionTime,
      totalDistance,
      const DeepCollectionEquality().hash(_currentLocation));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteInfoImplCopyWith<_$RouteInfoImpl> get copyWith =>
      __$$RouteInfoImplCopyWithImpl<_$RouteInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteInfoImplToJson(
      this,
    );
  }
}

abstract class _RouteInfo implements RouteInfo {
  const factory _RouteInfo(
      {@JsonKey(name: 'total_deliveries') required final int totalDeliveries,
      @JsonKey(name: 'estimated_completion_time')
      required final String estimatedCompletionTime,
      @JsonKey(name: 'total_distance') required final double totalDistance,
      @JsonKey(name: 'current_location')
      required final Map<String, double> currentLocation}) = _$RouteInfoImpl;

  factory _RouteInfo.fromJson(Map<String, dynamic> json) =
      _$RouteInfoImpl.fromJson;

  @override
  @JsonKey(name: 'total_deliveries')
  int get totalDeliveries;
  @override
  @JsonKey(name: 'estimated_completion_time')
  String get estimatedCompletionTime;
  @override
  @JsonKey(name: 'total_distance')
  double get totalDistance;
  @override
  @JsonKey(name: 'current_location')
  Map<String, double> get currentLocation;
  @override
  @JsonKey(ignore: true)
  _$$RouteInfoImplCopyWith<_$RouteInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
