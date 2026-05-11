// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardMetrics _$DashboardMetricsFromJson(Map<String, dynamic> json) {
  return _DashboardMetrics.fromJson(json);
}

/// @nodoc
mixin _$DashboardMetrics {
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_customers')
  int get totalCustomers => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_approvals')
  int get pendingApprovals => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_performance')
  List<BranchMetrics> get branchPerformance =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_activity')
  List<ActivityItem> get recentActivity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardMetricsCopyWith<DashboardMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardMetricsCopyWith<$Res> {
  factory $DashboardMetricsCopyWith(
          DashboardMetrics value, $Res Function(DashboardMetrics) then) =
      _$DashboardMetricsCopyWithImpl<$Res, DashboardMetrics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'total_customers') int totalCustomers,
      @JsonKey(name: 'pending_approvals') int pendingApprovals,
      @JsonKey(name: 'branch_performance')
      List<BranchMetrics> branchPerformance,
      @JsonKey(name: 'recent_activity') List<ActivityItem> recentActivity});
}

/// @nodoc
class _$DashboardMetricsCopyWithImpl<$Res, $Val extends DashboardMetrics>
    implements $DashboardMetricsCopyWith<$Res> {
  _$DashboardMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? totalCustomers = null,
    Object? pendingApprovals = null,
    Object? branchPerformance = null,
    Object? recentActivity = null,
  }) {
    return _then(_value.copyWith(
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalCustomers: null == totalCustomers
          ? _value.totalCustomers
          : totalCustomers // ignore: cast_nullable_to_non_nullable
              as int,
      pendingApprovals: null == pendingApprovals
          ? _value.pendingApprovals
          : pendingApprovals // ignore: cast_nullable_to_non_nullable
              as int,
      branchPerformance: null == branchPerformance
          ? _value.branchPerformance
          : branchPerformance // ignore: cast_nullable_to_non_nullable
              as List<BranchMetrics>,
      recentActivity: null == recentActivity
          ? _value.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardMetricsImplCopyWith<$Res>
    implements $DashboardMetricsCopyWith<$Res> {
  factory _$$DashboardMetricsImplCopyWith(_$DashboardMetricsImpl value,
          $Res Function(_$DashboardMetricsImpl) then) =
      __$$DashboardMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'total_customers') int totalCustomers,
      @JsonKey(name: 'pending_approvals') int pendingApprovals,
      @JsonKey(name: 'branch_performance')
      List<BranchMetrics> branchPerformance,
      @JsonKey(name: 'recent_activity') List<ActivityItem> recentActivity});
}

/// @nodoc
class __$$DashboardMetricsImplCopyWithImpl<$Res>
    extends _$DashboardMetricsCopyWithImpl<$Res, _$DashboardMetricsImpl>
    implements _$$DashboardMetricsImplCopyWith<$Res> {
  __$$DashboardMetricsImplCopyWithImpl(_$DashboardMetricsImpl _value,
      $Res Function(_$DashboardMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? totalCustomers = null,
    Object? pendingApprovals = null,
    Object? branchPerformance = null,
    Object? recentActivity = null,
  }) {
    return _then(_$DashboardMetricsImpl(
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalCustomers: null == totalCustomers
          ? _value.totalCustomers
          : totalCustomers // ignore: cast_nullable_to_non_nullable
              as int,
      pendingApprovals: null == pendingApprovals
          ? _value.pendingApprovals
          : pendingApprovals // ignore: cast_nullable_to_non_nullable
              as int,
      branchPerformance: null == branchPerformance
          ? _value._branchPerformance
          : branchPerformance // ignore: cast_nullable_to_non_nullable
              as List<BranchMetrics>,
      recentActivity: null == recentActivity
          ? _value._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardMetricsImpl implements _DashboardMetrics {
  const _$DashboardMetricsImpl(
      {@JsonKey(name: 'total_revenue') required this.totalRevenue,
      @JsonKey(name: 'total_orders') required this.totalOrders,
      @JsonKey(name: 'total_customers') required this.totalCustomers,
      @JsonKey(name: 'pending_approvals') required this.pendingApprovals,
      @JsonKey(name: 'branch_performance')
      required final List<BranchMetrics> branchPerformance,
      @JsonKey(name: 'recent_activity')
      required final List<ActivityItem> recentActivity})
      : _branchPerformance = branchPerformance,
        _recentActivity = recentActivity;

  factory _$DashboardMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'total_customers')
  final int totalCustomers;
  @override
  @JsonKey(name: 'pending_approvals')
  final int pendingApprovals;
  final List<BranchMetrics> _branchPerformance;
  @override
  @JsonKey(name: 'branch_performance')
  List<BranchMetrics> get branchPerformance {
    if (_branchPerformance is EqualUnmodifiableListView)
      return _branchPerformance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branchPerformance);
  }

  final List<ActivityItem> _recentActivity;
  @override
  @JsonKey(name: 'recent_activity')
  List<ActivityItem> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  @override
  String toString() {
    return 'DashboardMetrics(totalRevenue: $totalRevenue, totalOrders: $totalOrders, totalCustomers: $totalCustomers, pendingApprovals: $pendingApprovals, branchPerformance: $branchPerformance, recentActivity: $recentActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardMetricsImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.pendingApprovals, pendingApprovals) ||
                other.pendingApprovals == pendingApprovals) &&
            const DeepCollectionEquality()
                .equals(other._branchPerformance, _branchPerformance) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalRevenue,
      totalOrders,
      totalCustomers,
      pendingApprovals,
      const DeepCollectionEquality().hash(_branchPerformance),
      const DeepCollectionEquality().hash(_recentActivity));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardMetricsImplCopyWith<_$DashboardMetricsImpl> get copyWith =>
      __$$DashboardMetricsImplCopyWithImpl<_$DashboardMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardMetricsImplToJson(
      this,
    );
  }
}

abstract class _DashboardMetrics implements DashboardMetrics {
  const factory _DashboardMetrics(
      {@JsonKey(name: 'total_revenue') required final double totalRevenue,
      @JsonKey(name: 'total_orders') required final int totalOrders,
      @JsonKey(name: 'total_customers') required final int totalCustomers,
      @JsonKey(name: 'pending_approvals') required final int pendingApprovals,
      @JsonKey(name: 'branch_performance')
      required final List<BranchMetrics> branchPerformance,
      @JsonKey(name: 'recent_activity')
      required final List<ActivityItem>
          recentActivity}) = _$DashboardMetricsImpl;

  factory _DashboardMetrics.fromJson(Map<String, dynamic> json) =
      _$DashboardMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'total_customers')
  int get totalCustomers;
  @override
  @JsonKey(name: 'pending_approvals')
  int get pendingApprovals;
  @override
  @JsonKey(name: 'branch_performance')
  List<BranchMetrics> get branchPerformance;
  @override
  @JsonKey(name: 'recent_activity')
  List<ActivityItem> get recentActivity;
  @override
  @JsonKey(ignore: true)
  _$$DashboardMetricsImplCopyWith<_$DashboardMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BranchMetrics _$BranchMetricsFromJson(Map<String, dynamic> json) {
  return _BranchMetrics.fromJson(json);
}

/// @nodoc
mixin _$BranchMetrics {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  int get orders => throw _privateConstructorUsedError;
  double get target => throw _privateConstructorUsedError;
  @JsonKey(name: 'achievement_percentage')
  double get achievementPercentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BranchMetricsCopyWith<BranchMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchMetricsCopyWith<$Res> {
  factory $BranchMetricsCopyWith(
          BranchMetrics value, $Res Function(BranchMetrics) then) =
      _$BranchMetricsCopyWithImpl<$Res, BranchMetrics>;
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      double revenue,
      int orders,
      double target,
      @JsonKey(name: 'achievement_percentage') double achievementPercentage});
}

/// @nodoc
class _$BranchMetricsCopyWithImpl<$Res, $Val extends BranchMetrics>
    implements $BranchMetricsCopyWith<$Res> {
  _$BranchMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? revenue = null,
    Object? orders = null,
    Object? target = null,
    Object? achievementPercentage = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as double,
      achievementPercentage: null == achievementPercentage
          ? _value.achievementPercentage
          : achievementPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchMetricsImplCopyWith<$Res>
    implements $BranchMetricsCopyWith<$Res> {
  factory _$$BranchMetricsImplCopyWith(
          _$BranchMetricsImpl value, $Res Function(_$BranchMetricsImpl) then) =
      __$$BranchMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      double revenue,
      int orders,
      double target,
      @JsonKey(name: 'achievement_percentage') double achievementPercentage});
}

/// @nodoc
class __$$BranchMetricsImplCopyWithImpl<$Res>
    extends _$BranchMetricsCopyWithImpl<$Res, _$BranchMetricsImpl>
    implements _$$BranchMetricsImplCopyWith<$Res> {
  __$$BranchMetricsImplCopyWithImpl(
      _$BranchMetricsImpl _value, $Res Function(_$BranchMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? revenue = null,
    Object? orders = null,
    Object? target = null,
    Object? achievementPercentage = null,
  }) {
    return _then(_$BranchMetricsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      revenue: null == revenue
          ? _value.revenue
          : revenue // ignore: cast_nullable_to_non_nullable
              as double,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as double,
      achievementPercentage: null == achievementPercentage
          ? _value.achievementPercentage
          : achievementPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchMetricsImpl implements _BranchMetrics {
  const _$BranchMetricsImpl(
      {required this.id,
      required this.name,
      required this.code,
      required this.revenue,
      required this.orders,
      required this.target,
      @JsonKey(name: 'achievement_percentage')
      required this.achievementPercentage});

  factory _$BranchMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchMetricsImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  @override
  final double revenue;
  @override
  final int orders;
  @override
  final double target;
  @override
  @JsonKey(name: 'achievement_percentage')
  final double achievementPercentage;

  @override
  String toString() {
    return 'BranchMetrics(id: $id, name: $name, code: $code, revenue: $revenue, orders: $orders, target: $target, achievementPercentage: $achievementPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchMetricsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.orders, orders) || other.orders == orders) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.achievementPercentage, achievementPercentage) ||
                other.achievementPercentage == achievementPercentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, code, revenue, orders,
      target, achievementPercentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchMetricsImplCopyWith<_$BranchMetricsImpl> get copyWith =>
      __$$BranchMetricsImplCopyWithImpl<_$BranchMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchMetricsImplToJson(
      this,
    );
  }
}

abstract class _BranchMetrics implements BranchMetrics {
  const factory _BranchMetrics(
      {required final String id,
      required final String name,
      required final String code,
      required final double revenue,
      required final int orders,
      required final double target,
      @JsonKey(name: 'achievement_percentage')
      required final double achievementPercentage}) = _$BranchMetricsImpl;

  factory _BranchMetrics.fromJson(Map<String, dynamic> json) =
      _$BranchMetricsImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get code;
  @override
  double get revenue;
  @override
  int get orders;
  @override
  double get target;
  @override
  @JsonKey(name: 'achievement_percentage')
  double get achievementPercentage;
  @override
  @JsonKey(ignore: true)
  _$$BranchMetricsImplCopyWith<_$BranchMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityItem _$ActivityItemFromJson(Map<String, dynamic> json) {
  return _ActivityItem.fromJson(json);
}

/// @nodoc
mixin _$ActivityItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_type')
  String get iconType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityItemCopyWith<ActivityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityItemCopyWith<$Res> {
  factory $ActivityItemCopyWith(
          ActivityItem value, $Res Function(ActivityItem) then) =
      _$ActivityItemCopyWithImpl<$Res, ActivityItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_name') String userName,
      String action,
      String details,
      String timestamp,
      @JsonKey(name: 'icon_type') String iconType});
}

/// @nodoc
class _$ActivityItemCopyWithImpl<$Res, $Val extends ActivityItem>
    implements $ActivityItemCopyWith<$Res> {
  _$ActivityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userName = null,
    Object? action = null,
    Object? details = null,
    Object? timestamp = null,
    Object? iconType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      iconType: null == iconType
          ? _value.iconType
          : iconType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityItemImplCopyWith<$Res>
    implements $ActivityItemCopyWith<$Res> {
  factory _$$ActivityItemImplCopyWith(
          _$ActivityItemImpl value, $Res Function(_$ActivityItemImpl) then) =
      __$$ActivityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_name') String userName,
      String action,
      String details,
      String timestamp,
      @JsonKey(name: 'icon_type') String iconType});
}

/// @nodoc
class __$$ActivityItemImplCopyWithImpl<$Res>
    extends _$ActivityItemCopyWithImpl<$Res, _$ActivityItemImpl>
    implements _$$ActivityItemImplCopyWith<$Res> {
  __$$ActivityItemImplCopyWithImpl(
      _$ActivityItemImpl _value, $Res Function(_$ActivityItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userName = null,
    Object? action = null,
    Object? details = null,
    Object? timestamp = null,
    Object? iconType = null,
  }) {
    return _then(_$ActivityItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      iconType: null == iconType
          ? _value.iconType
          : iconType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityItemImpl implements _ActivityItem {
  const _$ActivityItemImpl(
      {required this.id,
      @JsonKey(name: 'user_name') required this.userName,
      required this.action,
      required this.details,
      required this.timestamp,
      @JsonKey(name: 'icon_type') required this.iconType});

  factory _$ActivityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  final String action;
  @override
  final String details;
  @override
  final String timestamp;
  @override
  @JsonKey(name: 'icon_type')
  final String iconType;

  @override
  String toString() {
    return 'ActivityItem(id: $id, userName: $userName, action: $action, details: $details, timestamp: $timestamp, iconType: $iconType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.iconType, iconType) ||
                other.iconType == iconType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userName, action, details, timestamp, iconType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityItemImplCopyWith<_$ActivityItemImpl> get copyWith =>
      __$$ActivityItemImplCopyWithImpl<_$ActivityItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityItemImplToJson(
      this,
    );
  }
}

abstract class _ActivityItem implements ActivityItem {
  const factory _ActivityItem(
          {required final String id,
          @JsonKey(name: 'user_name') required final String userName,
          required final String action,
          required final String details,
          required final String timestamp,
          @JsonKey(name: 'icon_type') required final String iconType}) =
      _$ActivityItemImpl;

  factory _ActivityItem.fromJson(Map<String, dynamic> json) =
      _$ActivityItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  String get action;
  @override
  String get details;
  @override
  String get timestamp;
  @override
  @JsonKey(name: 'icon_type')
  String get iconType;
  @override
  @JsonKey(ignore: true)
  _$$ActivityItemImplCopyWith<_$ActivityItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalesRanking _$SalesRankingFromJson(Map<String, dynamic> json) {
  return _SalesRanking.fromJson(json);
}

/// @nodoc
mixin _$SalesRanking {
  int get rank => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_name')
  String get branchName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sales_amount')
  double get salesAmount => throw _privateConstructorUsedError;
  double get target => throw _privateConstructorUsedError;
  @JsonKey(name: 'achievement_percentage')
  double get achievementPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'performance_level')
  String get performanceLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SalesRankingCopyWith<SalesRanking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesRankingCopyWith<$Res> {
  factory $SalesRankingCopyWith(
          SalesRanking value, $Res Function(SalesRanking) then) =
      _$SalesRankingCopyWithImpl<$Res, SalesRanking>;
  @useResult
  $Res call(
      {int rank,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'branch_name') String branchName,
      @JsonKey(name: 'sales_amount') double salesAmount,
      double target,
      @JsonKey(name: 'achievement_percentage') double achievementPercentage,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'performance_level') String performanceLevel});
}

/// @nodoc
class _$SalesRankingCopyWithImpl<$Res, $Val extends SalesRanking>
    implements $SalesRankingCopyWith<$Res> {
  _$SalesRankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? userId = null,
    Object? fullName = null,
    Object? branchName = null,
    Object? salesAmount = null,
    Object? target = null,
    Object? achievementPercentage = null,
    Object? totalOrders = null,
    Object? performanceLevel = null,
  }) {
    return _then(_value.copyWith(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      branchName: null == branchName
          ? _value.branchName
          : branchName // ignore: cast_nullable_to_non_nullable
              as String,
      salesAmount: null == salesAmount
          ? _value.salesAmount
          : salesAmount // ignore: cast_nullable_to_non_nullable
              as double,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as double,
      achievementPercentage: null == achievementPercentage
          ? _value.achievementPercentage
          : achievementPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      performanceLevel: null == performanceLevel
          ? _value.performanceLevel
          : performanceLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesRankingImplCopyWith<$Res>
    implements $SalesRankingCopyWith<$Res> {
  factory _$$SalesRankingImplCopyWith(
          _$SalesRankingImpl value, $Res Function(_$SalesRankingImpl) then) =
      __$$SalesRankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int rank,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'branch_name') String branchName,
      @JsonKey(name: 'sales_amount') double salesAmount,
      double target,
      @JsonKey(name: 'achievement_percentage') double achievementPercentage,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'performance_level') String performanceLevel});
}

/// @nodoc
class __$$SalesRankingImplCopyWithImpl<$Res>
    extends _$SalesRankingCopyWithImpl<$Res, _$SalesRankingImpl>
    implements _$$SalesRankingImplCopyWith<$Res> {
  __$$SalesRankingImplCopyWithImpl(
      _$SalesRankingImpl _value, $Res Function(_$SalesRankingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? userId = null,
    Object? fullName = null,
    Object? branchName = null,
    Object? salesAmount = null,
    Object? target = null,
    Object? achievementPercentage = null,
    Object? totalOrders = null,
    Object? performanceLevel = null,
  }) {
    return _then(_$SalesRankingImpl(
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      branchName: null == branchName
          ? _value.branchName
          : branchName // ignore: cast_nullable_to_non_nullable
              as String,
      salesAmount: null == salesAmount
          ? _value.salesAmount
          : salesAmount // ignore: cast_nullable_to_non_nullable
              as double,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as double,
      achievementPercentage: null == achievementPercentage
          ? _value.achievementPercentage
          : achievementPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      performanceLevel: null == performanceLevel
          ? _value.performanceLevel
          : performanceLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesRankingImpl implements _SalesRanking {
  const _$SalesRankingImpl(
      {required this.rank,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'full_name') required this.fullName,
      @JsonKey(name: 'branch_name') required this.branchName,
      @JsonKey(name: 'sales_amount') required this.salesAmount,
      required this.target,
      @JsonKey(name: 'achievement_percentage')
      required this.achievementPercentage,
      @JsonKey(name: 'total_orders') required this.totalOrders,
      @JsonKey(name: 'performance_level') required this.performanceLevel});

  factory _$SalesRankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesRankingImplFromJson(json);

  @override
  final int rank;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  @JsonKey(name: 'branch_name')
  final String branchName;
  @override
  @JsonKey(name: 'sales_amount')
  final double salesAmount;
  @override
  final double target;
  @override
  @JsonKey(name: 'achievement_percentage')
  final double achievementPercentage;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'performance_level')
  final String performanceLevel;

  @override
  String toString() {
    return 'SalesRanking(rank: $rank, userId: $userId, fullName: $fullName, branchName: $branchName, salesAmount: $salesAmount, target: $target, achievementPercentage: $achievementPercentage, totalOrders: $totalOrders, performanceLevel: $performanceLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesRankingImpl &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            (identical(other.salesAmount, salesAmount) ||
                other.salesAmount == salesAmount) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.achievementPercentage, achievementPercentage) ||
                other.achievementPercentage == achievementPercentage) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.performanceLevel, performanceLevel) ||
                other.performanceLevel == performanceLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      rank,
      userId,
      fullName,
      branchName,
      salesAmount,
      target,
      achievementPercentage,
      totalOrders,
      performanceLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesRankingImplCopyWith<_$SalesRankingImpl> get copyWith =>
      __$$SalesRankingImplCopyWithImpl<_$SalesRankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesRankingImplToJson(
      this,
    );
  }
}

abstract class _SalesRanking implements SalesRanking {
  const factory _SalesRanking(
      {required final int rank,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'full_name') required final String fullName,
      @JsonKey(name: 'branch_name') required final String branchName,
      @JsonKey(name: 'sales_amount') required final double salesAmount,
      required final double target,
      @JsonKey(name: 'achievement_percentage')
      required final double achievementPercentage,
      @JsonKey(name: 'total_orders') required final int totalOrders,
      @JsonKey(name: 'performance_level')
      required final String performanceLevel}) = _$SalesRankingImpl;

  factory _SalesRanking.fromJson(Map<String, dynamic> json) =
      _$SalesRankingImpl.fromJson;

  @override
  int get rank;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  @JsonKey(name: 'branch_name')
  String get branchName;
  @override
  @JsonKey(name: 'sales_amount')
  double get salesAmount;
  @override
  double get target;
  @override
  @JsonKey(name: 'achievement_percentage')
  double get achievementPercentage;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'performance_level')
  String get performanceLevel;
  @override
  @JsonKey(ignore: true)
  _$$SalesRankingImplCopyWith<_$SalesRankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return _Branch.fromJson(json);
}

/// @nodoc
mixin _$Branch {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_id')
  String? get managerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_employees')
  int? get totalEmployees => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_revenue')
  double? get totalRevenue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BranchCopyWith<Branch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchCopyWith<$Res> {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) then) =
      _$BranchCopyWithImpl<$Res, Branch>;
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String address,
      String phone,
      @JsonKey(name: 'manager_id') String? managerId,
      @JsonKey(name: 'total_employees') int? totalEmployees,
      @JsonKey(name: 'total_revenue') double? totalRevenue});
}

/// @nodoc
class _$BranchCopyWithImpl<$Res, $Val extends Branch>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? managerId = freezed,
    Object? totalEmployees = freezed,
    Object? totalRevenue = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalEmployees: freezed == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRevenue: freezed == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchImplCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$$BranchImplCopyWith(
          _$BranchImpl value, $Res Function(_$BranchImpl) then) =
      __$$BranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String address,
      String phone,
      @JsonKey(name: 'manager_id') String? managerId,
      @JsonKey(name: 'total_employees') int? totalEmployees,
      @JsonKey(name: 'total_revenue') double? totalRevenue});
}

/// @nodoc
class __$$BranchImplCopyWithImpl<$Res>
    extends _$BranchCopyWithImpl<$Res, _$BranchImpl>
    implements _$$BranchImplCopyWith<$Res> {
  __$$BranchImplCopyWithImpl(
      _$BranchImpl _value, $Res Function(_$BranchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? managerId = freezed,
    Object? totalEmployees = freezed,
    Object? totalRevenue = freezed,
  }) {
    return _then(_$BranchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalEmployees: freezed == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int?,
      totalRevenue: freezed == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchImpl implements _Branch {
  const _$BranchImpl(
      {required this.id,
      required this.code,
      required this.name,
      required this.address,
      required this.phone,
      @JsonKey(name: 'manager_id') this.managerId,
      @JsonKey(name: 'total_employees') this.totalEmployees,
      @JsonKey(name: 'total_revenue') this.totalRevenue});

  factory _$BranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String address;
  @override
  final String phone;
  @override
  @JsonKey(name: 'manager_id')
  final String? managerId;
  @override
  @JsonKey(name: 'total_employees')
  final int? totalEmployees;
  @override
  @JsonKey(name: 'total_revenue')
  final double? totalRevenue;

  @override
  String toString() {
    return 'Branch(id: $id, code: $code, name: $name, address: $address, phone: $phone, managerId: $managerId, totalEmployees: $totalEmployees, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, address, phone,
      managerId, totalEmployees, totalRevenue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      __$$BranchImplCopyWithImpl<_$BranchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchImplToJson(
      this,
    );
  }
}

abstract class _Branch implements Branch {
  const factory _Branch(
          {required final String id,
          required final String code,
          required final String name,
          required final String address,
          required final String phone,
          @JsonKey(name: 'manager_id') final String? managerId,
          @JsonKey(name: 'total_employees') final int? totalEmployees,
          @JsonKey(name: 'total_revenue') final double? totalRevenue}) =
      _$BranchImpl;

  factory _Branch.fromJson(Map<String, dynamic> json) = _$BranchImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String get address;
  @override
  String get phone;
  @override
  @JsonKey(name: 'manager_id')
  String? get managerId;
  @override
  @JsonKey(name: 'total_employees')
  int? get totalEmployees;
  @override
  @JsonKey(name: 'total_revenue')
  double? get totalRevenue;
  @override
  @JsonKey(ignore: true)
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BranchDetail _$BranchDetailFromJson(Map<String, dynamic> json) {
  return _BranchDetail.fromJson(json);
}

/// @nodoc
mixin _$BranchDetail {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_id')
  String? get managerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_name')
  String? get managerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_employees')
  int get totalEmployees => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_revenue')
  double get totalRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_approvals')
  int get pendingApprovals => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_activity')
  List<ActivityItem> get recentActivity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BranchDetailCopyWith<BranchDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchDetailCopyWith<$Res> {
  factory $BranchDetailCopyWith(
          BranchDetail value, $Res Function(BranchDetail) then) =
      _$BranchDetailCopyWithImpl<$Res, BranchDetail>;
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String address,
      String phone,
      @JsonKey(name: 'manager_id') String? managerId,
      @JsonKey(name: 'manager_name') String? managerName,
      @JsonKey(name: 'total_employees') int totalEmployees,
      @JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'pending_approvals') int pendingApprovals,
      @JsonKey(name: 'attendance_rate') double attendanceRate,
      @JsonKey(name: 'recent_activity') List<ActivityItem> recentActivity});
}

/// @nodoc
class _$BranchDetailCopyWithImpl<$Res, $Val extends BranchDetail>
    implements $BranchDetailCopyWith<$Res> {
  _$BranchDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? managerId = freezed,
    Object? managerName = freezed,
    Object? totalEmployees = null,
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? pendingApprovals = null,
    Object? attendanceRate = null,
    Object? recentActivity = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingApprovals: null == pendingApprovals
          ? _value.pendingApprovals
          : pendingApprovals // ignore: cast_nullable_to_non_nullable
              as int,
      attendanceRate: null == attendanceRate
          ? _value.attendanceRate
          : attendanceRate // ignore: cast_nullable_to_non_nullable
              as double,
      recentActivity: null == recentActivity
          ? _value.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BranchDetailImplCopyWith<$Res>
    implements $BranchDetailCopyWith<$Res> {
  factory _$$BranchDetailImplCopyWith(
          _$BranchDetailImpl value, $Res Function(_$BranchDetailImpl) then) =
      __$$BranchDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String address,
      String phone,
      @JsonKey(name: 'manager_id') String? managerId,
      @JsonKey(name: 'manager_name') String? managerName,
      @JsonKey(name: 'total_employees') int totalEmployees,
      @JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'pending_approvals') int pendingApprovals,
      @JsonKey(name: 'attendance_rate') double attendanceRate,
      @JsonKey(name: 'recent_activity') List<ActivityItem> recentActivity});
}

/// @nodoc
class __$$BranchDetailImplCopyWithImpl<$Res>
    extends _$BranchDetailCopyWithImpl<$Res, _$BranchDetailImpl>
    implements _$$BranchDetailImplCopyWith<$Res> {
  __$$BranchDetailImplCopyWithImpl(
      _$BranchDetailImpl _value, $Res Function(_$BranchDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? address = null,
    Object? phone = null,
    Object? managerId = freezed,
    Object? managerName = freezed,
    Object? totalEmployees = null,
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? pendingApprovals = null,
    Object? attendanceRate = null,
    Object? recentActivity = null,
  }) {
    return _then(_$BranchDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as String?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
      totalEmployees: null == totalEmployees
          ? _value.totalEmployees
          : totalEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      pendingApprovals: null == pendingApprovals
          ? _value.pendingApprovals
          : pendingApprovals // ignore: cast_nullable_to_non_nullable
              as int,
      attendanceRate: null == attendanceRate
          ? _value.attendanceRate
          : attendanceRate // ignore: cast_nullable_to_non_nullable
              as double,
      recentActivity: null == recentActivity
          ? _value._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchDetailImpl implements _BranchDetail {
  const _$BranchDetailImpl(
      {required this.id,
      required this.code,
      required this.name,
      required this.address,
      required this.phone,
      @JsonKey(name: 'manager_id') this.managerId,
      @JsonKey(name: 'manager_name') this.managerName,
      @JsonKey(name: 'total_employees') required this.totalEmployees,
      @JsonKey(name: 'total_revenue') required this.totalRevenue,
      @JsonKey(name: 'total_orders') required this.totalOrders,
      @JsonKey(name: 'pending_approvals') required this.pendingApprovals,
      @JsonKey(name: 'attendance_rate') required this.attendanceRate,
      @JsonKey(name: 'recent_activity')
      required final List<ActivityItem> recentActivity})
      : _recentActivity = recentActivity;

  factory _$BranchDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String address;
  @override
  final String phone;
  @override
  @JsonKey(name: 'manager_id')
  final String? managerId;
  @override
  @JsonKey(name: 'manager_name')
  final String? managerName;
  @override
  @JsonKey(name: 'total_employees')
  final int totalEmployees;
  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'pending_approvals')
  final int pendingApprovals;
  @override
  @JsonKey(name: 'attendance_rate')
  final double attendanceRate;
  final List<ActivityItem> _recentActivity;
  @override
  @JsonKey(name: 'recent_activity')
  List<ActivityItem> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  @override
  String toString() {
    return 'BranchDetail(id: $id, code: $code, name: $name, address: $address, phone: $phone, managerId: $managerId, managerName: $managerName, totalEmployees: $totalEmployees, totalRevenue: $totalRevenue, totalOrders: $totalOrders, pendingApprovals: $pendingApprovals, attendanceRate: $attendanceRate, recentActivity: $recentActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.totalEmployees, totalEmployees) ||
                other.totalEmployees == totalEmployees) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.pendingApprovals, pendingApprovals) ||
                other.pendingApprovals == pendingApprovals) &&
            (identical(other.attendanceRate, attendanceRate) ||
                other.attendanceRate == attendanceRate) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      name,
      address,
      phone,
      managerId,
      managerName,
      totalEmployees,
      totalRevenue,
      totalOrders,
      pendingApprovals,
      attendanceRate,
      const DeepCollectionEquality().hash(_recentActivity));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchDetailImplCopyWith<_$BranchDetailImpl> get copyWith =>
      __$$BranchDetailImplCopyWithImpl<_$BranchDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchDetailImplToJson(
      this,
    );
  }
}

abstract class _BranchDetail implements BranchDetail {
  const factory _BranchDetail(
      {required final String id,
      required final String code,
      required final String name,
      required final String address,
      required final String phone,
      @JsonKey(name: 'manager_id') final String? managerId,
      @JsonKey(name: 'manager_name') final String? managerName,
      @JsonKey(name: 'total_employees') required final int totalEmployees,
      @JsonKey(name: 'total_revenue') required final double totalRevenue,
      @JsonKey(name: 'total_orders') required final int totalOrders,
      @JsonKey(name: 'pending_approvals') required final int pendingApprovals,
      @JsonKey(name: 'attendance_rate') required final double attendanceRate,
      @JsonKey(name: 'recent_activity')
      required final List<ActivityItem> recentActivity}) = _$BranchDetailImpl;

  factory _BranchDetail.fromJson(Map<String, dynamic> json) =
      _$BranchDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String get address;
  @override
  String get phone;
  @override
  @JsonKey(name: 'manager_id')
  String? get managerId;
  @override
  @JsonKey(name: 'manager_name')
  String? get managerName;
  @override
  @JsonKey(name: 'total_employees')
  int get totalEmployees;
  @override
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'pending_approvals')
  int get pendingApprovals;
  @override
  @JsonKey(name: 'attendance_rate')
  double get attendanceRate;
  @override
  @JsonKey(name: 'recent_activity')
  List<ActivityItem> get recentActivity;
  @override
  @JsonKey(ignore: true)
  _$$BranchDetailImplCopyWith<_$BranchDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
