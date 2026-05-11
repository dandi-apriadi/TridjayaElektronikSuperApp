// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crm_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CrmCustomer _$CrmCustomerFromJson(Map<String, dynamic> json) {
  return _CrmCustomer.fromJson(json);
}

/// @nodoc
mixin _$CrmCustomer {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // hot, warm, cold, converted, lost
  String? get source => throw _privateConstructorUsedError;
  int? get budget => throw _privateConstructorUsedError;
  String? get interest => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_interaction')
  String? get lastInteraction => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_followup')
  String? get nextFollowup => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CrmCustomerCopyWith<CrmCustomer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrmCustomerCopyWith<$Res> {
  factory $CrmCustomerCopyWith(
          CrmCustomer value, $Res Function(CrmCustomer) then) =
      _$CrmCustomerCopyWithImpl<$Res, CrmCustomer>;
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
      int? budget,
      String? interest,
      String? notes,
      @JsonKey(name: 'last_interaction') String? lastInteraction,
      @JsonKey(name: 'next_followup') String? nextFollowup,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$CrmCustomerCopyWithImpl<$Res, $Val extends CrmCustomer>
    implements $CrmCustomerCopyWith<$Res> {
  _$CrmCustomerCopyWithImpl(this._value, this._then);

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
    Object? budget = freezed,
    Object? interest = freezed,
    Object? notes = freezed,
    Object? lastInteraction = freezed,
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
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
      interest: freezed == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastInteraction: freezed == lastInteraction
          ? _value.lastInteraction
          : lastInteraction // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CrmCustomerImplCopyWith<$Res>
    implements $CrmCustomerCopyWith<$Res> {
  factory _$$CrmCustomerImplCopyWith(
          _$CrmCustomerImpl value, $Res Function(_$CrmCustomerImpl) then) =
      __$$CrmCustomerImplCopyWithImpl<$Res>;
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
      int? budget,
      String? interest,
      String? notes,
      @JsonKey(name: 'last_interaction') String? lastInteraction,
      @JsonKey(name: 'next_followup') String? nextFollowup,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$CrmCustomerImplCopyWithImpl<$Res>
    extends _$CrmCustomerCopyWithImpl<$Res, _$CrmCustomerImpl>
    implements _$$CrmCustomerImplCopyWith<$Res> {
  __$$CrmCustomerImplCopyWithImpl(
      _$CrmCustomerImpl _value, $Res Function(_$CrmCustomerImpl) _then)
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
    Object? budget = freezed,
    Object? interest = freezed,
    Object? notes = freezed,
    Object? lastInteraction = freezed,
    Object? nextFollowup = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CrmCustomerImpl(
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
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
      interest: freezed == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      lastInteraction: freezed == lastInteraction
          ? _value.lastInteraction
          : lastInteraction // ignore: cast_nullable_to_non_nullable
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
class _$CrmCustomerImpl implements _CrmCustomer {
  const _$CrmCustomerImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      required this.phone,
      this.email,
      this.address,
      required this.status,
      this.source,
      this.budget,
      this.interest,
      this.notes,
      @JsonKey(name: 'last_interaction') this.lastInteraction,
      @JsonKey(name: 'next_followup') this.nextFollowup,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$CrmCustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrmCustomerImplFromJson(json);

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
// hot, warm, cold, converted, lost
  @override
  final String? source;
  @override
  final int? budget;
  @override
  final String? interest;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'last_interaction')
  final String? lastInteraction;
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
    return 'CrmCustomer(id: $id, userId: $userId, name: $name, phone: $phone, email: $email, address: $address, status: $status, source: $source, budget: $budget, interest: $interest, notes: $notes, lastInteraction: $lastInteraction, nextFollowup: $nextFollowup, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrmCustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.interest, interest) ||
                other.interest == interest) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.lastInteraction, lastInteraction) ||
                other.lastInteraction == lastInteraction) &&
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
      budget,
      interest,
      notes,
      lastInteraction,
      nextFollowup,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CrmCustomerImplCopyWith<_$CrmCustomerImpl> get copyWith =>
      __$$CrmCustomerImplCopyWithImpl<_$CrmCustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CrmCustomerImplToJson(
      this,
    );
  }
}

abstract class _CrmCustomer implements CrmCustomer {
  const factory _CrmCustomer(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String name,
          required final String phone,
          final String? email,
          final String? address,
          required final String status,
          final String? source,
          final int? budget,
          final String? interest,
          final String? notes,
          @JsonKey(name: 'last_interaction') final String? lastInteraction,
          @JsonKey(name: 'next_followup') final String? nextFollowup,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$CrmCustomerImpl;

  factory _CrmCustomer.fromJson(Map<String, dynamic> json) =
      _$CrmCustomerImpl.fromJson;

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
  @override // hot, warm, cold, converted, lost
  String? get source;
  @override
  int? get budget;
  @override
  String? get interest;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'last_interaction')
  String? get lastInteraction;
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
  _$$CrmCustomerImplCopyWith<_$CrmCustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerInteraction _$CustomerInteractionFromJson(Map<String, dynamic> json) {
  return _CustomerInteraction.fromJson(json);
}

/// @nodoc
mixin _$CustomerInteraction {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'interaction_type')
  String get interactionType =>
      throw _privateConstructorUsedError; // call, email, meeting, message
  String get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerInteractionCopyWith<CustomerInteraction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInteractionCopyWith<$Res> {
  factory $CustomerInteractionCopyWith(
          CustomerInteraction value, $Res Function(CustomerInteraction) then) =
      _$CustomerInteractionCopyWithImpl<$Res, CustomerInteraction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'customer_id') String customerId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'interaction_type') String interactionType,
      String notes,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$CustomerInteractionCopyWithImpl<$Res, $Val extends CustomerInteraction>
    implements $CustomerInteractionCopyWith<$Res> {
  _$CustomerInteractionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? userId = null,
    Object? interactionType = null,
    Object? notes = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      interactionType: null == interactionType
          ? _value.interactionType
          : interactionType // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerInteractionImplCopyWith<$Res>
    implements $CustomerInteractionCopyWith<$Res> {
  factory _$$CustomerInteractionImplCopyWith(_$CustomerInteractionImpl value,
          $Res Function(_$CustomerInteractionImpl) then) =
      __$$CustomerInteractionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'customer_id') String customerId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'interaction_type') String interactionType,
      String notes,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$CustomerInteractionImplCopyWithImpl<$Res>
    extends _$CustomerInteractionCopyWithImpl<$Res, _$CustomerInteractionImpl>
    implements _$$CustomerInteractionImplCopyWith<$Res> {
  __$$CustomerInteractionImplCopyWithImpl(_$CustomerInteractionImpl _value,
      $Res Function(_$CustomerInteractionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? userId = null,
    Object? interactionType = null,
    Object? notes = null,
    Object? createdAt = null,
  }) {
    return _then(_$CustomerInteractionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      interactionType: null == interactionType
          ? _value.interactionType
          : interactionType // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
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
class _$CustomerInteractionImpl implements _CustomerInteraction {
  const _$CustomerInteractionImpl(
      {required this.id,
      @JsonKey(name: 'customer_id') required this.customerId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'interaction_type') required this.interactionType,
      required this.notes,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$CustomerInteractionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInteractionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'interaction_type')
  final String interactionType;
// call, email, meeting, message
  @override
  final String notes;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'CustomerInteraction(id: $id, customerId: $customerId, userId: $userId, interactionType: $interactionType, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInteractionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.interactionType, interactionType) ||
                other.interactionType == interactionType) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, customerId, userId, interactionType, notes, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInteractionImplCopyWith<_$CustomerInteractionImpl> get copyWith =>
      __$$CustomerInteractionImplCopyWithImpl<_$CustomerInteractionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInteractionImplToJson(
      this,
    );
  }
}

abstract class _CustomerInteraction implements CustomerInteraction {
  const factory _CustomerInteraction(
      {required final String id,
      @JsonKey(name: 'customer_id') required final String customerId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'interaction_type') required final String interactionType,
      required final String notes,
      @JsonKey(name: 'created_at')
      required final String createdAt}) = _$CustomerInteractionImpl;

  factory _CustomerInteraction.fromJson(Map<String, dynamic> json) =
      _$CustomerInteractionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'interaction_type')
  String get interactionType;
  @override // call, email, meeting, message
  String get notes;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$CustomerInteractionImplCopyWith<_$CustomerInteractionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CrmStatistics _$CrmStatisticsFromJson(Map<String, dynamic> json) {
  return _CrmStatistics.fromJson(json);
}

/// @nodoc
mixin _$CrmStatistics {
  @JsonKey(name: 'total_customers')
  int get totalCustomers => throw _privateConstructorUsedError;
  @JsonKey(name: 'hot_prospects')
  int get hotProspects => throw _privateConstructorUsedError;
  @JsonKey(name: 'warm_prospects')
  int get warmProspects => throw _privateConstructorUsedError;
  @JsonKey(name: 'cold_prospects')
  int get coldProspects => throw _privateConstructorUsedError;
  int get converted => throw _privateConstructorUsedError;
  int get lost => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversion_rate')
  double get conversionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_interactions')
  int get totalInteractions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CrmStatisticsCopyWith<CrmStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrmStatisticsCopyWith<$Res> {
  factory $CrmStatisticsCopyWith(
          CrmStatistics value, $Res Function(CrmStatistics) then) =
      _$CrmStatisticsCopyWithImpl<$Res, CrmStatistics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_customers') int totalCustomers,
      @JsonKey(name: 'hot_prospects') int hotProspects,
      @JsonKey(name: 'warm_prospects') int warmProspects,
      @JsonKey(name: 'cold_prospects') int coldProspects,
      int converted,
      int lost,
      @JsonKey(name: 'conversion_rate') double conversionRate,
      @JsonKey(name: 'total_interactions') int totalInteractions});
}

/// @nodoc
class _$CrmStatisticsCopyWithImpl<$Res, $Val extends CrmStatistics>
    implements $CrmStatisticsCopyWith<$Res> {
  _$CrmStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCustomers = null,
    Object? hotProspects = null,
    Object? warmProspects = null,
    Object? coldProspects = null,
    Object? converted = null,
    Object? lost = null,
    Object? conversionRate = null,
    Object? totalInteractions = null,
  }) {
    return _then(_value.copyWith(
      totalCustomers: null == totalCustomers
          ? _value.totalCustomers
          : totalCustomers // ignore: cast_nullable_to_non_nullable
              as int,
      hotProspects: null == hotProspects
          ? _value.hotProspects
          : hotProspects // ignore: cast_nullable_to_non_nullable
              as int,
      warmProspects: null == warmProspects
          ? _value.warmProspects
          : warmProspects // ignore: cast_nullable_to_non_nullable
              as int,
      coldProspects: null == coldProspects
          ? _value.coldProspects
          : coldProspects // ignore: cast_nullable_to_non_nullable
              as int,
      converted: null == converted
          ? _value.converted
          : converted // ignore: cast_nullable_to_non_nullable
              as int,
      lost: null == lost
          ? _value.lost
          : lost // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalInteractions: null == totalInteractions
          ? _value.totalInteractions
          : totalInteractions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CrmStatisticsImplCopyWith<$Res>
    implements $CrmStatisticsCopyWith<$Res> {
  factory _$$CrmStatisticsImplCopyWith(
          _$CrmStatisticsImpl value, $Res Function(_$CrmStatisticsImpl) then) =
      __$$CrmStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_customers') int totalCustomers,
      @JsonKey(name: 'hot_prospects') int hotProspects,
      @JsonKey(name: 'warm_prospects') int warmProspects,
      @JsonKey(name: 'cold_prospects') int coldProspects,
      int converted,
      int lost,
      @JsonKey(name: 'conversion_rate') double conversionRate,
      @JsonKey(name: 'total_interactions') int totalInteractions});
}

/// @nodoc
class __$$CrmStatisticsImplCopyWithImpl<$Res>
    extends _$CrmStatisticsCopyWithImpl<$Res, _$CrmStatisticsImpl>
    implements _$$CrmStatisticsImplCopyWith<$Res> {
  __$$CrmStatisticsImplCopyWithImpl(
      _$CrmStatisticsImpl _value, $Res Function(_$CrmStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCustomers = null,
    Object? hotProspects = null,
    Object? warmProspects = null,
    Object? coldProspects = null,
    Object? converted = null,
    Object? lost = null,
    Object? conversionRate = null,
    Object? totalInteractions = null,
  }) {
    return _then(_$CrmStatisticsImpl(
      totalCustomers: null == totalCustomers
          ? _value.totalCustomers
          : totalCustomers // ignore: cast_nullable_to_non_nullable
              as int,
      hotProspects: null == hotProspects
          ? _value.hotProspects
          : hotProspects // ignore: cast_nullable_to_non_nullable
              as int,
      warmProspects: null == warmProspects
          ? _value.warmProspects
          : warmProspects // ignore: cast_nullable_to_non_nullable
              as int,
      coldProspects: null == coldProspects
          ? _value.coldProspects
          : coldProspects // ignore: cast_nullable_to_non_nullable
              as int,
      converted: null == converted
          ? _value.converted
          : converted // ignore: cast_nullable_to_non_nullable
              as int,
      lost: null == lost
          ? _value.lost
          : lost // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
      totalInteractions: null == totalInteractions
          ? _value.totalInteractions
          : totalInteractions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CrmStatisticsImpl implements _CrmStatistics {
  const _$CrmStatisticsImpl(
      {@JsonKey(name: 'total_customers') required this.totalCustomers,
      @JsonKey(name: 'hot_prospects') required this.hotProspects,
      @JsonKey(name: 'warm_prospects') required this.warmProspects,
      @JsonKey(name: 'cold_prospects') required this.coldProspects,
      required this.converted,
      required this.lost,
      @JsonKey(name: 'conversion_rate') required this.conversionRate,
      @JsonKey(name: 'total_interactions') required this.totalInteractions});

  factory _$CrmStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrmStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_customers')
  final int totalCustomers;
  @override
  @JsonKey(name: 'hot_prospects')
  final int hotProspects;
  @override
  @JsonKey(name: 'warm_prospects')
  final int warmProspects;
  @override
  @JsonKey(name: 'cold_prospects')
  final int coldProspects;
  @override
  final int converted;
  @override
  final int lost;
  @override
  @JsonKey(name: 'conversion_rate')
  final double conversionRate;
  @override
  @JsonKey(name: 'total_interactions')
  final int totalInteractions;

  @override
  String toString() {
    return 'CrmStatistics(totalCustomers: $totalCustomers, hotProspects: $hotProspects, warmProspects: $warmProspects, coldProspects: $coldProspects, converted: $converted, lost: $lost, conversionRate: $conversionRate, totalInteractions: $totalInteractions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrmStatisticsImpl &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.hotProspects, hotProspects) ||
                other.hotProspects == hotProspects) &&
            (identical(other.warmProspects, warmProspects) ||
                other.warmProspects == warmProspects) &&
            (identical(other.coldProspects, coldProspects) ||
                other.coldProspects == coldProspects) &&
            (identical(other.converted, converted) ||
                other.converted == converted) &&
            (identical(other.lost, lost) || other.lost == lost) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate) &&
            (identical(other.totalInteractions, totalInteractions) ||
                other.totalInteractions == totalInteractions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalCustomers,
      hotProspects,
      warmProspects,
      coldProspects,
      converted,
      lost,
      conversionRate,
      totalInteractions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CrmStatisticsImplCopyWith<_$CrmStatisticsImpl> get copyWith =>
      __$$CrmStatisticsImplCopyWithImpl<_$CrmStatisticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CrmStatisticsImplToJson(
      this,
    );
  }
}

abstract class _CrmStatistics implements CrmStatistics {
  const factory _CrmStatistics(
      {@JsonKey(name: 'total_customers') required final int totalCustomers,
      @JsonKey(name: 'hot_prospects') required final int hotProspects,
      @JsonKey(name: 'warm_prospects') required final int warmProspects,
      @JsonKey(name: 'cold_prospects') required final int coldProspects,
      required final int converted,
      required final int lost,
      @JsonKey(name: 'conversion_rate') required final double conversionRate,
      @JsonKey(name: 'total_interactions')
      required final int totalInteractions}) = _$CrmStatisticsImpl;

  factory _CrmStatistics.fromJson(Map<String, dynamic> json) =
      _$CrmStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_customers')
  int get totalCustomers;
  @override
  @JsonKey(name: 'hot_prospects')
  int get hotProspects;
  @override
  @JsonKey(name: 'warm_prospects')
  int get warmProspects;
  @override
  @JsonKey(name: 'cold_prospects')
  int get coldProspects;
  @override
  int get converted;
  @override
  int get lost;
  @override
  @JsonKey(name: 'conversion_rate')
  double get conversionRate;
  @override
  @JsonKey(name: 'total_interactions')
  int get totalInteractions;
  @override
  @JsonKey(ignore: true)
  _$$CrmStatisticsImplCopyWith<_$CrmStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerDetail _$CustomerDetailFromJson(Map<String, dynamic> json) {
  return _CustomerDetail.fromJson(json);
}

/// @nodoc
mixin _$CustomerDetail {
  CrmCustomer get customer => throw _privateConstructorUsedError;
  List<CustomerInteraction> get interactions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerDetailCopyWith<CustomerDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerDetailCopyWith<$Res> {
  factory $CustomerDetailCopyWith(
          CustomerDetail value, $Res Function(CustomerDetail) then) =
      _$CustomerDetailCopyWithImpl<$Res, CustomerDetail>;
  @useResult
  $Res call({CrmCustomer customer, List<CustomerInteraction> interactions});

  $CrmCustomerCopyWith<$Res> get customer;
}

/// @nodoc
class _$CustomerDetailCopyWithImpl<$Res, $Val extends CustomerDetail>
    implements $CustomerDetailCopyWith<$Res> {
  _$CustomerDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? interactions = null,
  }) {
    return _then(_value.copyWith(
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CrmCustomer,
      interactions: null == interactions
          ? _value.interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as List<CustomerInteraction>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CrmCustomerCopyWith<$Res> get customer {
    return $CrmCustomerCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerDetailImplCopyWith<$Res>
    implements $CustomerDetailCopyWith<$Res> {
  factory _$$CustomerDetailImplCopyWith(_$CustomerDetailImpl value,
          $Res Function(_$CustomerDetailImpl) then) =
      __$$CustomerDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CrmCustomer customer, List<CustomerInteraction> interactions});

  @override
  $CrmCustomerCopyWith<$Res> get customer;
}

/// @nodoc
class __$$CustomerDetailImplCopyWithImpl<$Res>
    extends _$CustomerDetailCopyWithImpl<$Res, _$CustomerDetailImpl>
    implements _$$CustomerDetailImplCopyWith<$Res> {
  __$$CustomerDetailImplCopyWithImpl(
      _$CustomerDetailImpl _value, $Res Function(_$CustomerDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? interactions = null,
  }) {
    return _then(_$CustomerDetailImpl(
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CrmCustomer,
      interactions: null == interactions
          ? _value._interactions
          : interactions // ignore: cast_nullable_to_non_nullable
              as List<CustomerInteraction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerDetailImpl implements _CustomerDetail {
  const _$CustomerDetailImpl(
      {required this.customer,
      required final List<CustomerInteraction> interactions})
      : _interactions = interactions;

  factory _$CustomerDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerDetailImplFromJson(json);

  @override
  final CrmCustomer customer;
  final List<CustomerInteraction> _interactions;
  @override
  List<CustomerInteraction> get interactions {
    if (_interactions is EqualUnmodifiableListView) return _interactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interactions);
  }

  @override
  String toString() {
    return 'CustomerDetail(customer: $customer, interactions: $interactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerDetailImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            const DeepCollectionEquality()
                .equals(other._interactions, _interactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, customer,
      const DeepCollectionEquality().hash(_interactions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerDetailImplCopyWith<_$CustomerDetailImpl> get copyWith =>
      __$$CustomerDetailImplCopyWithImpl<_$CustomerDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerDetailImplToJson(
      this,
    );
  }
}

abstract class _CustomerDetail implements CustomerDetail {
  const factory _CustomerDetail(
          {required final CrmCustomer customer,
          required final List<CustomerInteraction> interactions}) =
      _$CustomerDetailImpl;

  factory _CustomerDetail.fromJson(Map<String, dynamic> json) =
      _$CustomerDetailImpl.fromJson;

  @override
  CrmCustomer get customer;
  @override
  List<CustomerInteraction> get interactions;
  @override
  @JsonKey(ignore: true)
  _$$CustomerDetailImplCopyWith<_$CustomerDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
