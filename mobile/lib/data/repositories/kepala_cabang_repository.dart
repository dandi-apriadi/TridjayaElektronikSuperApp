import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/models/api_response_models.dart';
import '../../core/network/dio_client.dart';

/// ===========================================
/// KEPALA CABANG REPOSITORY
/// Handles Kepala Cabang-specific API calls
/// ===========================================
class KepalaCabangRepository {
  final Dio _dio;

  KepalaCabangRepository(this._dio);

  /// Get branch dashboard
  /// GET /api/kepala-cabang/dashboard
  Future<BranchDashboard> getBranchDashboard() async {
    try {
      final response = await _dio.get(ApiEndpoints.kcDashboard);
      return BranchDashboard.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get branch employees
  /// GET /api/kepala-cabang/employees
  Future<List<EmployeeSummary>> getBranchEmployees() async {
    try {
      final response = await _dio.get(ApiEndpoints.kcEmployees);

      final List<dynamic> data = response.data;
      return data.map((json) => EmployeeSummary.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get pending job desk reviews
  /// GET /api/kepala-cabang/jobdesk/pending
  Future<List<JobDeskReviewItem>> getPendingJobdesk() async {
    try {
      final response = await _dio.get(ApiEndpoints.kcPendingJobdesk);

      final List<dynamic> data = response.data;
      return data.map((json) => JobDeskReviewItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Approve job desk
  /// POST /api/kepala-cabang/jobdesk/:id/approve
  Future<void> approveJobdesk(String jobdeskId) async {
    try {
      await _dio.post(ApiEndpoints.kcApproveJobdesk(jobdeskId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reject job desk
  /// POST /api/kepala-cabang/jobdesk/:id/reject
  Future<void> rejectJobdesk(String jobdeskId, String reason) async {
    try {
      await _dio.post(
        ApiEndpoints.kcRejectJobdesk(jobdeskId),
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get pending work reports
  /// GET /api/kepala-cabang/work-reports/pending
  Future<List<WorkReportReviewItem>> getPendingWorkReports() async {
    try {
      final response = await _dio.get(ApiEndpoints.kcPendingWorkReports);

      final List<dynamic> data = response.data;
      return data.map((json) => WorkReportReviewItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Approve work report
  /// POST /api/kepala-cabang/work-reports/:id/approve
  Future<void> approveWorkReport(String reportId) async {
    try {
      await _dio.post(ApiEndpoints.kcApproveWorkReport(reportId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Reject work report
  /// POST /api/kepala-cabang/work-reports/:id/reject
  Future<void> rejectWorkReport(String reportId, String reason) async {
    try {
      await _dio.post(
        ApiEndpoints.kcRejectWorkReport(reportId),
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get attendance summary
  /// GET /api/kepala-cabang/attendance
  Future<List<AttendanceSummary>> getAttendanceSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }

      final response = await _dio.get(
        ApiEndpoints.kcAttendance,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => AttendanceSummary.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle repository errors
  Exception _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 401) {
        return Exception('Unauthorized. Please login again.');
      }
      if (statusCode == 403) {
        return Exception('Forbidden. You do not have access to this resource.');
      }

      if (data != null && data['message'] != null) {
        return Exception(data['message']);
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('An error occurred. Please try again.');
    }
  }
}

/// ===========================================
/// RIVERPOD PROVIDER
/// ===========================================
final kepalaCabangRepositoryProvider = Provider<KepalaCabangRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return KepalaCabangRepository(dio);
});
