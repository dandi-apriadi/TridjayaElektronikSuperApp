import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/jobdesk_models.dart';

/// Provider untuk mengambil daftar jobdesk assignments
final myJobdeskAssignmentsProvider = FutureProvider<List<JobDeskAssignment>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/jobdesk/assignments/my');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => JobDeskAssignment.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching my jobdesk assignments: ${e.message}');
    throw Exception('Gagal mengambil data jobdesk: ${e.message}');
  }
});

/// Provider untuk mengambil detail jobdesk
final jobdeskDetailProvider = FutureProvider.family<(JobDeskAssignment, List<JobDeskProof>), String>((ref, assignmentId) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/jobdesk/assignments/$assignmentId');
    
    if (response.statusCode == 200) {
      final data = response.data;
      final assignment = JobDeskAssignment.fromJson(data[0]);
      final proofs = (data[1] as List).map((p) => JobDeskProof.fromJson(p)).toList();
      return (assignment, proofs);
    }
    throw Exception('Jobdesk tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching jobdesk detail: ${e.message}');
    throw Exception('Gagal mengambil detail jobdesk: ${e.message}');
  }
});

/// Provider untuk jobdesk templates
final myJobdeskTemplatesProvider = FutureProvider<List<JobDeskTemplate>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/jobdesk/templates/my');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => JobDeskTemplate.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching templates: ${e.message}');
    throw Exception('Gagal mengambil template jobdesk: ${e.message}');
  }
});

/// Provider untuk semua assignments (untuk Owner/Kepala Cabang)
final allJobdeskAssignmentsProvider = FutureProvider.family<List<JobDeskAssignment>, Map<String, dynamic>?>((ref, filters) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (filters != null) {
      if (filters['status'] != null) queryParams['status'] = filters['status'];
      if (filters['branch_id'] != null) queryParams['branch_id'] = filters['branch_id'];
    }
    
    final response = await dio.get('/api/owner/jobdesk/all', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => JobDeskAssignment.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching all assignments: ${e.message}');
    throw Exception('Gagal mengambil data jobdesk: ${e.message}');
  }
});

/// Provider untuk pending jobdesk review (Kepala Cabang)
final pendingJobdeskReviewProvider = FutureProvider<List<JobDeskAssignment>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/kepala-cabang/jobdesk/pending');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => JobDeskAssignment.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching pending reviews: ${e.message}');
    throw Exception('Gagal mengambil data review: ${e.message}');
  }
});

/// Provider untuk jobdesk stats
final jobdeskStatsProvider = FutureProvider.family<JobDeskStats, String?>((ref, branchId) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = branchId != null ? {'branch_id': branchId} : null;
    final response = await dio.get('/api/owner/jobdesk/stats', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      return JobDeskStats.fromJson(response.data);
    }
    throw Exception('Stats tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching jobdesk stats: ${e.message}');
    throw Exception('Gagal mengambil statistik jobdesk: ${e.message}');
  }
});

/// Notifier untuk submit jobdesk
class JobdeskSubmissionNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  
  JobdeskSubmissionNotifier(this._dio) : super(const AsyncValue.data(null));
  
  Future<void> submitJobdesk(String assignmentId, {String? notes, List<String>? proofIds}) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post(
        '/api/jobdesk/assignments/$assignmentId/submit',
        data: {
          'notes': notes,
          'proof_ids': proofIds,
        },
      );
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal submit jobdesk');
      }
    } on DioException catch (e) {
      final error = 'Gagal submit jobdesk: ${e.response?.data['error'] ?? e.message}';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
}

/// Provider untuk submission notifier
final jobdeskSubmissionProvider = StateNotifierProvider<JobdeskSubmissionNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return JobdeskSubmissionNotifier(dio);
});

/// Notifier untuk review jobdesk (approve/reject)
class JobdeskReviewNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  
  JobdeskReviewNotifier(this._dio) : super(const AsyncValue.data(null));
  
  Future<void> approveJobdesk(String assignmentId) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post('/api/kepala-cabang/jobdesk/$assignmentId/approve');
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal approve jobdesk');
      }
    } on DioException catch (e) {
      final error = 'Gagal approve jobdesk: ${e.response?.data['error'] ?? e.message}';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
  
  Future<void> rejectJobdesk(String assignmentId, String reason) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _dio.post(
        '/api/kepala-cabang/jobdesk/$assignmentId/reject',
        data: {'reason': reason},
      );
      
      if (response.statusCode == 200) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Gagal reject jobdesk');
      }
    } on DioException catch (e) {
      final error = 'Gagal reject jobdesk: ${e.response?.data['error'] ?? e.message}';
      state = AsyncValue.error(error, StackTrace.current);
      throw Exception(error);
    }
  }
}

/// Provider untuk review notifier
final jobdeskReviewProvider = StateNotifierProvider<JobdeskReviewNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return JobdeskReviewNotifier(dio);
});
