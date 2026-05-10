import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/kepala_cabang_models.dart';

/// Provider untuk Branch Dashboard
final branchDashboardProvider = FutureProvider<BranchDashboard>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/kepala-cabang/dashboard');
    
    if (response.statusCode == 200) {
      return BranchDashboard.fromJson(response.data);
    }
    throw Exception('Dashboard tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching branch dashboard: ${e.message}');
    throw Exception('Gagal mengambil data dashboard: ${e.message}');
  }
});

/// Provider untuk Branch Employees
final branchEmployeesProvider = FutureProvider<List<EmployeeSummary>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/kepala-cabang/employees');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => EmployeeSummary.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching branch employees: ${e.message}');
    throw Exception('Gagal mengambil data karyawan: ${e.message}');
  }
});

/// Provider untuk Pending Jobdesk Review
final pendingJobdeskReviewProvider = FutureProvider<List<JobDeskReviewItem>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/kepala-cabang/jobdesk/pending');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => JobDeskReviewItem.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching pending jobdesk: ${e.message}');
    throw Exception('Gagal mengambil data jobdesk pending: ${e.message}');
  }
});

/// Provider untuk Pending Work Reports
final pendingWorkReportsProvider = FutureProvider<List<WorkReportReviewItem>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/kepala-cabang/work-reports/pending');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => WorkReportReviewItem.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching pending work reports: ${e.message}');
    throw Exception('Gagal mengambil data laporan pending: ${e.message}');
  }
});

/// Provider untuk Attendance Summary
final attendanceSummaryProvider = FutureProvider.family<List<AttendanceSummary>, Map<String, dynamic>?>((ref, params) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (params != null) {
      if (params['start_date'] != null) queryParams['start_date'] = params['start_date'];
      if (params['end_date'] != null) queryParams['end_date'] = params['end_date'];
    }
    
    final response = await dio.get('/api/kepala-cabang/attendance', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => AttendanceSummary.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching attendance summary: ${e.message}');
    throw Exception('Gagal mengambil data kehadiran: ${e.message}');
  }
});

/// Notifier untuk Approve/Reject Jobdesk
class JobdeskReviewActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  
  JobdeskReviewActionNotifier(this._dio) : super(const AsyncValue.data(null));
  
  Future<void> approveJobdesk(String jobdeskId) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post('/api/kepala-cabang/jobdesk/$jobdeskId/approve');
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal menyetujui jobdesk');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message;
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
  
  Future<void> rejectJobdesk(String jobdeskId, String reason) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post(
        '/api/kepala-cabang/jobdesk/$jobdeskId/reject',
        data: {'reason': reason},
      );
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal menolak jobdesk');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message;
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
}

/// Provider untuk Jobdesk Review Action
final jobdeskReviewActionProvider = StateNotifierProvider<JobdeskReviewActionNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return JobdeskReviewActionNotifier(dio);
});

/// Notifier untuk Approve/Reject Work Report
class WorkReportReviewActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  
  WorkReportReviewActionNotifier(this._dio) : super(const AsyncValue.data(null));
  
  Future<void> approveWorkReport(String reportId) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post('/api/kepala-cabang/work-reports/$reportId/approve');
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal menyetujui laporan');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message;
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
  
  Future<void> rejectWorkReport(String reportId, String reason) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post(
        '/api/kepala-cabang/work-reports/$reportId/reject',
        data: {'reason': reason},
      );
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal menolak laporan');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message;
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
}

/// Provider untuk Work Report Review Action
final workReportReviewActionProvider = StateNotifierProvider<WorkReportReviewActionNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return WorkReportReviewActionNotifier(dio);
});
