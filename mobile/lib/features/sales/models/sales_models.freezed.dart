// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesDashboardMetrics _$SalesDashboardMetricsFromJson(
    Map<String, dynamic> json) {
  return _SalesDashboardMetrics.fromJson(json);
}

/// @nodoc
mixin _$SalesDashboardMetrics {
  @JsonKey(name: 'total_prospects')
  int get totalProspects => throw _privateConstructorUsedError;
  @JsonKey(name: 'prospects_by_status')
  ProspectSummary get prospectsByStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_target')
  int get monthlyTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_achieved')
  int get monthlyAchieved => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversion_rate')
  double get conversionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_campaigns')
  int get activeCampaigns => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SalesDashboardMetricsCopyWith<SalesDashboardMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesDashboardMetricsCopyWith<$Res> {
  factory $SalesDashboardMetricsCopyWith(SalesDashboardMetrics value,
          $Res Function(SalesDashboardMetrics) then) =
      _$SalesDashboardMetricsCopyWithImpl<$Res, SalesDashboardMetrics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_prospects') int totalProspects,
      @JsonKey(name: 'prospects_by_status') ProspectSummary prospectsByStatus,
      @JsonKey(name: 'monthly_target') int monthlyTarget,
      @JsonKey(name: 'monthly_achieved') int monthlyAchieved,
      @JsonKey(name: 'conversion_rate') double conversionRate,
      @JsonKey(name: 'active_campaigns') int activeCampaigns});

  $ProspectSummaryCopyWith<$Res> get prospectsByStatus;
}

/// @nodoc
class _$SalesDashboardMetricsCopyWithImpl<$Res,
        $Val extends SalesDashboardMetrics>
    implements $SalesDashboardMetricsCopyWith<$Res> {
  _$SalesDashboardMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProspects = null,
    Object? prospectsByStatus = null,
    Object? monthlyTarget = null,
    Object? monthlyAchieved = null,
    Object? conversionRate = null,
    Object? activeCampaigns = null,
  }) {
    return _then(_value.copyWith(
      totalProspects: null == totalProspects
          ? _value.totalProspects
          : totalProspects // ignore: cast_nullable_to_non_nullable
              as int,
      prospectsByStatus: null == prospectsByStatus
          ? _value.prospectsByStatus
          : prospectsByStatus // ignore: cast_nullable_to_non_nullable
              as ProspectSummary,
      monthlyTarget: null == monthlyTarget
          ? _value.monthlyTarget
          : monthlyTarget // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyAchieved: null == monthlyAchieved
          ? _value.monthlyAchieved
          : monthlyAchieved // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
      activeCampaigns: null == activeCampaigns
          ? _value.activeCampaigns
          : activeCampaigns // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProspectSummaryCopyWith<$Res> get prospectsByStatus {
    return $ProspectSummaryCopyWith<$Res>(_value.prospectsByStatus, (value) {
      return _then(_value.copyWith(prospectsByStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalesDashboardMetricsImplCopyWith<$Res>
    implements $SalesDashboardMetricsCopyWith<$Res> {
  factory _$$SalesDashboardMetricsImplCopyWith(
          _$SalesDashboardMetricsImpl value,
          $Res Function(_$SalesDashboardMetricsImpl) then) =
      __$$SalesDashboardMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_prospects') int totalProspects,
      @JsonKey(name: 'prospects_by_status') ProspectSummary prospectsByStatus,
      @JsonKey(name: 'monthly_target') int monthlyTarget,
      @JsonKey(name: 'monthly_achieved') int monthlyAchieved,
      @JsonKey(name: 'conversion_rate') double conversionRate,
      @JsonKey(name: 'active_campaigns') int activeCampaigns});

  @override
  $ProspectSummaryCopyWith<$Res> get prospectsByStatus;
}

/// @nodoc
class __$$SalesDashboardMetricsImplCopyWithImpl<$Res>
    extends _$SalesDashboardMetricsCopyWithImpl<$Res,
        _$SalesDashboardMetricsImpl>
    implements _$$SalesDashboardMetricsImplCopyWith<$Res> {
  __$$SalesDashboardMetricsImplCopyWithImpl(_$SalesDashboardMetricsImpl _value,
      $Res Function(_$SalesDashboardMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProspects = null,
    Object? prospectsByStatus = null,
    Object? monthlyTarget = null,
    Object? monthlyAchieved = null,
    Object? conversionRate = null,
    Object? activeCampaigns = null,
  }) {
    return _then(_$SalesDashboardMetricsImpl(
      totalProspects: null == totalProspects
          ? _value.totalProspects
          : totalProspects // ignore: cast_nullable_to_non_nullable
              as int,
      prospectsByStatus: null == prospectsByStatus
          ? _value.prospectsByStatus
          : prospectsByStatus // ignore: cast_nullable_to_non_nullable
              as ProspectSummary,
      monthlyTarget: null == monthlyTarget
          ? _value.monthlyTarget
          : monthlyTarget // ignore: cast_nullable_to_non_nullable
              as int,
      monthlyAchieved: null == monthlyAchieved
          ? _value.monthlyAchieved
          : monthlyAchieved // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
      activeCampaigns: null == activeCampaigns
          ? _value.activeCampaigns
          : activeCampaigns // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesDashboardMetricsImpl implements _SalesDashboardMetrics {
  const _$SalesDashboardMetricsImpl(
      {@JsonKey(name: 'total_prospects') required this.totalProspects,
      @JsonKey(name: 'prospects_by_status') required this.prospectsByStatus,
      @JsonKey(name: 'monthly_target') required this.monthlyTarget,
      @JsonKey(name: 'monthly_achieved') required this.monthlyAchieved,
      @JsonKey(name: 'conversion_rate') required this.conversionRate,
      @JsonKey(name: 'active_campaigns') required this.activeCampaigns});

  factory _$SalesDashboardMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesDashboardMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'total_prospects')
  final int totalProspects;
  @override
  @JsonKey(name: 'prospects_by_status')
  final ProspectSummary prospectsByStatus;
  @override
  @JsonKey(name: 'monthly_target')
  final int monthlyTarget;
  @override
  @JsonKey(name: 'monthly_achieved')
  final int monthlyAchieved;
  @override
  @JsonKey(name: 'conversion_rate')
  final double conversionRate;
  @override
  @JsonKey(name: 'active_campaigns')
  final int activeCampaigns;

  @override
  String toString() {
    return 'SalesDashboardMetrics(totalProspects: $totalProspects, prospectsByStatus: $prospectsByStatus, monthlyTarget: $monthlyTarget, monthlyAchieved: $monthlyAchieved, conversionRate: $conversionRate, activeCampaigns: $activeCampaigns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesDashboardMetricsImpl &&
            (identical(other.totalProspects, totalProspects) ||
                other.totalProspects == totalProspects) &&
            (identical(other.prospectsByStatus, prospectsByStatus) ||
                other.prospectsByStatus == prospectsByStatus) &&
            (identical(other.monthlyTarget, monthlyTarget) ||
                other.monthlyTarget == monthlyTarget) &&
            (identical(other.monthlyAchieved, monthlyAchieved) ||
                other.monthlyAchieved == monthlyAchieved) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate) &&
            (identical(other.activeCampaigns, activeCampaigns) ||
                other.activeCampaigns == activeCampaigns));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalProspects,
      prospectsByStatus,
      monthlyTarget,
      monthlyAchieved,
      conversionRate,
      activeCampaigns);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesDashboardMetricsImplCopyWith<_$SalesDashboardMetricsImpl>
      get copyWith => __$$SalesDashboardMetricsImplCopyWithImpl<
          _$SalesDashboardMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesDashboardMetricsImplToJson(
      this,
    );
  }
}

abstract class _SalesDashboardMetrics implements SalesDashboardMetrics {
  const factory _SalesDashboardMetrics(
      {@JsonKey(name: 'total_prospects') required final int totalProspects,
      @JsonKey(name: 'prospects_by_status')
      required final ProspectSummary prospectsByStatus,
      @JsonKey(name: 'monthly_target') required final int monthlyTarget,
      @JsonKey(name: 'monthly_achieved') required final int monthlyAchieved,
      @JsonKey(name: 'conversion_rate') required final double conversionRate,
      @JsonKey(name: 'active_campaigns')
      required final int activeCampaigns}) = _$SalesDashboardMetricsImpl;

  factory _SalesDashboardMetrics.fromJson(Map<String, dynamic> json) =
      _$SalesDashboardMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'total_prospects')
  int get totalProspects;
  @override
  @JsonKey(name: 'prospects_by_status')
  ProspectSummary get prospectsByStatus;
  @override
  @JsonKey(name: 'monthly_target')
  int get monthlyTarget;
  @override
  @JsonKey(name: 'monthly_achieved')
  int get monthlyAchieved;
  @override
  @JsonKey(name: 'conversion_rate')
  double get conversionRate;
  @override
  @JsonKey(name: 'active_campaigns')
  int get activeCampaigns;
  @override
  @JsonKey(ignore: true)
  _$$SalesDashboardMetricsImplCopyWith<_$SalesDashboardMetricsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProspectSummary _$ProspectSummaryFromJson(Map<String, dynamic> json) {
  return _ProspectSummary.fromJson(json);
}

/// @nodoc
mixin _$ProspectSummary {
  @JsonKey(name: 'new')
  int get newCount => throw _privateConstructorUsedError;
  int get contacted => throw _privateConstructorUsedError;
  int get negotiation => throw _privateConstructorUsedError;
  int get closed => throw _privateConstructorUsedError;
  int get lost => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProspectSummaryCopyWith<ProspectSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProspectSummaryCopyWith<$Res> {
  factory $ProspectSummaryCopyWith(
          ProspectSummary value, $Res Function(ProspectSummary) then) =
      _$ProspectSummaryCopyWithImpl<$Res, ProspectSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'new') int newCount,
      int contacted,
      int negotiation,
      int closed,
      int lost});
}

/// @nodoc
class _$ProspectSummaryCopyWithImpl<$Res, $Val extends ProspectSummary>
    implements $ProspectSummaryCopyWith<$Res> {
  _$ProspectSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newCount = null,
    Object? contacted = null,
    Object? negotiation = null,
    Object? closed = null,
    Object? lost = null,
  }) {
    return _then(_value.copyWith(
      newCount: null == newCount
          ? _value.newCount
          : newCount // ignore: cast_nullable_to_non_nullable
              as int,
      contacted: null == contacted
          ? _value.contacted
          : contacted // ignore: cast_nullable_to_non_nullable
              as int,
      negotiation: null == negotiation
          ? _value.negotiation
          : negotiation // ignore: cast_nullable_to_non_nullable
              as int,
      closed: null == closed
          ? _value.closed
          : closed // ignore: cast_nullable_to_non_nullable
              as int,
      lost: null == lost
          ? _value.lost
          : lost // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProspectSummaryImplCopyWith<$Res>
    implements $ProspectSummaryCopyWith<$Res> {
  factory _$$ProspectSummaryImplCopyWith(_$ProspectSummaryImpl value,
          $Res Function(_$ProspectSummaryImpl) then) =
      __$$ProspectSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'new') int newCount,
      int contacted,
      int negotiation,
      int closed,
      int lost});
}

/// @nodoc
class __$$ProspectSummaryImplCopyWithImpl<$Res>
    extends _$ProspectSummaryCopyWithImpl<$Res, _$ProspectSummaryImpl>
    implements _$$ProspectSummaryImplCopyWith<$Res> {
  __$$ProspectSummaryImplCopyWithImpl(
      _$ProspectSummaryImpl _value, $Res Function(_$ProspectSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newCount = null,
    Object? contacted = null,
    Object? negotiation = null,
    Object? closed = null,
    Object? lost = null,
  }) {
    return _then(_$ProspectSummaryImpl(
      newCount: null == newCount
          ? _value.newCount
          : newCount // ignore: cast_nullable_to_non_nullable
              as int,
      contacted: null == contacted
          ? _value.contacted
          : contacted // ignore: cast_nullable_to_non_nullable
              as int,
      negotiation: null == negotiation
          ? _value.negotiation
          : negotiation // ignore: cast_nullable_to_non_nullable
              as int,
      closed: null == closed
          ? _value.closed
          : closed // ignore: cast_nullable_to_non_nullable
              as int,
      lost: null == lost
          ? _value.lost
          : lost // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProspectSummaryImpl implements _ProspectSummary {
  const _$ProspectSummaryImpl(
      {@JsonKey(name: 'new') required this.newCount,
      required this.contacted,
      required this.negotiation,
      required this.closed,
      required this.lost});

  factory _$ProspectSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProspectSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'new')
  final int newCount;
  @override
  final int contacted;
  @override
  final int negotiation;
  @override
  final int closed;
  @override
  final int lost;

  @override
  String toString() {
    return 'ProspectSummary(newCount: $newCount, contacted: $contacted, negotiation: $negotiation, closed: $closed, lost: $lost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProspectSummaryImpl &&
            (identical(other.newCount, newCount) ||
                other.newCount == newCount) &&
            (identical(other.contacted, contacted) ||
                other.contacted == contacted) &&
            (identical(other.negotiation, negotiation) ||
                other.negotiation == negotiation) &&
            (identical(other.closed, closed) || other.closed == closed) &&
            (identical(other.lost, lost) || other.lost == lost));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, newCount, contacted, negotiation, closed, lost);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProspectSummaryImplCopyWith<_$ProspectSummaryImpl> get copyWith =>
      __$$ProspectSummaryImplCopyWithImpl<_$ProspectSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProspectSummaryImplToJson(
      this,
    );
  }
}

abstract class _ProspectSummary implements ProspectSummary {
  const factory _ProspectSummary(
      {@JsonKey(name: 'new') required final int newCount,
      required final int contacted,
      required final int negotiation,
      required final int closed,
      required final int lost}) = _$ProspectSummaryImpl;

  factory _ProspectSummary.fromJson(Map<String, dynamic> json) =
      _$ProspectSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'new')
  int get newCount;
  @override
  int get contacted;
  @override
  int get negotiation;
  @override
  int get closed;
  @override
  int get lost;
  @override
  @JsonKey(ignore: true)
  _$$ProspectSummaryImplCopyWith<_$ProspectSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Prospect _$ProspectFromJson(Map<String, dynamic> json) {
  return _Prospect.fromJson(json);
}

/// @nodoc
mixin _$Prospect {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // new, contacted, negotiation, closed, lost
  String? get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_interest')
  String? get productInterest => throw _privateConstructorUsedError;
  int? get budget => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_contact')
  String? get lastContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_followup')
  String? get nextFollowup => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProspectCopyWith<Prospect> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProspectCopyWith<$Res> {
  factory $ProspectCopyWith(Prospect value, $Res Function(Prospect) then) =
      _$ProspectCopyWithImpl<$Res, Prospect>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String phone,
      String? email,
      String? address,
      String status,
      String? source,
      @JsonKey(name: 'product_interest') String? productInterest,
      int? budget,
      String? notes,
      @JsonKey(name: 'last_contact') String? lastContact,
      @JsonKey(name: 'next_followup') String? nextFollowup,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$ProspectCopyWithImpl<$Res, $Val extends Prospect>
    implements $ProspectCopyWith<$Res> {
  _$ProspectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? status = null,
    Object? source = freezed,
    Object? productInterest = freezed,
    Object? budget = freezed,
    Object? notes = freezed,
    Object? lastContact = freezed,
    Object? nextFollowup = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      productInterest: freezed == productInterest
          ? _value.productInterest
          : productInterest // ignore: cast_nullable_to_non_nullable
              as String?,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastContact: freezed == lastContact
          ? _value.lastContact
          : lastContact // ignore: cast_nullable_to_non_nullable
              as String?,
      nextFollowup: freezed == nextFollowup
          ? _value.nextFollowup
          : nextFollowup // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProspectImplCopyWith<$Res>
    implements $ProspectCopyWith<$Res> {
  factory _$$ProspectImplCopyWith(
          _$ProspectImpl value, $Res Function(_$ProspectImpl) then) =
      __$$ProspectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String phone,
      String? email,
      String? address,
      String status,
      String? source,
      @JsonKey(name: 'product_interest') String? productInterest,
      int? budget,
      String? notes,
      @JsonKey(name: 'last_contact') String? lastContact,
      @JsonKey(name: 'next_followup') String? nextFollowup,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$ProspectImplCopyWithImpl<$Res>
    extends _$ProspectCopyWithImpl<$Res, _$ProspectImpl>
    implements _$$ProspectImplCopyWith<$Res> {
  __$$ProspectImplCopyWithImpl(
      _$ProspectImpl _value, $Res Function(_$ProspectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? email = freezed,
    Object? address = freezed,
    Object? status = null,
    Object? source = freezed,
    Object? productInterest = freezed,
    Object? budget = freezed,
    Object? notes = freezed,
    Object? lastContact = freezed,
    Object? nextFollowup = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProspectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      productInterest: freezed == productInterest
          ? _value.productInterest
          : productInterest // ignore: cast_nullable_to_non_nullable
              as String?,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastContact: freezed == lastContact
          ? _value.lastContact
          : lastContact // ignore: cast_nullable_to_non_nullable
              as String?,
      nextFollowup: freezed == nextFollowup
          ? _value.nextFollowup
          : nextFollowup // ignore: cast_nullable_to_non_nullable
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
class _$ProspectImpl implements _Prospect {
  const _$ProspectImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      required this.phone,
      this.email,
      this.address,
      required this.status,
      this.source,
      @JsonKey(name: 'product_interest') this.productInterest,
      this.budget,
      this.notes,
      @JsonKey(name: 'last_contact') this.lastContact,
      @JsonKey(name: 'next_followup') this.nextFollowup,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ProspectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProspectImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  final String status;
// new, contacted, negotiation, closed, lost
  @override
  final String? source;
  @override
  @JsonKey(name: 'product_interest')
  final String? productInterest;
  @override
  final int? budget;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'last_contact')
  final String? lastContact;
  @override
  @JsonKey(name: 'next_followup')
  final String? nextFollowup;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'Prospect(id: $id, userId: $userId, name: $name, phone: $phone, email: $email, address: $address, status: $status, source: $source, productInterest: $productInterest, budget: $budget, notes: $notes, lastContact: $lastContact, nextFollowup: $nextFollowup, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProspectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.productInterest, productInterest) ||
                other.productInterest == productInterest) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lastContact, lastContact) ||
                other.lastContact == lastContact) &&
            (identical(other.nextFollowup, nextFollowup) ||
                other.nextFollowup == nextFollowup) &&
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
      userId,
      name,
      phone,
      email,
      address,
      status,
      source,
      productInterest,
      budget,
      notes,
      lastContact,
      nextFollowup,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProspectImplCopyWith<_$ProspectImpl> get copyWith =>
      __$$ProspectImplCopyWithImpl<_$ProspectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProspectImplToJson(
      this,
    );
  }
}

abstract class _Prospect implements Prospect {
  const factory _Prospect(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String name,
          required final String phone,
          final String? email,
          final String? address,
          required final String status,
          final String? source,
          @JsonKey(name: 'product_interest') final String? productInterest,
          final int? budget,
          final String? notes,
          @JsonKey(name: 'last_contact') final String? lastContact,
          @JsonKey(name: 'next_followup') final String? nextFollowup,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$ProspectImpl;

  factory _Prospect.fromJson(Map<String, dynamic> json) =
      _$ProspectImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  String get status;
  @override // new, contacted, negotiation, closed, lost
  String? get source;
  @override
  @JsonKey(name: 'product_interest')
  String? get productInterest;
  @override
  int? get budget;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'last_contact')
  String? get lastContact;
  @override
  @JsonKey(name: 'next_followup')
  String? get nextFollowup;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProspectImplCopyWith<_$ProspectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Campaign _$CampaignFromJson(Map<String, dynamic> json) {
  return _Campaign.fromJson(json);
}

/// @nodoc
mixin _$Campaign {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_amount')
  int get targetAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'achieved_amount')
  int get achievedAmount => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // active, completed, cancelled
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CampaignCopyWith<Campaign> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CampaignCopyWith<$Res> {
  factory $CampaignCopyWith(Campaign value, $Res Function(Campaign) then) =
      _$CampaignCopyWithImpl<$Res, Campaign>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String? description,
      @JsonKey(name: 'target_amount') int targetAmount,
      @JsonKey(name: 'achieved_amount') int achievedAmount,
      String status,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$CampaignCopyWithImpl<$Res, $Val extends Campaign>
    implements $CampaignCopyWith<$Res> {
  _$CampaignCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? targetAmount = null,
    Object? achievedAmount = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as int,
      achievedAmount: null == achievedAmount
          ? _value.achievedAmount
          : achievedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CampaignImplCopyWith<$Res>
    implements $CampaignCopyWith<$Res> {
  factory _$$CampaignImplCopyWith(
          _$CampaignImpl value, $Res Function(_$CampaignImpl) then) =
      __$$CampaignImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String name,
      String? description,
      @JsonKey(name: 'target_amount') int targetAmount,
      @JsonKey(name: 'achieved_amount') int achievedAmount,
      String status,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$CampaignImplCopyWithImpl<$Res>
    extends _$CampaignCopyWithImpl<$Res, _$CampaignImpl>
    implements _$$CampaignImplCopyWith<$Res> {
  __$$CampaignImplCopyWithImpl(
      _$CampaignImpl _value, $Res Function(_$CampaignImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? description = freezed,
    Object? targetAmount = null,
    Object? achievedAmount = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
  }) {
    return _then(_$CampaignImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as int,
      achievedAmount: null == achievedAmount
          ? _value.achievedAmount
          : achievedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CampaignImpl implements _Campaign {
  const _$CampaignImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      this.description,
      @JsonKey(name: 'target_amount') required this.targetAmount,
      @JsonKey(name: 'achieved_amount') required this.achievedAmount,
      required this.status,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') required this.endDate,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$CampaignImpl.fromJson(Map<String, dynamic> json) =>
      _$$CampaignImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'target_amount')
  final int targetAmount;
  @override
  @JsonKey(name: 'achieved_amount')
  final int achievedAmount;
  @override
  final String status;
// active, completed, cancelled
  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'end_date')
  final String endDate;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'Campaign(id: $id, userId: $userId, name: $name, description: $description, targetAmount: $targetAmount, achievedAmount: $achievedAmount, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CampaignImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.achievedAmount, achievedAmount) ||
                other.achievedAmount == achievedAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, name, description,
      targetAmount, achievedAmount, status, startDate, endDate, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CampaignImplCopyWith<_$CampaignImpl> get copyWith =>
      __$$CampaignImplCopyWithImpl<_$CampaignImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CampaignImplToJson(
      this,
    );
  }
}

abstract class _Campaign implements Campaign {
  const factory _Campaign(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String name,
          final String? description,
          @JsonKey(name: 'target_amount') required final int targetAmount,
          @JsonKey(name: 'achieved_amount') required final int achievedAmount,
          required final String status,
          @JsonKey(name: 'start_date') required final String startDate,
          @JsonKey(name: 'end_date') required final String endDate,
          @JsonKey(name: 'created_at') required final String createdAt}) =
      _$CampaignImpl;

  factory _Campaign.fromJson(Map<String, dynamic> json) =
      _$CampaignImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'target_amount')
  int get targetAmount;
  @override
  @JsonKey(name: 'achieved_amount')
  int get achievedAmount;
  @override
  String get status;
  @override // active, completed, cancelled
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'end_date')
  String get endDate;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CampaignImplCopyWith<_$CampaignImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SalesReport _$SalesReportFromJson(Map<String, dynamic> json) {
  return _SalesReport.fromJson(json);
}

/// @nodoc
mixin _$SalesReport {
  @JsonKey(name: 'total_closed')
  int get totalClosed => throw _privateConstructorUsedError;
  int get target => throw _privateConstructorUsedError;
  @JsonKey(name: 'achievement_percentage')
  int get achievementPercentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SalesReportCopyWith<SalesReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesReportCopyWith<$Res> {
  factory $SalesReportCopyWith(
          SalesReport value, $Res Function(SalesReport) then) =
      _$SalesReportCopyWithImpl<$Res, SalesReport>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_closed') int totalClosed,
      int target,
      @JsonKey(name: 'achievement_percentage') int achievementPercentage});
}

/// @nodoc
class _$SalesReportCopyWithImpl<$Res, $Val extends SalesReport>
    implements $SalesReportCopyWith<$Res> {
  _$SalesReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalClosed = null,
    Object? target = null,
    Object? achievementPercentage = null,
  }) {
    return _then(_value.copyWith(
      totalClosed: null == totalClosed
          ? _value.totalClosed
          : totalClosed // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
      achievementPercentage: null == achievementPercentage
          ? _value.achievementPercentage
          : achievementPercentage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesReportImplCopyWith<$Res>
    implements $SalesReportCopyWith<$Res> {
  factory _$$SalesReportImplCopyWith(
          _$SalesReportImpl value, $Res Function(_$SalesReportImpl) then) =
      __$$SalesReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_closed') int totalClosed,
      int target,
      @JsonKey(name: 'achievement_percentage') int achievementPercentage});
}

/// @nodoc
class __$$SalesReportImplCopyWithImpl<$Res>
    extends _$SalesReportCopyWithImpl<$Res, _$SalesReportImpl>
    implements _$$SalesReportImplCopyWith<$Res> {
  __$$SalesReportImplCopyWithImpl(
      _$SalesReportImpl _value, $Res Function(_$SalesReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalClosed = null,
    Object? target = null,
    Object? achievementPercentage = null,
  }) {
    return _then(_$SalesReportImpl(
      totalClosed: null == totalClosed
          ? _value.totalClosed
          : totalClosed // ignore: cast_nullable_to_non_nullable
              as int,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
      achievementPercentage: null == achievementPercentage
          ? _value.achievementPercentage
          : achievementPercentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesReportImpl implements _SalesReport {
  const _$SalesReportImpl(
      {@JsonKey(name: 'total_closed') required this.totalClosed,
      required this.target,
      @JsonKey(name: 'achievement_percentage')
      required this.achievementPercentage});

  factory _$SalesReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesReportImplFromJson(json);

  @override
  @JsonKey(name: 'total_closed')
  final int totalClosed;
  @override
  final int target;
  @override
  @JsonKey(name: 'achievement_percentage')
  final int achievementPercentage;

  @override
  String toString() {
    return 'SalesReport(totalClosed: $totalClosed, target: $target, achievementPercentage: $achievementPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesReportImpl &&
            (identical(other.totalClosed, totalClosed) ||
                other.totalClosed == totalClosed) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.achievementPercentage, achievementPercentage) ||
                other.achievementPercentage == achievementPercentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalClosed, target, achievementPercentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesReportImplCopyWith<_$SalesReportImpl> get copyWith =>
      __$$SalesReportImplCopyWithImpl<_$SalesReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesReportImplToJson(
      this,
    );
  }
}

abstract class _SalesReport implements SalesReport {
  const factory _SalesReport(
      {@JsonKey(name: 'total_closed') required final int totalClosed,
      required final int target,
      @JsonKey(name: 'achievement_percentage')
      required final int achievementPercentage}) = _$SalesReportImpl;

  factory _SalesReport.fromJson(Map<String, dynamic> json) =
      _$SalesReportImpl.fromJson;

  @override
  @JsonKey(name: 'total_closed')
  int get totalClosed;
  @override
  int get target;
  @override
  @JsonKey(name: 'achievement_percentage')
  int get achievementPercentage;
  @override
  @JsonKey(ignore: true)
  _$$SalesReportImplCopyWith<_$SalesReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
