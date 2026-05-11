import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../models/sales_models.dart';

/// ============================================================
/// SALES PROVIDERS
/// ============================================================

// Sales Dashboard Provider
final salesDashboardProvider = FutureProvider<SalesDashboardMetrics>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/sales/dashboard');
    return SalesDashboardMetrics.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat dashboard penjualan');
  }
});

// Prospects Provider
final prospectsProvider = FutureProvider<List<Prospect>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/sales/prospects');
    return (response.data as List).map((e) => Prospect.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat daftar prospek');
  }
});

// Prospect Detail Provider
final prospectDetailProvider = FutureProvider.family<Prospect, String>((ref, prospectId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/sales/prospects/$prospectId');
    return Prospect.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat detail prospek');
  }
});

// Campaigns Provider
final campaignsProvider = FutureProvider<List<Campaign>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/sales/campaigns');
    return (response.data as List).map((e) => Campaign.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat kampanye');
  }
});

// Sales Report Provider
final salesReportProvider = FutureProvider<SalesReport>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/sales/reports');
    return SalesReport.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat laporan penjualan');
  }
});

// ===================== MUTATION PROVIDERS =====================

// Create Prospect Notifier
class CreateProspectNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  CreateProspectNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> createProspect({
    required String name,
    required String phone,
    String? email,
    String? address,
    String? source,
    String? productInterest,
    int? budget,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/sales/prospects',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'address': address,
          'source': source,
          'product_interest': productInterest,
          'budget': budget,
          'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal membuat prospek',
        StackTrace.current,
      );
    }
  }
}

final createProspectProvider = StateNotifierProvider<CreateProspectNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return CreateProspectNotifier(dio.dio);
});

// Update Prospect Notifier
class UpdateProspectNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  UpdateProspectNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> updateProspect({
    required String prospectId,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? status,
    String? source,
    String? productInterest,
    int? budget,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.put(
        '/api/sales/prospects/$prospectId',
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email,
          if (address != null) 'address': address,
          if (status != null) 'status': status,
          if (source != null) 'source': source,
          if (productInterest != null) 'product_interest': productInterest,
          if (budget != null) 'budget': budget,
          if (notes != null) 'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal mengubah prospek',
        StackTrace.current,
      );
    }
  }
}

final updateProspectProvider = StateNotifierProvider<UpdateProspectNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UpdateProspectNotifier(dio.dio);
});

// Delete Prospect Notifier
class DeleteProspectNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  DeleteProspectNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> deleteProspect(String prospectId) async {
    state = const AsyncValue.loading();
    try {
      await dio.delete('/api/sales/prospects/$prospectId');
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal menghapus prospek',
        StackTrace.current,
      );
    }
  }
}

final deleteProspectProvider = StateNotifierProvider<DeleteProspectNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return DeleteProspectNotifier(dio.dio);
});
