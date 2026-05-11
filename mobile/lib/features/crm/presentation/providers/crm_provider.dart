import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../models/crm_models.dart';

/// ============================================================
/// CRM PROVIDERS
/// ============================================================

// Customers Provider
final customersProvider = FutureProvider<List<CrmCustomer>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/crm/customers');
    return (response.data as List).map((e) => CrmCustomer.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat daftar pelanggan');
  }
});

// Customer Detail Provider
final customerDetailProvider = FutureProvider.family<CustomerDetail, String>((ref, customerId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/crm/customers/$customerId');
    return CustomerDetail.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat detail pelanggan');
  }
});

// Customer Interactions Provider
final customerInteractionsProvider = FutureProvider.family<List<CustomerInteraction>, String>((ref, customerId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/crm/interactions/$customerId');
    return (response.data as List).map((e) => CustomerInteraction.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat interaksi pelanggan');
  }
});

// CRM Statistics Provider
final crmStatisticsProvider = FutureProvider<CrmStatistics>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/crm/statistics');
    return CrmStatistics.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat statistik CRM');
  }
});

// ===================== MUTATION PROVIDERS =====================

// Create Customer Notifier
class CreateCustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  CreateCustomerNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
    String? source,
    String? interest,
    int? budget,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/crm/customers',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'address': address,
          'source': source,
          'interest': interest,
          'budget': budget,
          'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal membuat pelanggan',
        StackTrace.current,
      );
    }
  }
}

final createCustomerProvider = StateNotifierProvider<CreateCustomerNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return CreateCustomerNotifier(dio.dio);
});

// Update Customer Notifier
class UpdateCustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  UpdateCustomerNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> updateCustomer({
    required String customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? status,
    String? source,
    String? interest,
    int? budget,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.put(
        '/api/crm/customers/$customerId',
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email,
          if (address != null) 'address': address,
          if (status != null) 'status': status,
          if (source != null) 'source': source,
          if (interest != null) 'interest': interest,
          if (budget != null) 'budget': budget,
          if (notes != null) 'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal mengubah pelanggan',
        StackTrace.current,
      );
    }
  }
}

final updateCustomerProvider = StateNotifierProvider<UpdateCustomerNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UpdateCustomerNotifier(dio.dio);
});

// Create Interaction Notifier
class CreateInteractionNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  CreateInteractionNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> createInteraction({
    required String customerId,
    required String interactionType,
    required String notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/crm/customers/$customerId/interactions',
        data: {
          'interaction_type': interactionType,
          'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal membuat interaksi',
        StackTrace.current,
      );
    }
  }
}

final createInteractionProvider = StateNotifierProvider<CreateInteractionNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return CreateInteractionNotifier(dio.dio);
});

// Delete Customer Notifier
class DeleteCustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  DeleteCustomerNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> deleteCustomer(String customerId) async {
    state = const AsyncValue.loading();
    try {
      await dio.delete('/api/crm/customers/$customerId');
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal menghapus pelanggan',
        StackTrace.current,
      );
    }
  }
}

final deleteCustomerProvider = StateNotifierProvider<DeleteCustomerNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return DeleteCustomerNotifier(dio.dio);
});
