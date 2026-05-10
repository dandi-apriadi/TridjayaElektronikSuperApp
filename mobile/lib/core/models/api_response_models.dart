import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_models.freezed.dart';
part 'api_response_models.g.dart';

// ===========================================
// BASE API RESPONSE
// ===========================================
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    required String message,
    T? data,
    ApiError? error,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String code,
    required String message,
    Map<String, dynamic>? details,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}

// ===========================================
// AUTH RESPONSES
// ===========================================
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    required String refreshToken,
    required UserInfo user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String id,
    required String email,
    required String fullName,
    required String role,
    String? branchId,
    String? branchName,
    String? phone,
    String? department,
    String? position,
    String? profilePhotoUrl,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}

// ===========================================
// OWNER DASHBOARD RESPONSES
// ===========================================
@freezed
class DashboardMetrics with _$DashboardMetrics {
  const factory DashboardMetrics({
    required double totalRevenue,
    required int totalOrders,
    required int totalCustomers,
    required int pendingApprovals,
    required List<BranchMetrics> branchPerformance,
    required List<ActivityItem> recentActivity,
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
    required double achievementPercentage,
  }) = _BranchMetrics;

  factory BranchMetrics.fromJson(Map<String, dynamic> json) =>
      _$BranchMetricsFromJson(json);
}

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required String userName,
    required String action,
    required String details,
    required String timestamp,
    required String iconType,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemFromJson(json);
}

@freezed
class SalesRanking with _$SalesRanking {
  const factory SalesRanking({
    required int rank,
    required String userId,
    required String fullName,
    required String branchName,
    required double salesAmount,
    required double target,
    required double achievementPercentage,
    required int totalOrders,
    required String performanceLevel,
  }) = _SalesRanking;

  factory SalesRanking.fromJson(Map<String, dynamic> json) =>
      _$SalesRankingFromJson(json);
}

@freezed
class BranchDetail with _$BranchDetail {
  const factory BranchDetail({
    required String id,
    required String code,
    required String name,
    required String address,
    required String phone,
    required String email,
    ManagerInfo? manager,
    required int employeeCount,
    required BranchMetrics metrics,
  }) = _BranchDetail;

  factory BranchDetail.fromJson(Map<String, dynamic> json) =>
      _$BranchDetailFromJson(json);
}

@freezed
class ManagerInfo with _$ManagerInfo {
  const factory ManagerInfo({
    required String id,
    required String fullName,
    required String email,
    required String phone,
  }) = _ManagerInfo;

  factory ManagerInfo.fromJson(Map<String, dynamic> json) =>
      _$ManagerInfoFromJson(json);
}

@freezed
class BranchListItem with _$BranchListItem {
  const factory BranchListItem({
    required String id,
    required String code,
    required String name,
    required String status,
    required int employeeCount,
    String? managerName,
  }) = _BranchListItem;

  factory BranchListItem.fromJson(Map<String, dynamic> json) =>
      _$BranchListItemFromJson(json);
}

// ===========================================
// KEPALA CABANG RESPONSES
// ===========================================
@freezed
class BranchDashboard with _$BranchDashboard {
  const factory BranchDashboard({
    required String branchId,
    required String branchName,
    required String branchCode,
    required int totalEmployees,
    required int activeEmployees,
    required int pendingJobdesk,
    required int pendingWorkReports,
    required int todayAttendance,
    required int onLeave,
  }) = _BranchDashboard;

  factory BranchDashboard.fromJson(Map<String, dynamic> json) =>
      _$BranchDashboardFromJson(json);
}

@freezed
class EmployeeSummary with _$EmployeeSummary {
  const factory EmployeeSummary({
    required String id,
    required String fullName,
    required String email,
    required String role,
    String? department,
    String? phone,
    required String status,
    String? lastLoginAt,
    String? jobdeskStatus,
    String? workReportStatus,
  }) = _EmployeeSummary;

  factory EmployeeSummary.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSummaryFromJson(json);
}

@freezed
class JobDeskReviewItem with _$JobDeskReviewItem {
  const factory JobDeskReviewItem({
    required String id,
    required String employeeId,
    required String employeeName,
    required String title,
    required String assignedDate,
    required String submittedAt,
    List<String>? photos,
    String? notes,
  }) = _JobDeskReviewItem;

  factory JobDeskReviewItem.fromJson(Map<String, dynamic> json) =>
      _$JobDeskReviewItemFromJson(json);
}

@freezed
class WorkReportReviewItem with _$WorkReportReviewItem {
  const factory WorkReportReviewItem({
    required String id,
    required String employeeId,
    required String employeeName,
    required String reportDate,
    required String content,
    String? achievements,
    String? challenges,
    List<String>? photos,
    required String submittedAt,
  }) = _WorkReportReviewItem;

  factory WorkReportReviewItem.fromJson(Map<String, dynamic> json) =>
      _$WorkReportReviewItemFromJson(json);
}

@freezed
class AttendanceSummary with _$AttendanceSummary {
  const factory AttendanceSummary({
    required String date,
    required int present,
    required int absent,
    required int onLeave,
    required int late,
  }) = _AttendanceSummary;

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryFromJson(json);
}

// ===========================================
// REQUEST BODIES
// ===========================================
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

@freezed
class PasswordResetRequest with _$PasswordResetRequest {
  const factory PasswordResetRequest({
    required String email,
  }) = _PasswordResetRequest;

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
}

@freezed
class PasswordResetVerifyRequest with _$PasswordResetVerifyRequest {
  const factory PasswordResetVerifyRequest({
    required String email,
    required String otp,
    required String newPassword,
  }) = _PasswordResetVerifyRequest;

  factory PasswordResetVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetVerifyRequestFromJson(json);
}

@freezed
class RejectRequest with _$RejectRequest {
  const factory RejectRequest({
    required String reason,
  }) = _RejectRequest;

  factory RejectRequest.fromJson(Map<String, dynamic> json) =>
      _$RejectRequestFromJson(json);
}

// ===========================================
// PAGINATION
// ===========================================
@freezed
class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> items,
    required int total,
    required int page,
    required int perPage,
    required int totalPages,
  }) = _PaginatedResponse<T>;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
}

// ===========================================
// NOTIFICATION
// ===========================================
@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    required String status,
    String? readAt,
    required String createdAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
