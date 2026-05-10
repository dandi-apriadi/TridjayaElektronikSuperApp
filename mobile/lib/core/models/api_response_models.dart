// ===========================================
// API RESPONSE MODELS - WITHOUT FREEZED
// Simple Dart classes with manual JSON serialization
// ===========================================

// ===========================================
// BASE API RESPONSE
// ===========================================
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final ApiError? error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] != null
          ? ApiError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );
  }
}

// ===========================================
// AUTH RESPONSES
// ===========================================
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserInfo user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserInfo {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? branchId;
  final String? branchName;
  final String? phone;
  final String? department;
  final String? position;
  final String? profilePhotoUrl;

  UserInfo({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.branchId,
    this.branchName,
    this.phone,
    this.department,
    this.position,
    this.profilePhotoUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      branchId: json['branch_id'] as String?,
      branchName: json['branch_name'] as String?,
      phone: json['phone'] as String?,
      department: json['department'] as String?,
      position: json['position'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }
}

// ===========================================
// OWNER DASHBOARD RESPONSES
// ===========================================
class DashboardMetrics {
  final double totalRevenue;
  final int totalOrders;
  final int totalCustomers;
  final int pendingApprovals;
  final List<BranchMetrics> branchPerformance;
  final List<ActivityItem> recentActivity;

  DashboardMetrics({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalCustomers,
    required this.pendingApprovals,
    required this.branchPerformance,
    required this.recentActivity,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalOrders: json['total_orders'] as int,
      totalCustomers: json['total_customers'] as int,
      pendingApprovals: json['pending_approvals'] as int,
      branchPerformance: (json['branch_performance'] as List)
          .map((e) => BranchMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentActivity: (json['recent_activity'] as List)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BranchMetrics {
  final String id;
  final String name;
  final String code;
  final double revenue;
  final int orders;
  final double target;
  final double achievementPercentage;

  BranchMetrics({
    required this.id,
    required this.name,
    required this.code,
    required this.revenue,
    required this.orders,
    required this.target,
    required this.achievementPercentage,
  });

  factory BranchMetrics.fromJson(Map<String, dynamic> json) {
    return BranchMetrics(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      orders: json['orders'] as int,
      target: (json['target'] as num).toDouble(),
      achievementPercentage: (json['achievement_percentage'] as num).toDouble(),
    );
  }
}

class ActivityItem {
  final String id;
  final String userName;
  final String action;
  final String details;
  final String timestamp;
  final String iconType;

  ActivityItem({
    required this.id,
    required this.userName,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.iconType,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      action: json['action'] as String,
      details: json['details'] as String,
      timestamp: json['timestamp'] as String,
      iconType: json['icon_type'] as String,
    );
  }
}

class SalesRanking {
  final int rank;
  final String userId;
  final String fullName;
  final String branchName;
  final double salesAmount;
  final double target;
  final double achievementPercentage;
  final int totalOrders;
  final String performanceLevel;

  SalesRanking({
    required this.rank,
    required this.userId,
    required this.fullName,
    required this.branchName,
    required this.salesAmount,
    required this.target,
    required this.achievementPercentage,
    required this.totalOrders,
    required this.performanceLevel,
  });

  factory SalesRanking.fromJson(Map<String, dynamic> json) {
    return SalesRanking(
      rank: json['rank'] as int,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      branchName: json['branch_name'] as String,
      salesAmount: (json['sales_amount'] as num).toDouble(),
      target: (json['target'] as num).toDouble(),
      achievementPercentage: (json['achievement_percentage'] as num).toDouble(),
      totalOrders: json['total_orders'] as int,
      performanceLevel: json['performance_level'] as String,
    );
  }
}

class BranchDetail {
  final String id;
  final String code;
  final String name;
  final String address;
  final String phone;
  final String email;
  final ManagerInfo? manager;
  final int employeeCount;
  final BranchMetrics metrics;

  BranchDetail({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    this.manager,
    required this.employeeCount,
    required this.metrics,
  });

  factory BranchDetail.fromJson(Map<String, dynamic> json) {
    return BranchDetail(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      manager: json['manager'] != null
          ? ManagerInfo.fromJson(json['manager'] as Map<String, dynamic>)
          : null,
      employeeCount: json['employee_count'] as int,
      metrics: BranchMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
    );
  }
}

class ManagerInfo {
  final String id;
  final String fullName;
  final String email;
  final String phone;

  ManagerInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory ManagerInfo.fromJson(Map<String, dynamic> json) {
    return ManagerInfo(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }
}

class BranchListItem {
  final String id;
  final String code;
  final String name;
  final String status;
  final int employeeCount;
  final String? managerName;

  BranchListItem({
    required this.id,
    required this.code,
    required this.name,
    required this.status,
    required this.employeeCount,
    this.managerName,
  });

  factory BranchListItem.fromJson(Map<String, dynamic> json) {
    return BranchListItem(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      employeeCount: json['employee_count'] as int,
      managerName: json['manager_name'] as String?,
    );
  }
}

// ===========================================
// KEPALA CABANG RESPONSES
// ===========================================
class BranchDashboard {
  final String branchId;
  final String branchName;
  final String branchCode;
  final int totalEmployees;
  final int activeEmployees;
  final int pendingJobdesk;
  final int pendingWorkReports;
  final int todayAttendance;
  final int onLeave;

  BranchDashboard({
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.totalEmployees,
    required this.activeEmployees,
    required this.pendingJobdesk,
    required this.pendingWorkReports,
    required this.todayAttendance,
    required this.onLeave,
  });

  factory BranchDashboard.fromJson(Map<String, dynamic> json) {
    return BranchDashboard(
      branchId: json['branch_id'] as String,
      branchName: json['branch_name'] as String,
      branchCode: json['branch_code'] as String,
      totalEmployees: json['total_employees'] as int,
      activeEmployees: json['active_employees'] as int,
      pendingJobdesk: json['pending_jobdesk'] as int,
      pendingWorkReports: json['pending_work_reports'] as int,
      todayAttendance: json['today_attendance'] as int,
      onLeave: json['on_leave'] as int,
    );
  }
}

class EmployeeSummary {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? department;
  final String? phone;
  final String status;
  final String? lastLoginAt;
  final String? jobdeskStatus;
  final String? workReportStatus;

  EmployeeSummary({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.department,
    this.phone,
    required this.status,
    this.lastLoginAt,
    this.jobdeskStatus,
    this.workReportStatus,
  });

  factory EmployeeSummary.fromJson(Map<String, dynamic> json) {
    return EmployeeSummary(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      department: json['department'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      lastLoginAt: json['last_login_at'] as String?,
      jobdeskStatus: json['jobdesk_status'] as String?,
      workReportStatus: json['work_report_status'] as String?,
    );
  }
}

class JobDeskReviewItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String title;
  final String assignedDate;
  final String submittedAt;
  final List<String>? photos;
  final String? notes;

  JobDeskReviewItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.title,
    required this.assignedDate,
    required this.submittedAt,
    this.photos,
    this.notes,
  });

  factory JobDeskReviewItem.fromJson(Map<String, dynamic> json) {
    return JobDeskReviewItem(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String,
      title: json['title'] as String,
      assignedDate: json['assigned_date'] as String,
      submittedAt: json['submitted_at'] as String,
      photos: (json['photos'] as List?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
    );
  }
}

class WorkReportReviewItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String reportDate;
  final String content;
  final String? achievements;
  final String? challenges;
  final List<String>? photos;
  final String submittedAt;

  WorkReportReviewItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.reportDate,
    required this.content,
    this.achievements,
    this.challenges,
    this.photos,
    required this.submittedAt,
  });

  factory WorkReportReviewItem.fromJson(Map<String, dynamic> json) {
    return WorkReportReviewItem(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String,
      reportDate: json['report_date'] as String,
      content: json['content'] as String,
      achievements: json['achievements'] as String?,
      challenges: json['challenges'] as String?,
      photos: (json['photos'] as List?)?.map((e) => e as String).toList(),
      submittedAt: json['submitted_at'] as String,
    );
  }
}

class AttendanceSummary {
  final String date;
  final int present;
  final int absent;
  final int onLeave;
  final int late;

  AttendanceSummary({
    required this.date,
    required this.present,
    required this.absent,
    required this.onLeave,
    required this.late,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      date: json['date'] as String,
      present: json['present'] as int,
      absent: json['absent'] as int,
      onLeave: json['on_leave'] as int,
      late: json['late'] as int,
    );
  }
}

// ===========================================
// REQUEST BODIES
// ===========================================
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}

class PasswordResetRequest {
  final String email;

  PasswordResetRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class PasswordResetVerifyRequest {
  final String email;
  final String otp;
  final String newPassword;

  PasswordResetVerifyRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'new_password': newPassword,
    };
  }
}

class RejectRequest {
  final String reason;

  RejectRequest({
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
    };
  }
}

// ===========================================
// PAGINATION
// ===========================================
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List).map((e) => fromJsonT(e)).toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['per_page'] as int,
      totalPages: json['total_pages'] as int,
    );
  }
}

// ===========================================
// NOTIFICATION
// ===========================================
class NotificationItem {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final String status;
  final String? readAt;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.status,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      status: json['status'] as String,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
