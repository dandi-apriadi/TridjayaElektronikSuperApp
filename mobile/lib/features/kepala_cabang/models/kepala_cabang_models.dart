/// Model untuk Branch Dashboard dari backend
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
      branchId: json['branch_id'] ?? '',
      branchName: json['branch_name'] ?? '',
      branchCode: json['branch_code'] ?? '',
      totalEmployees: json['total_employees'] ?? 0,
      activeEmployees: json['active_employees'] ?? 0,
      pendingJobdesk: json['pending_jobdesk'] ?? 0,
      pendingWorkReports: json['pending_work_reports'] ?? 0,
      todayAttendance: json['today_attendance'] ?? 0,
      onLeave: json['on_leave'] ?? 0,
    );
  }
}

/// Model untuk Employee Summary
class EmployeeSummary {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String department;
  final String phone;
  final String status;
  final String? lastLoginAt;
  final String? jobdeskStatus;
  final String? workReportStatus;

  EmployeeSummary({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.department,
    required this.phone,
    required this.status,
    this.lastLoginAt,
    this.jobdeskStatus,
    this.workReportStatus,
  });

  factory EmployeeSummary.fromJson(Map<String, dynamic> json) {
    return EmployeeSummary(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      department: json['department'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      lastLoginAt: json['last_login_at'],
      jobdeskStatus: json['jobdesk_status'],
      workReportStatus: json['work_report_status'],
    );
  }
}

/// Model untuk JobDesk Review Item
class JobDeskReviewItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String title;
  final String assignedDate;
  final String submittedAt;
  final List<dynamic> photos;
  final String? notes;

  JobDeskReviewItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.title,
    required this.assignedDate,
    required this.submittedAt,
    required this.photos,
    this.notes,
  });

  factory JobDeskReviewItem.fromJson(Map<String, dynamic> json) {
    return JobDeskReviewItem(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      employeeName: json['employee_name'] ?? '',
      title: json['title'] ?? '',
      assignedDate: json['assigned_date'] ?? '',
      submittedAt: json['submitted_at'] ?? '',
      photos: json['photos'] ?? [],
      notes: json['notes'],
    );
  }
}

/// Model untuk Work Report Review Item
class WorkReportReviewItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String reportDate;
  final String content;
  final String? achievements;
  final String? challenges;
  final List<dynamic> photos;
  final String submittedAt;

  WorkReportReviewItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.reportDate,
    required this.content,
    this.achievements,
    this.challenges,
    required this.photos,
    required this.submittedAt,
  });

  factory WorkReportReviewItem.fromJson(Map<String, dynamic> json) {
    return WorkReportReviewItem(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      employeeName: json['employee_name'] ?? '',
      reportDate: json['report_date'] ?? '',
      content: json['content'] ?? '',
      achievements: json['achievements'],
      challenges: json['challenges'],
      photos: json['photos'] ?? [],
      submittedAt: json['submitted_at'] ?? '',
    );
  }
}

/// Model untuk Attendance Summary
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
      date: json['date'] ?? '',
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      onLeave: json['on_leave'] ?? 0,
      late: json['late'] ?? 0,
    );
  }
}
