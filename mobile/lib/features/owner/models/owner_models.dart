import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_models.freezed.dart';
part 'owner_models.g.dart';

@freezed
class DashboardMetrics with _$DashboardMetrics {
  const factory DashboardMetrics({
    @JsonKey(name: 'total_revenue') required double totalRevenue,
    @JsonKey(name: 'total_orders') required int totalOrders,
    @JsonKey(name: 'total_customers') required int totalCustomers,
    @JsonKey(name: 'pending_approvals') required int pendingApprovals,
    @JsonKey(name: 'branch_performance') required List<BranchMetrics> branchPerformance,
    @JsonKey(name: 'recent_activity') required List<ActivityItem> recentActivity,
  }) = _DashboardMetrics;

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$DashboardMetricsFromJson(json);
}

@freezed
class BranchMetrics with _$BranchMetrics {
  const factory BranchMetrics({
    required String id,
    required String name,
    required String code,
    required double revenue,
    required int orders,
    required double target,
    @JsonKey(name: 'achievement_percentage') required double achievementPercentage,
  }) = _BranchMetrics;

  factory BranchMetrics.fromJson(Map<String, dynamic> json) =>
      _$BranchMetricsFromJson(json);
}

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    @JsonKey(name: 'user_name') required String userName,
    required String action,
    required String details,
    required String timestamp,
    @JsonKey(name: 'icon_type') required String iconType,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemFromJson(json);
}

@freezed
class SalesRanking with _$SalesRanking {
  const factory SalesRanking({
    required int rank,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'branch_name') required String branchName,
    @JsonKey(name: 'sales_amount') required double salesAmount,
    required double target,
    @JsonKey(name: 'achievement_percentage') required double achievementPercentage,
    @JsonKey(name: 'total_orders') required int totalOrders,
    @JsonKey(name: 'performance_level') required String performanceLevel,
  }) = _SalesRanking;

  factory SalesRanking.fromJson(Map<String, dynamic> json) =>
      _$SalesRankingFromJson(json);
}

@freezed
class Branch with _$Branch {
  const factory Branch({
    required String id,
    required String code,
    required String name,
    required String address,
    required String phone,
    @JsonKey(name: 'manager_id') String? managerId,
    @JsonKey(name: 'total_employees') int? totalEmployees,
    @JsonKey(name: 'total_revenue') double? totalRevenue,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) =>
      _$BranchFromJson(json);
}

@freezed
class BranchDetail with _$BranchDetail {
  const factory BranchDetail({
    required String id,
    required String code,
    required String name,
    required String address,
    required String phone,
    @JsonKey(name: 'manager_id') String? managerId,
    @JsonKey(name: 'manager_name') String? managerName,
    @JsonKey(name: 'total_employees') required int totalEmployees,
    @JsonKey(name: 'total_revenue') required double totalRevenue,
    @JsonKey(name: 'total_orders') required int totalOrders,
    @JsonKey(name: 'pending_approvals') required int pendingApprovals,
    @JsonKey(name: 'attendance_rate') required double attendanceRate,
    @JsonKey(name: 'recent_activity') required List<ActivityItem> recentActivity,
  }) = _BranchDetail;

  factory BranchDetail.fromJson(Map<String, dynamic> json) =>
      _$BranchDetailFromJson(json);
}
