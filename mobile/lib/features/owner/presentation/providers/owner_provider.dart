import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/owner_models.dart';

/// Provider untuk Owner Dashboard Metrics
final ownerDashboardProvider = FutureProvider<DashboardMetrics>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/owner/dashboard');
    
    if (response.statusCode == 200) {
      return DashboardMetrics.fromJson(response.data);
    }
    throw Exception('Dashboard tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching owner dashboard: ${e.message}');
    throw Exception('Gagal mengambil data dashboard: ${e.message}');
  }
});

/// Provider untuk Sales Ranking
final salesRankingProvider = FutureProvider<List<SalesRanking>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/owner/sales-ranking');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => SalesRanking.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching sales ranking: ${e.message}');
    throw Exception('Gagal mengambil data ranking: ${e.message}');
  }
});

/// Provider untuk All Branches
final ownerBranchesProvider = FutureProvider<List<Branch>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/owner/branches');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Branch.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching branches: ${e.message}');
    throw Exception('Gagal mengambil data cabang: ${e.message}');
  }
});

/// Provider untuk Branch Detail
final ownerBranchDetailProvider = FutureProvider.family<BranchDetail, String>((ref, branchId) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/owner/branches/$branchId');
    
    if (response.statusCode == 200) {
      return BranchDetail.fromJson(response.data);
    }
    throw Exception('Detail cabang tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching branch detail: ${e.message}');
    throw Exception('Gagal mengambil detail cabang: ${e.message}');
  }
});

/// State Management untuk Date Range Filter
final dateRangeFilterProvider = StateProvider<DateRangeFilter>((ref) {
  return DateRangeFilter.currentMonth();
});

class DateRangeFilter {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeFilter({
    required this.startDate,
    required this.endDate,
  });

  factory DateRangeFilter.currentMonth() {
    final now = DateTime.now();
    return DateRangeFilter(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
    );
  }

  factory DateRangeFilter.currentYear() {
    final now = DateTime.now();
    return DateRangeFilter(
      startDate: DateTime(now.year, 1, 1),
      endDate: now,
    );
  }

  factory DateRangeFilter.last30Days() {
    final now = DateTime.now();
    return DateRangeFilter(
      startDate: now.subtract(const Duration(days: 30)),
      endDate: now,
    );
  }

  String get label {
    if (startDate.month == DateTime.now().month &&
        startDate.year == DateTime.now().year &&
        endDate == DateTime.now()) {
      return 'Bulan Ini';
    } else if (startDate.year == DateTime.now().year &&
        startDate.month == 1 &&
        endDate.month == DateTime.now().month) {
      return 'Tahun Ini';
    } else if (endDate.difference(startDate).inDays == 29) {
      return '30 Hari Terakhir';
    }
    return '${startDate.day}/${startDate.month} - ${endDate.day}/${endDate.month}';
  }
}

/// Parameterized Dashboard Provider with Date Filter
final filteredDashboardProvider = FutureProvider.family<DashboardMetrics, DateRangeFilter>((ref, filter) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get(
      '/api/owner/dashboard',
      queryParameters: {
        'start_date': filter.startDate.toString().split(' ')[0],
        'end_date': filter.endDate.toString().split(' ')[0],
      },
    );
    
    if (response.statusCode == 200) {
      return DashboardMetrics.fromJson(response.data);
    }
    throw Exception('Dashboard tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching filtered dashboard: ${e.message}');
    throw Exception('Gagal mengambil data dashboard: ${e.message}');
  }
});
