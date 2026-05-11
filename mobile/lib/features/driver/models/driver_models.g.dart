// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverDashboardMetricsImpl _$$DriverDashboardMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$DriverDashboardMetricsImpl(
      pendingDeliveries: (json['pending_deliveries'] as num).toInt(),
      inProgressDeliveries: (json['in_progress_deliveries'] as num).toInt(),
      completedDeliveries: (json['completed_deliveries'] as num).toInt(),
      completionRate: (json['completion_rate'] as num).toDouble(),
      totalDistance: (json['total_distance'] as num).toDouble(),
    );

Map<String, dynamic> _$$DriverDashboardMetricsImplToJson(
        _$DriverDashboardMetricsImpl instance) =>
    <String, dynamic>{
      'pending_deliveries': instance.pendingDeliveries,
      'in_progress_deliveries': instance.inProgressDeliveries,
      'completed_deliveries': instance.completedDeliveries,
      'completion_rate': instance.completionRate,
      'total_distance': instance.totalDistance,
    };

_$DeliveryImpl _$$DeliveryImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryImpl(
      id: json['id'] as String,
      driverId: json['driver_id'] as String?,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String?,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String,
      scheduledTime: json['scheduled_time'] as String?,
      completedAt: json['completed_at'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$DeliveryImplToJson(_$DeliveryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver_id': instance.driverId,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'scheduled_time': instance.scheduledTime,
      'completed_at': instance.completedAt,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$RouteInfoImpl _$$RouteInfoImplFromJson(Map<String, dynamic> json) =>
    _$RouteInfoImpl(
      totalDeliveries: (json['total_deliveries'] as num).toInt(),
      estimatedCompletionTime: json['estimated_completion_time'] as String,
      totalDistance: (json['total_distance'] as num).toDouble(),
      currentLocation: (json['current_location'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$$RouteInfoImplToJson(_$RouteInfoImpl instance) =>
    <String, dynamic>{
      'total_deliveries': instance.totalDeliveries,
      'estimated_completion_time': instance.estimatedCompletionTime,
      'total_distance': instance.totalDistance,
      'current_location': instance.currentLocation,
    };
