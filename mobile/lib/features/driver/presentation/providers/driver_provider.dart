import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../models/driver_models.dart';

/// ============================================================
/// DRIVER PROVIDERS
/// ============================================================

// Driver Dashboard Provider
final driverDashboardProvider = FutureProvider<DriverDashboardMetrics>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/driver/dashboard');
    return DriverDashboardMetrics.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat dashboard driver');
  }
});

// Deliveries Provider
final deliveriesProvider = FutureProvider<List<Delivery>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/driver/deliveries');
    return (response.data as List).map((e) => Delivery.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat daftar pengiriman');
  }
});

// Delivery Detail Provider
final deliveryDetailProvider = FutureProvider.family<Delivery, String>((ref, deliveryId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/driver/deliveries/$deliveryId');
    return Delivery.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat detail pengiriman');
  }
});

// Route Info Provider
final routeInfoProvider = FutureProvider<RouteInfo>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/driver/route');
    return RouteInfo.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat informasi rute');
  }
});

// ===================== MUTATION PROVIDERS =====================

// Update Delivery Notifier
class UpdateDeliveryNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  UpdateDeliveryNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> updateDelivery({
    required String deliveryId,
    String? status,
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.put(
        '/api/driver/deliveries/$deliveryId',
        data: {
          if (status != null) 'status': status,
          if (notes != null) 'notes': notes,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal mengubah pengiriman',
        StackTrace.current,
      );
    }
  }
}

final updateDeliveryProvider = StateNotifierProvider<UpdateDeliveryNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UpdateDeliveryNotifier(dio.dio);
});

// Complete Delivery Notifier
class CompleteDeliveryNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  CompleteDeliveryNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> completeDelivery({
    required String deliveryId,
    double? latitude,
    double? longitude,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/driver/deliveries/$deliveryId/complete',
        data: {
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (notes != null) 'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal menyelesaikan pengiriman',
        StackTrace.current,
      );
    }
  }
}

final completeDeliveryProvider = StateNotifierProvider<CompleteDeliveryNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return CompleteDeliveryNotifier(dio.dio);
});
