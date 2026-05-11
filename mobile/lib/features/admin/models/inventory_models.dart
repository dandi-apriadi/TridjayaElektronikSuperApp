import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_models.freezed.dart';
part 'inventory_models.g.dart';

@freezed
class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    required String name,
    required String category,
    required String sku,
    required String unit,
    @JsonKey(name: 'current_stock') required int currentStock,
    @JsonKey(name: 'minimum_stock') required int minimumStock,
    @JsonKey(name: 'maximum_stock') required int maximumStock,
    @JsonKey(name: 'price_per_unit') double? pricePerUnit,
    required String notes,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}

@freezed
class StockTransaction with _$StockTransaction {
  const factory StockTransaction({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'user_id') required String userId,
    required String type, // add, remove, adjustment
    required int quantity,
    @JsonKey(name: 'old_quantity') int? oldQuantity,
    @JsonKey(name: 'new_quantity') int? newQuantity,
    required String reason,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'photo_url') String? photoUrl,
    required String notes,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _StockTransaction;

  factory StockTransaction.fromJson(Map<String, dynamic> json) =>
      _$StockTransactionFromJson(json);
}

@freezed
class InventoryAlert with _$InventoryAlert {
  const factory InventoryAlert({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'alert_type') required String alertType, // low_stock, high_stock, out_of_stock
    @JsonKey(name: 'current_quantity') required int currentQuantity,
    required int threshold,
    required String severity,
    @JsonKey(name: 'is_resolved') required bool isResolved,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'resolved_at') String? resolvedAt,
  }) = _InventoryAlert;

  factory InventoryAlert.fromJson(Map<String, dynamic> json) =>
      _$InventoryAlertFromJson(json);
}

@freezed
class InventoryStats with _$InventoryStats {
  const factory InventoryStats({
    @JsonKey(name: 'total_items') required int totalItems,
    @JsonKey(name: 'total_stock_value') required double totalStockValue,
    @JsonKey(name: 'low_stock_items') required int lowStockItems,
    @JsonKey(name: 'out_of_stock_items') required int outOfStockItems,
    @JsonKey(name: 'alerts_count') required int alertsCount,
  }) = _InventoryStats;

  factory InventoryStats.fromJson(Map<String, dynamic> json) =>
      _$InventoryStatsFromJson(json);
}

@freezed
class AddStockRequest with _$AddStockRequest {
  const factory AddStockRequest({
    @JsonKey(name: 'item_id') required String itemId,
    required int quantity,
    required String reason,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'photo_url') String? photoUrl,
  }) = _AddStockRequest;

  factory AddStockRequest.fromJson(Map<String, dynamic> json) =>
      _$AddStockRequestFromJson(json);
}

@freezed
class RemoveStockRequest with _$RemoveStockRequest {
  const factory RemoveStockRequest({
    @JsonKey(name: 'item_id') required String itemId,
    required int quantity,
    required String reason,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'photo_url') String? photoUrl,
  }) = _RemoveStockRequest;

  factory RemoveStockRequest.fromJson(Map<String, dynamic> json) =>
      _$RemoveStockRequestFromJson(json);
}

@freezed
class InventoryResponse with _$InventoryResponse {
  const factory InventoryResponse({
    required bool success,
    required String message,
    Map<String, dynamic>? data,
  }) = _InventoryResponse;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryResponseFromJson(json);
}
