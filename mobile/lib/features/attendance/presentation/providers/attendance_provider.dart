import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/attendance_model.dart';

/// Provider untuk attendance history saya
final myAttendanceHistoryProvider = FutureProvider.family<List<Attendance>, Map<String, dynamic>?>((ref, filters) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (filters != null) {
      if (filters['status'] != null) queryParams['status'] = filters['status'];
      if (filters['start_date'] != null) queryParams['start_date'] = filters['start_date'];
      if (filters['end_date'] != null) queryParams['end_date'] = filters['end_date'];
    }
    
    final response = await dio.get('/api/attendance/my-history', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Attendance.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching attendance history: ${e.message}');
    throw Exception('Gagal mengambil riwayat absensi: ${e.message}');
  }
});

/// Provider untuk attendance summary
final attendanceSummaryProvider = FutureProvider<AttendanceSummary>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/attendance/summary');
    
    if (response.statusCode == 200) {
      return AttendanceSummary.fromJson(response.data);
    }
    throw Exception('Ringkasan tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching attendance summary: ${e.message}');
    throw Exception('Gagal mengambil ringkasan absensi: ${e.message}');
  }
});

/// Provider untuk today attendance (check-in status)
final todayAttendanceProvider = FutureProvider<Attendance?>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    // Fetch today's attendance from history with date filter
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final response = await dio.get(
      '/api/attendance/my-history',
      queryParameters: {
        'start_date': dateStr,
        'end_date': dateStr,
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      if (data.isNotEmpty) {
        return Attendance.fromJson(data.first);
      }
    }
    return null;
  } on DioException catch (e) {
    debugPrint('Error fetching today attendance: ${e.message}');
    return null;
  }
});

/// Notifier untuk check-in/check-out attendance
class AttendanceNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  
  AttendanceNotifier(this._dio) : super(const AsyncValue.data(null));
  
  Future<CheckInResponse> checkIn({
    required double latitude,
    required double longitude,
    String? photoUrl,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post('/api/attendance/check-in', data: {
        'latitude': latitude,
        'longitude': longitude,
        'photo_url': photoUrl,
        'notes': notes,
      });
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
        return CheckInResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal check-in');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 
                   e.response?.data['message'] ?? 
                   e.message ?? 
                   'Gagal check-in';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
  
  Future<CheckOutResponse> checkOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post('/api/attendance/check-out', data: {
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
      });
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
        return CheckOutResponse.fromJson(response.data);
      } else {
        throw Exception('Gagal check-out');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? 
                   e.response?.data['message'] ?? 
                   e.message ?? 
                   'Gagal check-out';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
}

/// Provider untuk attendance notifier
final attendanceNotifierProvider = StateNotifierProvider<AttendanceNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return AttendanceNotifier(dio);
});

/// Provider untuk loading state yang bisa di-refresh manual
final attendanceHistoryRefreshProvider = StateProvider<int>((ref) => 0);

/// Computed provider untuk attendance history yang bisa di-invalidate
final refreshableAttendanceHistoryProvider = FutureProvider.family<List<Attendance>, Map<String, dynamic>?>((ref, filters) async {
  // Trigger refresh ketika refreshProvider berubah
  ref.watch(attendanceHistoryRefreshProvider);
  
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (filters != null) {
      if (filters['status'] != null) queryParams['status'] = filters['status'];
      if (filters['start_date'] != null) queryParams['start_date'] = filters['start_date'];
      if (filters['end_date'] != null) queryParams['end_date'] = filters['end_date'];
    }
    
    final response = await dio.get('/api/attendance/my-history', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Attendance.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching attendance history: ${e.message}');
    throw Exception('Gagal mengambil riwayat absensi: ${e.message}');
  }
});
