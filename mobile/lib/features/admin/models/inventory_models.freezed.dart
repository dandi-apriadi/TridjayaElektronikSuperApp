// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) {
  return _InventoryItem.fromJson(json);
}

/// @nodoc
mixin _$InventoryItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stock')
  int get currentStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'minimum_stock')
  int get minimumStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'maximum_stock')
  int get maximumStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_per_unit')
  double? get pricePerUnit => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryItemCopyWith<InventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemCopyWith<$Res> {
  factory $InventoryItemCopyWith(
          InventoryItem value, $Res Function(InventoryItem) then) =
      _$InventoryItemCopyWithImpl<$Res, InventoryItem>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'branch_id') String branchId,
      String name,
      String category,
      String sku,
      String unit,
      @JsonKey(name: 'current_stock') int currentStock,
      @JsonKey(name: 'minimum_stock') int minimumStock,
      @JsonKey(name: 'maximum_stock') int maximumStock,
      @JsonKey(name: 'price_per_unit') double? pricePerUnit,
      String notes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$InventoryItemCopyWithImpl<$Res, $Val extends InventoryItem>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? name = null,
    Object? category = null,
    Object? sku = null,
    Object? unit = null,
    Object? currentStock = null,
    Object? minimumStock = null,
    Object? maximumStock = null,
    Object? pricePerUnit = freezed,
    Object? notes = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      minimumStock: null == minimumStock
          ? _value.minimumStock
          : minimumStock // ignore: cast_nullable_to_non_nullable
              as int,
      maximumStock: null == maximumStock
          ? _value.maximumStock
          : maximumStock // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerUnit: freezed == pricePerUnit
          ? _value.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$InventoryItemImplCopyWith<$Res>
    implements $InventoryItemCopyWith<$Res> {
  factory _$$InventoryItemImplCopyWith(
          _$InventoryItemImpl value, $Res Function(_$InventoryItemImpl) then) =
      __$$InventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'branch_id') String branchId,
      String name,
      String category,
      String sku,
      String unit,
      @JsonKey(name: 'current_stock') int currentStock,
      @JsonKey(name: 'minimum_stock') int minimumStock,
      @JsonKey(name: 'maximum_stock') int maximumStock,
      @JsonKey(name: 'price_per_unit') double? pricePerUnit,
      String notes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$InventoryItemImplCopyWithImpl<$Res>
    extends _$InventoryItemCopyWithImpl<$Res, _$InventoryItemImpl>
    implements _$$InventoryItemImplCopyWith<$Res> {
  __$$InventoryItemImplCopyWithImpl(
      _$InventoryItemImpl _value, $Res Function(_$InventoryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? branchId = null,
    Object? name = null,
    Object? category = null,
    Object? sku = null,
    Object? unit = null,
    Object? currentStock = null,
    Object? minimumStock = null,
    Object? maximumStock = null,
    Object? pricePerUnit = freezed,
    Object? notes = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InventoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as int,
      minimumStock: null == minimumStock
          ? _value.minimumStock
          : minimumStock // ignore: cast_nullable_to_non_nullable
              as int,
      maximumStock: null == maximumStock
          ? _value.maximumStock
          : maximumStock // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerUnit: freezed == pricePerUnit
          ? _value.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$InventoryItemImpl implements _InventoryItem {
  const _$InventoryItemImpl(
      {required this.id,
      @JsonKey(name: 'branch_id') required this.branchId,
      required this.name,
      required this.category,
      required this.sku,
      required this.unit,
      @JsonKey(name: 'current_stock') required this.currentStock,
      @JsonKey(name: 'minimum_stock') required this.minimumStock,
      @JsonKey(name: 'maximum_stock') required this.maximumStock,
      @JsonKey(name: 'price_per_unit') this.pricePerUnit,
      required this.notes,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$InventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  final String name;
  @override
  final String category;
  @override
  final String sku;
  @override
  final String unit;
  @override
  @JsonKey(name: 'current_stock')
  final int currentStock;
  @override
  @JsonKey(name: 'minimum_stock')
  final int minimumStock;
  @override
  @JsonKey(name: 'maximum_stock')
  final int maximumStock;
  @override
  @JsonKey(name: 'price_per_unit')
  final double? pricePerUnit;
  @override
  final String notes;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'InventoryItem(id: $id, branchId: $branchId, name: $name, category: $category, sku: $sku, unit: $unit, currentStock: $currentStock, minimumStock: $minimumStock, maximumStock: $maximumStock, pricePerUnit: $pricePerUnit, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.minimumStock, minimumStock) ||
                other.minimumStock == minimumStock) &&
            (identical(other.maximumStock, maximumStock) ||
                other.maximumStock == maximumStock) &&
            (identical(other.pricePerUnit, pricePerUnit) ||
                other.pricePerUnit == pricePerUnit) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      branchId,
      name,
      category,
      sku,
      unit,
      currentStock,
      minimumStock,
      maximumStock,
      pricePerUnit,
      notes,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemImplCopyWith<_$InventoryItemImpl> get copyWith =>
      __$$InventoryItemImplCopyWithImpl<_$InventoryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemImplToJson(
      this,
    );
  }
}

abstract class _InventoryItem implements InventoryItem {
  const factory _InventoryItem(
          {required final String id,
          @JsonKey(name: 'branch_id') required final String branchId,
          required final String name,
          required final String category,
          required final String sku,
          required final String unit,
          @JsonKey(name: 'current_stock') required final int currentStock,
          @JsonKey(name: 'minimum_stock') required final int minimumStock,
          @JsonKey(name: 'maximum_stock') required final int maximumStock,
          @JsonKey(name: 'price_per_unit') final double? pricePerUnit,
          required final String notes,
          @JsonKey(name: 'is_active') required final bool isActive,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$InventoryItemImpl;

  factory _InventoryItem.fromJson(Map<String, dynamic> json) =
      _$InventoryItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  String get name;
  @override
  String get category;
  @override
  String get sku;
  @override
  String get unit;
  @override
  @JsonKey(name: 'current_stock')
  int get currentStock;
  @override
  @JsonKey(name: 'minimum_stock')
  int get minimumStock;
  @override
  @JsonKey(name: 'maximum_stock')
  int get maximumStock;
  @override
  @JsonKey(name: 'price_per_unit')
  double? get pricePerUnit;
  @override
  String get notes;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$InventoryItemImplCopyWith<_$InventoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockTransaction _$StockTransactionFromJson(Map<String, dynamic> json) {
  return _StockTransaction.fromJson(json);
}

/// @nodoc
mixin _$StockTransaction {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // add, remove, adjustment
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_quantity')
  int? get oldQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_quantity')
  int? get newQuantity => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockTransactionCopyWith<StockTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockTransactionCopyWith<$Res> {
  factory $StockTransactionCopyWith(
          StockTransaction value, $Res Function(StockTransaction) then) =
      _$StockTransactionCopyWithImpl<$Res, StockTransaction>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'branch_id') String branchId,
      @JsonKey(name: 'user_id') String userId,
      String type,
      int quantity,
      @JsonKey(name: 'old_quantity') int? oldQuantity,
      @JsonKey(name: 'new_quantity') int? newQuantity,
      String reason,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'photo_url') String? photoUrl,
      String notes,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$StockTransactionCopyWithImpl<$Res, $Val extends StockTransaction>
    implements $StockTransactionCopyWith<$Res> {
  _$StockTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? branchId = null,
    Object? userId = null,
    Object? type = null,
    Object? quantity = null,
    Object? oldQuantity = freezed,
    Object? newQuantity = freezed,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? photoUrl = freezed,
    Object? notes = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      oldQuantity: freezed == oldQuantity
          ? _value.oldQuantity
          : oldQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      newQuantity: freezed == newQuantity
          ? _value.newQuantity
          : newQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$StockTransactionImplCopyWith<$Res>
    implements $StockTransactionCopyWith<$Res> {
  factory _$$StockTransactionImplCopyWith(_$StockTransactionImpl value,
          $Res Function(_$StockTransactionImpl) then) =
      __$$StockTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'branch_id') String branchId,
      @JsonKey(name: 'user_id') String userId,
      String type,
      int quantity,
      @JsonKey(name: 'old_quantity') int? oldQuantity,
      @JsonKey(name: 'new_quantity') int? newQuantity,
      String reason,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'photo_url') String? photoUrl,
      String notes,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$StockTransactionImplCopyWithImpl<$Res>
    extends _$StockTransactionCopyWithImpl<$Res, _$StockTransactionImpl>
    implements _$$StockTransactionImplCopyWith<$Res> {
  __$$StockTransactionImplCopyWithImpl(_$StockTransactionImpl _value,
      $Res Function(_$StockTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? branchId = null,
    Object? userId = null,
    Object? type = null,
    Object? quantity = null,
    Object? oldQuantity = freezed,
    Object? newQuantity = freezed,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? photoUrl = freezed,
    Object? notes = null,
    Object? createdAt = null,
  }) {
    return _then(_$StockTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      oldQuantity: freezed == oldQuantity
          ? _value.oldQuantity
          : oldQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      newQuantity: freezed == newQuantity
          ? _value.newQuantity
          : newQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$StockTransactionImpl implements _StockTransaction {
  const _$StockTransactionImpl(
      {required this.id,
      @JsonKey(name: 'item_id') required this.itemId,
      @JsonKey(name: 'branch_id') required this.branchId,
      @JsonKey(name: 'user_id') required this.userId,
      required this.type,
      required this.quantity,
      @JsonKey(name: 'old_quantity') this.oldQuantity,
      @JsonKey(name: 'new_quantity') this.newQuantity,
      required this.reason,
      @JsonKey(name: 'reference_id') this.referenceId,
      @JsonKey(name: 'photo_url') this.photoUrl,
      required this.notes,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$StockTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockTransactionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String type;
// add, remove, adjustment
  @override
  final int quantity;
  @override
  @JsonKey(name: 'old_quantity')
  final int? oldQuantity;
  @override
  @JsonKey(name: 'new_quantity')
  final int? newQuantity;
  @override
  final String reason;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  final String notes;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'StockTransaction(id: $id, itemId: $itemId, branchId: $branchId, userId: $userId, type: $type, quantity: $quantity, oldQuantity: $oldQuantity, newQuantity: $newQuantity, reason: $reason, referenceId: $referenceId, photoUrl: $photoUrl, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.oldQuantity, oldQuantity) ||
                other.oldQuantity == oldQuantity) &&
            (identical(other.newQuantity, newQuantity) ||
                other.newQuantity == newQuantity) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      itemId,
      branchId,
      userId,
      type,
      quantity,
      oldQuantity,
      newQuantity,
      reason,
      referenceId,
      photoUrl,
      notes,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockTransactionImplCopyWith<_$StockTransactionImpl> get copyWith =>
      __$$StockTransactionImplCopyWithImpl<_$StockTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockTransactionImplToJson(
      this,
    );
  }
}

abstract class _StockTransaction implements StockTransaction {
  const factory _StockTransaction(
          {required final String id,
          @JsonKey(name: 'item_id') required final String itemId,
          @JsonKey(name: 'branch_id') required final String branchId,
          @JsonKey(name: 'user_id') required final String userId,
          required final String type,
          required final int quantity,
          @JsonKey(name: 'old_quantity') final int? oldQuantity,
          @JsonKey(name: 'new_quantity') final int? newQuantity,
          required final String reason,
          @JsonKey(name: 'reference_id') final String? referenceId,
          @JsonKey(name: 'photo_url') final String? photoUrl,
          required final String notes,
          @JsonKey(name: 'created_at') required final String createdAt}) =
      _$StockTransactionImpl;

  factory _StockTransaction.fromJson(Map<String, dynamic> json) =
      _$StockTransactionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get type;
  @override // add, remove, adjustment
  int get quantity;
  @override
  @JsonKey(name: 'old_quantity')
  int? get oldQuantity;
  @override
  @JsonKey(name: 'new_quantity')
  int? get newQuantity;
  @override
  String get reason;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  String get notes;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$StockTransactionImplCopyWith<_$StockTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryAlert _$InventoryAlertFromJson(Map<String, dynamic> json) {
  return _InventoryAlert.fromJson(json);
}

/// @nodoc
mixin _$InventoryAlert {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'alert_type')
  String get alertType =>
      throw _privateConstructorUsedError; // low_stock, high_stock, out_of_stock
  @JsonKey(name: 'current_quantity')
  int get currentQuantity => throw _privateConstructorUsedError;
  int get threshold => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_resolved')
  bool get isResolved => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolved_at')
  String? get resolvedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryAlertCopyWith<InventoryAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryAlertCopyWith<$Res> {
  factory $InventoryAlertCopyWith(
          InventoryAlert value, $Res Function(InventoryAlert) then) =
      _$InventoryAlertCopyWithImpl<$Res, InventoryAlert>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'branch_id') String branchId,
      @JsonKey(name: 'alert_type') String alertType,
      @JsonKey(name: 'current_quantity') int currentQuantity,
      int threshold,
      String severity,
      @JsonKey(name: 'is_resolved') bool isResolved,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'resolved_at') String? resolvedAt});
}

/// @nodoc
class _$InventoryAlertCopyWithImpl<$Res, $Val extends InventoryAlert>
    implements $InventoryAlertCopyWith<$Res> {
  _$InventoryAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? branchId = null,
    Object? alertType = null,
    Object? currentQuantity = null,
    Object? threshold = null,
    Object? severity = null,
    Object? isResolved = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      threshold: null == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryAlertImplCopyWith<$Res>
    implements $InventoryAlertCopyWith<$Res> {
  factory _$$InventoryAlertImplCopyWith(_$InventoryAlertImpl value,
          $Res Function(_$InventoryAlertImpl) then) =
      __$$InventoryAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'item_id') String itemId,
      @JsonKey(name: 'branch_id') String branchId,
      @JsonKey(name: 'alert_type') String alertType,
      @JsonKey(name: 'current_quantity') int currentQuantity,
      int threshold,
      String severity,
      @JsonKey(name: 'is_resolved') bool isResolved,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'resolved_at') String? resolvedAt});
}

/// @nodoc
class __$$InventoryAlertImplCopyWithImpl<$Res>
    extends _$InventoryAlertCopyWithImpl<$Res, _$InventoryAlertImpl>
    implements _$$InventoryAlertImplCopyWith<$Res> {
  __$$InventoryAlertImplCopyWithImpl(
      _$InventoryAlertImpl _value, $Res Function(_$InventoryAlertImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? branchId = null,
    Object? alertType = null,
    Object? currentQuantity = null,
    Object? threshold = null,
    Object? severity = null,
    Object? isResolved = null,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(_$InventoryAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      branchId: null == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as String,
      alertType: null == alertType
          ? _value.alertType
          : alertType // ignore: cast_nullable_to_non_nullable
              as String,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      threshold: null == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryAlertImpl implements _InventoryAlert {
  const _$InventoryAlertImpl(
      {required this.id,
      @JsonKey(name: 'item_id') required this.itemId,
      @JsonKey(name: 'branch_id') required this.branchId,
      @JsonKey(name: 'alert_type') required this.alertType,
      @JsonKey(name: 'current_quantity') required this.currentQuantity,
      required this.threshold,
      required this.severity,
      @JsonKey(name: 'is_resolved') required this.isResolved,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'resolved_at') this.resolvedAt});

  factory _$InventoryAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryAlertImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'alert_type')
  final String alertType;
// low_stock, high_stock, out_of_stock
  @override
  @JsonKey(name: 'current_quantity')
  final int currentQuantity;
  @override
  final int threshold;
  @override
  final String severity;
  @override
  @JsonKey(name: 'is_resolved')
  final bool isResolved;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'resolved_at')
  final String? resolvedAt;

  @override
  String toString() {
    return 'InventoryAlert(id: $id, itemId: $itemId, branchId: $branchId, alertType: $alertType, currentQuantity: $currentQuantity, threshold: $threshold, severity: $severity, isResolved: $isResolved, createdAt: $createdAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.alertType, alertType) ||
                other.alertType == alertType) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, itemId, branchId, alertType,
      currentQuantity, threshold, severity, isResolved, createdAt, resolvedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryAlertImplCopyWith<_$InventoryAlertImpl> get copyWith =>
      __$$InventoryAlertImplCopyWithImpl<_$InventoryAlertImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryAlertImplToJson(
      this,
    );
  }
}

abstract class _InventoryAlert implements InventoryAlert {
  const factory _InventoryAlert(
          {required final String id,
          @JsonKey(name: 'item_id') required final String itemId,
          @JsonKey(name: 'branch_id') required final String branchId,
          @JsonKey(name: 'alert_type') required final String alertType,
          @JsonKey(name: 'current_quantity') required final int currentQuantity,
          required final int threshold,
          required final String severity,
          @JsonKey(name: 'is_resolved') required final bool isResolved,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'resolved_at') final String? resolvedAt}) =
      _$InventoryAlertImpl;

  factory _InventoryAlert.fromJson(Map<String, dynamic> json) =
      _$InventoryAlertImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'alert_type')
  String get alertType;
  @override // low_stock, high_stock, out_of_stock
  @JsonKey(name: 'current_quantity')
  int get currentQuantity;
  @override
  int get threshold;
  @override
  String get severity;
  @override
  @JsonKey(name: 'is_resolved')
  bool get isResolved;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'resolved_at')
  String? get resolvedAt;
  @override
  @JsonKey(ignore: true)
  _$$InventoryAlertImplCopyWith<_$InventoryAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryStats _$InventoryStatsFromJson(Map<String, dynamic> json) {
  return _InventoryStats.fromJson(json);
}

/// @nodoc
mixin _$InventoryStats {
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_stock_value')
  double get totalStockValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'low_stock_items')
  int get lowStockItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_of_stock_items')
  int get outOfStockItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'alerts_count')
  int get alertsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryStatsCopyWith<InventoryStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStatsCopyWith<$Res> {
  factory $InventoryStatsCopyWith(
          InventoryStats value, $Res Function(InventoryStats) then) =
      _$InventoryStatsCopyWithImpl<$Res, InventoryStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_stock_value') double totalStockValue,
      @JsonKey(name: 'low_stock_items') int lowStockItems,
      @JsonKey(name: 'out_of_stock_items') int outOfStockItems,
      @JsonKey(name: 'alerts_count') int alertsCount});
}

/// @nodoc
class _$InventoryStatsCopyWithImpl<$Res, $Val extends InventoryStats>
    implements $InventoryStatsCopyWith<$Res> {
  _$InventoryStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? totalStockValue = null,
    Object? lowStockItems = null,
    Object? outOfStockItems = null,
    Object? alertsCount = null,
  }) {
    return _then(_value.copyWith(
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalStockValue: null == totalStockValue
          ? _value.totalStockValue
          : totalStockValue // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockItems: null == lowStockItems
          ? _value.lowStockItems
          : lowStockItems // ignore: cast_nullable_to_non_nullable
              as int,
      outOfStockItems: null == outOfStockItems
          ? _value.outOfStockItems
          : outOfStockItems // ignore: cast_nullable_to_non_nullable
              as int,
      alertsCount: null == alertsCount
          ? _value.alertsCount
          : alertsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryStatsImplCopyWith<$Res>
    implements $InventoryStatsCopyWith<$Res> {
  factory _$$InventoryStatsImplCopyWith(_$InventoryStatsImpl value,
          $Res Function(_$InventoryStatsImpl) then) =
      __$$InventoryStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_stock_value') double totalStockValue,
      @JsonKey(name: 'low_stock_items') int lowStockItems,
      @JsonKey(name: 'out_of_stock_items') int outOfStockItems,
      @JsonKey(name: 'alerts_count') int alertsCount});
}

/// @nodoc
class __$$InventoryStatsImplCopyWithImpl<$Res>
    extends _$InventoryStatsCopyWithImpl<$Res, _$InventoryStatsImpl>
    implements _$$InventoryStatsImplCopyWith<$Res> {
  __$$InventoryStatsImplCopyWithImpl(
      _$InventoryStatsImpl _value, $Res Function(_$InventoryStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? totalStockValue = null,
    Object? lowStockItems = null,
    Object? outOfStockItems = null,
    Object? alertsCount = null,
  }) {
    return _then(_$InventoryStatsImpl(
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalStockValue: null == totalStockValue
          ? _value.totalStockValue
          : totalStockValue // ignore: cast_nullable_to_non_nullable
              as double,
      lowStockItems: null == lowStockItems
          ? _value.lowStockItems
          : lowStockItems // ignore: cast_nullable_to_non_nullable
              as int,
      outOfStockItems: null == outOfStockItems
          ? _value.outOfStockItems
          : outOfStockItems // ignore: cast_nullable_to_non_nullable
              as int,
      alertsCount: null == alertsCount
          ? _value.alertsCount
          : alertsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryStatsImpl implements _InventoryStats {
  const _$InventoryStatsImpl(
      {@JsonKey(name: 'total_items') required this.totalItems,
      @JsonKey(name: 'total_stock_value') required this.totalStockValue,
      @JsonKey(name: 'low_stock_items') required this.lowStockItems,
      @JsonKey(name: 'out_of_stock_items') required this.outOfStockItems,
      @JsonKey(name: 'alerts_count') required this.alertsCount});

  factory _$InventoryStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_items')
  final int totalItems;
  @override
  @JsonKey(name: 'total_stock_value')
  final double totalStockValue;
  @override
  @JsonKey(name: 'low_stock_items')
  final int lowStockItems;
  @override
  @JsonKey(name: 'out_of_stock_items')
  final int outOfStockItems;
  @override
  @JsonKey(name: 'alerts_count')
  final int alertsCount;

  @override
  String toString() {
    return 'InventoryStats(totalItems: $totalItems, totalStockValue: $totalStockValue, lowStockItems: $lowStockItems, outOfStockItems: $outOfStockItems, alertsCount: $alertsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStatsImpl &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalStockValue, totalStockValue) ||
                other.totalStockValue == totalStockValue) &&
            (identical(other.lowStockItems, lowStockItems) ||
                other.lowStockItems == lowStockItems) &&
            (identical(other.outOfStockItems, outOfStockItems) ||
                other.outOfStockItems == outOfStockItems) &&
            (identical(other.alertsCount, alertsCount) ||
                other.alertsCount == alertsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalItems, totalStockValue,
      lowStockItems, outOfStockItems, alertsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStatsImplCopyWith<_$InventoryStatsImpl> get copyWith =>
      __$$InventoryStatsImplCopyWithImpl<_$InventoryStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryStatsImplToJson(
      this,
    );
  }
}

abstract class _InventoryStats implements InventoryStats {
  const factory _InventoryStats(
      {@JsonKey(name: 'total_items') required final int totalItems,
      @JsonKey(name: 'total_stock_value') required final double totalStockValue,
      @JsonKey(name: 'low_stock_items') required final int lowStockItems,
      @JsonKey(name: 'out_of_stock_items') required final int outOfStockItems,
      @JsonKey(name: 'alerts_count')
      required final int alertsCount}) = _$InventoryStatsImpl;

  factory _InventoryStats.fromJson(Map<String, dynamic> json) =
      _$InventoryStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(name: 'total_stock_value')
  double get totalStockValue;
  @override
  @JsonKey(name: 'low_stock_items')
  int get lowStockItems;
  @override
  @JsonKey(name: 'out_of_stock_items')
  int get outOfStockItems;
  @override
  @JsonKey(name: 'alerts_count')
  int get alertsCount;
  @override
  @JsonKey(ignore: true)
  _$$InventoryStatsImplCopyWith<_$InventoryStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddStockRequest _$AddStockRequestFromJson(Map<String, dynamic> json) {
  return _AddStockRequest.fromJson(json);
}

/// @nodoc
mixin _$AddStockRequest {
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddStockRequestCopyWith<AddStockRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddStockRequestCopyWith<$Res> {
  factory $AddStockRequestCopyWith(
          AddStockRequest value, $Res Function(AddStockRequest) then) =
      _$AddStockRequestCopyWithImpl<$Res, AddStockRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      int quantity,
      String reason,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'photo_url') String? photoUrl});
}

/// @nodoc
class _$AddStockRequestCopyWithImpl<$Res, $Val extends AddStockRequest>
    implements $AddStockRequestCopyWith<$Res> {
  _$AddStockRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? quantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddStockRequestImplCopyWith<$Res>
    implements $AddStockRequestCopyWith<$Res> {
  factory _$$AddStockRequestImplCopyWith(_$AddStockRequestImpl value,
          $Res Function(_$AddStockRequestImpl) then) =
      __$$AddStockRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      int quantity,
      String reason,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'photo_url') String? photoUrl});
}

/// @nodoc
class __$$AddStockRequestImplCopyWithImpl<$Res>
    extends _$AddStockRequestCopyWithImpl<$Res, _$AddStockRequestImpl>
    implements _$$AddStockRequestImplCopyWith<$Res> {
  __$$AddStockRequestImplCopyWithImpl(
      _$AddStockRequestImpl _value, $Res Function(_$AddStockRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? quantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_$AddStockRequestImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddStockRequestImpl implements _AddStockRequest {
  const _$AddStockRequestImpl(
      {@JsonKey(name: 'item_id') required this.itemId,
      required this.quantity,
      required this.reason,
      @JsonKey(name: 'reference_id') this.referenceId,
      @JsonKey(name: 'photo_url') this.photoUrl});

  factory _$AddStockRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddStockRequestImplFromJson(json);

  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  final int quantity;
  @override
  final String reason;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  @override
  String toString() {
    return 'AddStockRequest(itemId: $itemId, quantity: $quantity, reason: $reason, referenceId: $referenceId, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddStockRequestImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, itemId, quantity, reason, referenceId, photoUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddStockRequestImplCopyWith<_$AddStockRequestImpl> get copyWith =>
      __$$AddStockRequestImplCopyWithImpl<_$AddStockRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddStockRequestImplToJson(
      this,
    );
  }
}

abstract class _AddStockRequest implements AddStockRequest {
  const factory _AddStockRequest(
          {@JsonKey(name: 'item_id') required final String itemId,
          required final int quantity,
          required final String reason,
          @JsonKey(name: 'reference_id') final String? referenceId,
          @JsonKey(name: 'photo_url') final String? photoUrl}) =
      _$AddStockRequestImpl;

  factory _AddStockRequest.fromJson(Map<String, dynamic> json) =
      _$AddStockRequestImpl.fromJson;

  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  int get quantity;
  @override
  String get reason;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(ignore: true)
  _$$AddStockRequestImplCopyWith<_$AddStockRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RemoveStockRequest _$RemoveStockRequestFromJson(Map<String, dynamic> json) {
  return _RemoveStockRequest.fromJson(json);
}

/// @nodoc
mixin _$RemoveStockRequest {
  @JsonKey(name: 'item_id')
  String get itemId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RemoveStockRequestCopyWith<RemoveStockRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoveStockRequestCopyWith<$Res> {
  factory $RemoveStockRequestCopyWith(
          RemoveStockRequest value, $Res Function(RemoveStockRequest) then) =
      _$RemoveStockRequestCopyWithImpl<$Res, RemoveStockRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      int quantity,
      String reason,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'photo_url') String? photoUrl});
}

/// @nodoc
class _$RemoveStockRequestCopyWithImpl<$Res, $Val extends RemoveStockRequest>
    implements $RemoveStockRequestCopyWith<$Res> {
  _$RemoveStockRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? quantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoveStockRequestImplCopyWith<$Res>
    implements $RemoveStockRequestCopyWith<$Res> {
  factory _$$RemoveStockRequestImplCopyWith(_$RemoveStockRequestImpl value,
          $Res Function(_$RemoveStockRequestImpl) then) =
      __$$RemoveStockRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'item_id') String itemId,
      int quantity,
      String reason,
      @JsonKey(name: 'reference_id') String? referenceId,
      @JsonKey(name: 'photo_url') String? photoUrl});
}

/// @nodoc
class __$$RemoveStockRequestImplCopyWithImpl<$Res>
    extends _$RemoveStockRequestCopyWithImpl<$Res, _$RemoveStockRequestImpl>
    implements _$$RemoveStockRequestImplCopyWith<$Res> {
  __$$RemoveStockRequestImplCopyWithImpl(_$RemoveStockRequestImpl _value,
      $Res Function(_$RemoveStockRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? quantity = null,
    Object? reason = null,
    Object? referenceId = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(_$RemoveStockRequestImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoveStockRequestImpl implements _RemoveStockRequest {
  const _$RemoveStockRequestImpl(
      {@JsonKey(name: 'item_id') required this.itemId,
      required this.quantity,
      required this.reason,
      @JsonKey(name: 'reference_id') this.referenceId,
      @JsonKey(name: 'photo_url') this.photoUrl});

  factory _$RemoveStockRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoveStockRequestImplFromJson(json);

  @override
  @JsonKey(name: 'item_id')
  final String itemId;
  @override
  final int quantity;
  @override
  final String reason;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  @override
  String toString() {
    return 'RemoveStockRequest(itemId: $itemId, quantity: $quantity, reason: $reason, referenceId: $referenceId, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveStockRequestImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, itemId, quantity, reason, referenceId, photoUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveStockRequestImplCopyWith<_$RemoveStockRequestImpl> get copyWith =>
      __$$RemoveStockRequestImplCopyWithImpl<_$RemoveStockRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoveStockRequestImplToJson(
      this,
    );
  }
}

abstract class _RemoveStockRequest implements RemoveStockRequest {
  const factory _RemoveStockRequest(
          {@JsonKey(name: 'item_id') required final String itemId,
          required final int quantity,
          required final String reason,
          @JsonKey(name: 'reference_id') final String? referenceId,
          @JsonKey(name: 'photo_url') final String? photoUrl}) =
      _$RemoveStockRequestImpl;

  factory _RemoveStockRequest.fromJson(Map<String, dynamic> json) =
      _$RemoveStockRequestImpl.fromJson;

  @override
  @JsonKey(name: 'item_id')
  String get itemId;
  @override
  int get quantity;
  @override
  String get reason;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(ignore: true)
  _$$RemoveStockRequestImplCopyWith<_$RemoveStockRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryResponse _$InventoryResponseFromJson(Map<String, dynamic> json) {
  return _InventoryResponse.fromJson(json);
}

/// @nodoc
mixin _$InventoryResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryResponseCopyWith<InventoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryResponseCopyWith<$Res> {
  factory $InventoryResponseCopyWith(
          InventoryResponse value, $Res Function(InventoryResponse) then) =
      _$InventoryResponseCopyWithImpl<$Res, InventoryResponse>;
  @useResult
  $Res call({bool success, String message, Map<String, dynamic>? data});
}

/// @nodoc
class _$InventoryResponseCopyWithImpl<$Res, $Val extends InventoryResponse>
    implements $InventoryResponseCopyWith<$Res> {
  _$InventoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryResponseImplCopyWith<$Res>
    implements $InventoryResponseCopyWith<$Res> {
  factory _$$InventoryResponseImplCopyWith(_$InventoryResponseImpl value,
          $Res Function(_$InventoryResponseImpl) then) =
      __$$InventoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, Map<String, dynamic>? data});
}

/// @nodoc
class __$$InventoryResponseImplCopyWithImpl<$Res>
    extends _$InventoryResponseCopyWithImpl<$Res, _$InventoryResponseImpl>
    implements _$$InventoryResponseImplCopyWith<$Res> {
  __$$InventoryResponseImplCopyWithImpl(_$InventoryResponseImpl _value,
      $Res Function(_$InventoryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_$InventoryResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryResponseImpl implements _InventoryResponse {
  const _$InventoryResponseImpl(
      {required this.success,
      required this.message,
      final Map<String, dynamic>? data})
      : _data = data;

  factory _$InventoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'InventoryResponse(success: $success, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, message,
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryResponseImplCopyWith<_$InventoryResponseImpl> get copyWith =>
      __$$InventoryResponseImplCopyWithImpl<_$InventoryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryResponseImplToJson(
      this,
    );
  }
}

abstract class _InventoryResponse implements InventoryResponse {
  const factory _InventoryResponse(
      {required final bool success,
      required final String message,
      final Map<String, dynamic>? data}) = _$InventoryResponseImpl;

  factory _InventoryResponse.fromJson(Map<String, dynamic> json) =
      _$InventoryResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$$InventoryResponseImplCopyWith<_$InventoryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
