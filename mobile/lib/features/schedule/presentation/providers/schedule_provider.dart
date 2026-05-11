import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../models/schedule_models.dart';

/// ============================================================
/// SCHEDULE PROVIDERS
/// ============================================================

// My Schedule Provider
final myScheduleProvider = FutureProvider<List<Shift>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/schedule/my-schedule');
    return (response.data as List).map((e) => Shift.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat jadwal saya');
  }
});

// Team Schedule Provider
final teamScheduleProvider = FutureProvider<TeamSchedule>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/schedule/team-schedule');
    return TeamSchedule.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat jadwal tim');
  }
});

// Shift Detail Provider
final shiftDetailProvider = FutureProvider.family<Shift, String>((ref, shiftId) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/schedule/shifts/$shiftId');
    return Shift.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat detail shift');
  }
});

// Schedule Statistics Provider
final scheduleStatisticsProvider = FutureProvider<ScheduleStatistics>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/schedule/statistics');
    return ScheduleStatistics.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat statistik jadwal');
  }
});

// ===================== MUTATION PROVIDERS =====================

// Create Shift Notifier
class CreateShiftNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  CreateShiftNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> createShift({
    required String title,
    required String shiftType,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/schedule/shifts',
        data: {
          'title': title,
          'shift_type': shiftType,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
          'location': location,
          'notes': notes,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal membuat shift',
        StackTrace.current,
      );
    }
  }
}

final createShiftProvider = StateNotifierProvider<CreateShiftNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return CreateShiftNotifier(dio.dio);
});

// Update Shift Notifier
class UpdateShiftNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  UpdateShiftNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> updateShift({
    required String shiftId,
    String? title,
    String? shiftType,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? notes,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.put(
        '/api/schedule/shifts/$shiftId',
        data: {
          if (title != null) 'title': title,
          if (shiftType != null) 'shift_type': shiftType,
          if (startTime != null) 'start_time': startTime.toIso8601String(),
          if (endTime != null) 'end_time': endTime.toIso8601String(),
          if (location != null) 'location': location,
          if (notes != null) 'notes': notes,
          if (status != null) 'status': status,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal mengubah shift',
        StackTrace.current,
      );
    }
  }
}

final updateShiftProvider = StateNotifierProvider<UpdateShiftNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return UpdateShiftNotifier(dio.dio);
});

// Delete Shift Notifier
class DeleteShiftNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  DeleteShiftNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> deleteShift(String shiftId) async {
    state = const AsyncValue.loading();
    try {
      await dio.delete('/api/schedule/shifts/$shiftId');
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal menghapus shift',
        StackTrace.current,
      );
    }
  }
}

final deleteShiftProvider = StateNotifierProvider<DeleteShiftNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return DeleteShiftNotifier(dio.dio);
});

// Assign Shift Notifier
class AssignShiftNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  AssignShiftNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> assignShift({
    required String shiftId,
    required String userId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/schedule/shifts/$shiftId/assign',
        data: {
          'user_id': userId,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal mengassign shift',
        StackTrace.current,
      );
    }
  }
}

final assignShiftProvider = StateNotifierProvider<AssignShiftNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AssignShiftNotifier(dio.dio);
});
