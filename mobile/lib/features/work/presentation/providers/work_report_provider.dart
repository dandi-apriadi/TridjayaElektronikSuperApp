import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/work_report_model.dart';

/// Provider untuk daftar work report saya
final myWorkReportsProvider = FutureProvider.family<List<WorkReport>, Map<String, dynamic>?>((ref, filters) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (filters != null) {
      if (filters['status'] != null) queryParams['status'] = filters['status'];
      if (filters['start_date'] != null) queryParams['start_date'] = filters['start_date'];
      if (filters['end_date'] != null) queryParams['end_date'] = filters['end_date'];
    }
    
    final response = await dio.get('/api/work-reports/my', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => WorkReport.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching work reports: ${e.message}');
    throw Exception('Gagal mengambil data laporan: ${e.message}');
  }
});

/// Provider untuk detail work report
final workReportDetailProvider = FutureProvider.family<WorkReport, String>((ref, reportId) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/work-reports/$reportId');
    
    if (response.statusCode == 200) {
      return WorkReport.fromJson(response.data);
    }
    throw Exception('Laporan tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching work report detail: ${e.message}');
    throw Exception('Gagal mengambil detail laporan: ${e.message}');
  }
});

/// Provider untuk work report stats
final workReportStatsProvider = FutureProvider<WorkReportStats>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/work-reports/stats');
    
    if (response.statusCode == 200) {
      return WorkReportStats.fromJson(response.data);
    }
    throw Exception('Statistik tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching work report stats: ${e.message}');
    throw Exception('Gagal mengambil statistik: ${e.message}');
  }
});

/// Notifier untuk create/update/delete work report
class WorkReportNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  
  WorkReportNotifier(this._dio) : super(const AsyncValue.data(null));
  
  Future<void> createWorkReport({
    required DateTime reportDate,
    required String content,
    String? achievements,
    String? challenges,
    List<String>? photoUrls,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post('/api/work-reports', data: {
        'report_date': reportDate.toIso8601String().split('T')[0],
        'content': content,
        'achievements': achievements,
        'challenges': challenges,
        'photo_urls': photoUrls,
      });
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal membuat laporan');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message ?? 'Gagal membuat laporan';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
  
  Future<void> updateWorkReport(
    String reportId, {
    String? content,
    String? achievements,
    String? challenges,
    List<String>? photoUrls,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final data = <String, dynamic>{};
      if (content != null) data['content'] = content;
      if (achievements != null) data['achievements'] = achievements;
      if (challenges != null) data['challenges'] = challenges;
      if (photoUrls != null) data['photo_urls'] = photoUrls;
      
      final response = await _dio.put('/api/work-reports/$reportId', data: data);
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal update laporan');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message ?? 'Gagal update laporan';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
  
  Future<void> deleteWorkReport(String reportId) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.delete('/api/work-reports/$reportId');
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal menghapus laporan');
      }
    } on DioException catch (e) {
      final error = e.response?.data['error'] ?? e.message ?? 'Gagal menghapus laporan';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
}

/// Provider untuk work report notifier
final workReportNotifierProvider = StateNotifierProvider<WorkReportNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return WorkReportNotifier(dio);
});
