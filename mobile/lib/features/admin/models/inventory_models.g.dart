// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      sku: json['sku'] as String,
      unit: json['unit'] as String,
      currentStock: (json['current_stock'] as num).toInt(),
      minimumStock: (json['minimum_stock'] as num).toInt(),
      maximumStock: (json['maximum_stock'] as num).toInt(),
      pricePerUnit: (json['price_per_unit'] as num?)?.toDouble(),
      notes: json['notes'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch_id': instance.branchId,
      'name': instance.name,
      'category': instance.category,
      'sku': instance.sku,
      'unit': instance.unit,
      'current_stock': instance.currentStock,
      'minimum_stock': instance.minimumStock,
      'maximum_stock': instance.maximumStock,
      'price_per_unit': instance.pricePerUnit,
      'notes': instance.notes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$StockTransactionImpl _$$StockTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$StockTransactionImpl(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      branchId: json['branch_id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      oldQuantity: (json['old_quantity'] as num?)?.toInt(),
      newQuantity: (json['new_quantity'] as num?)?.toInt(),
      reason: json['reason'] as String,
      referenceId: json['reference_id'] as String?,
      photoUrl: json['photo_url'] as String?,
      notes: json['notes'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$StockTransactionImplToJson(
        _$StockTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'branch_id': instance.branchId,
      'user_id': instance.userId,
      'type': instance.type,
      'quantity': instance.quantity,
      'old_quantity': instance.oldQuantity,
      'new_quantity': instance.newQuantity,
      'reason': instance.reason,
      'reference_id': instance.referenceId,
      'photo_url': instance.photoUrl,
      'notes': instance.notes,
      'created_at': instance.createdAt,
    };

_$InventoryAlertImpl _$$InventoryAlertImplFromJson(Map<String, dynamic> json) =>
    _$InventoryAlertImpl(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      branchId: json['branch_id'] as String,
      alertType: json['alert_type'] as String,
      currentQuantity: (json['current_quantity'] as num).toInt(),
      threshold: (json['threshold'] as num).toInt(),
      severity: json['severity'] as String,
      isResolved: json['is_resolved'] as bool,
      createdAt: json['created_at'] as String,
      resolvedAt: json['resolved_at'] as String?,
    );

Map<String, dynamic> _$$InventoryAlertImplToJson(
        _$InventoryAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'branch_id': instance.branchId,
      'alert_type': instance.alertType,
      'current_quantity': instance.currentQuantity,
      'threshold': instance.threshold,
      'severity': instance.severity,
      'is_resolved': instance.isResolved,
      'created_at': instance.createdAt,
      'resolved_at': instance.resolvedAt,
    };

_$InventoryStatsImpl _$$InventoryStatsImplFromJson(Map<String, dynamic> json) =>
    _$InventoryStatsImpl(
      totalItems: (json['total_items'] as num).toInt(),
      totalStockValue: (json['total_stock_value'] as num).toDouble(),
      lowStockItems: (json['low_stock_items'] as num).toInt(),
      outOfStockItems: (json['out_of_stock_items'] as num).toInt(),
      alertsCount: (json['alerts_count'] as num).toInt(),
    );

Map<String, dynamic> _$$InventoryStatsImplToJson(
        _$InventoryStatsImpl instance) =>
    <String, dynamic>{
      'total_items': instance.totalItems,
      'total_stock_value': instance.totalStockValue,
      'low_stock_items': instance.lowStockItems,
      'out_of_stock_items': instance.outOfStockItems,
      'alerts_count': instance.alertsCount,
    };

_$AddStockRequestImpl _$$AddStockRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AddStockRequestImpl(
      itemId: json['item_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      reason: json['reason'] as String,
      referenceId: json['reference_id'] as String?,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$$AddStockRequestImplToJson(
        _$AddStockRequestImpl instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'reference_id': instance.referenceId,
      'photo_url': instance.photoUrl,
    };

_$RemoveStockRequestImpl _$$RemoveStockRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RemoveStockRequestImpl(
      itemId: json['item_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      reason: json['reason'] as String,
      referenceId: json['reference_id'] as String?,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$$RemoveStockRequestImplToJson(
        _$RemoveStockRequestImpl instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'reference_id': instance.referenceId,
      'photo_url': instance.photoUrl,
    };

_$InventoryResponseImpl _$$InventoryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$InventoryResponseImplToJson(
        _$InventoryResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
