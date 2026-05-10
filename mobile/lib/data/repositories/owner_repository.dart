import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/models/api_response_models.dart';
import '../../core/network/dio_client.dart';

/// ===========================================
/// OWNER REPOSITORY
/// Handles Owner-specific API calls
/// ===========================================
class OwnerRepository {
  final Dio _dio;

  OwnerRepository(this._dio);

  /// Get dashboard metrics
  /// GET /api/owner/dashboard
  Future<DashboardMetrics> getDashboardMetrics({
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
        ApiEndpoints.ownerDashboard,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      return DashboardMetrics.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get sales ranking
  /// GET /api/owner/sales-ranking
  Future<List<SalesRanking>> getSalesRanking({
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
        ApiEndpoints.ownerSalesRanking,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final List<dynamic> data = response.data;
      return data.map((json) => SalesRanking.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all branches
  /// GET /api/owner/branches
  Future<List<BranchListItem>> getAllBranches() async {
    try {
      final response = await _dio.get(ApiEndpoints.ownerBranches);

      final List<dynamic> data = response.data;
      return data.map((json) => BranchListItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get branch detail
  /// GET /api/owner/branches/:id
  Future<BranchDetail> getBranchDetail(String branchId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.ownerBranchDetail(branchId),
      );

      return BranchDetail.fromJson(response.data);
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
final ownerRepositoryProvider = Provider<OwnerRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return OwnerRepository(dio);
});
