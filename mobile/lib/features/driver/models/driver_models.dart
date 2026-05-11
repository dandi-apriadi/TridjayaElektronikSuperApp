import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_models.freezed.dart';
part 'driver_models.g.dart';

/// ============================================================
/// DRIVER MODELS
/// ============================================================

@freezed
class DriverDashboardMetrics with _$DriverDashboardMetrics {
  const factory DriverDashboardMetrics({
    @JsonKey(name: 'pending_deliveries') required int pendingDeliveries,
    @JsonKey(name: 'in_progress_deliveries') required int inProgressDeliveries,
    @JsonKey(name: 'completed_deliveries') required int completedDeliveries,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'total_distance') required double totalDistance,
  }) = _DriverDashboardMetrics;

  factory DriverDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$DriverDashboardMetricsFromJson(json);
}

@freezed
class Delivery with _$Delivery {
  const factory Delivery({
    required String id,
    @JsonKey(name: 'driver_id') String? driverId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    required String address,
    double? latitude,
    double? longitude,
    required String status, // pending, in_progress, completed, failed
    @JsonKey(name: 'scheduled_time') String? scheduledTime,
    @JsonKey(name: 'completed_at') String? completedAt,
    String? notes,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);
}

@freezed
class RouteInfo with _$RouteInfo {
  const factory RouteInfo({
    @JsonKey(name: 'total_deliveries') required int totalDeliveries,
    @JsonKey(name: 'estimated_completion_time') required String estimatedCompletionTime,
    @JsonKey(name: 'total_distance') required double totalDistance,
    @JsonKey(name: 'current_location') required Map<String, double> currentLocation,
  }) = _RouteInfo;

  factory RouteInfo.fromJson(Map<String, dynamic> json) =>
      _$RouteInfoFromJson(json);
}
