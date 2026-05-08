/// ============================================================
/// 📊 JOB DESK ACTIVITY MODELS - Pelaporan Aktivitas Karyawan
/// ============================================================
/// 
/// Model untuk melacak aktivitas job desk karyawan
/// Digunakan oleh Owner, Kepala Cabang, dan PIC untuk monitoring
/// 
/// Author: TE SuperApp Team
/// Created: May 2026
/// 
/// ============================================================

import 'jobdesk_models.dart';

/// ============================================================
/// 👤 EMPLOYEE JOB DESK ACTIVITY (Aktivitas per Karyawan)
/// ============================================================

class EmployeeJobDeskActivity {
  final String userId;
  final String userName;
  final String role;
  final String branchId;
  final String branchName;
  final DateTime date;
  
  // Summary stats
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int verifiedTasks;
  final int rejectedTasks;
  final double completionRate;
  final double verificationRate;
  
  // Detail submissions
  final List<TaskSubmissionDetail> submissions;
  
  // Status
  final bool isAllSubmitted;
  final bool isAllVerified;
  final DateTime? lastActivity;
  
  // Scoring (for PIC verification)
  final int? dailyScore;
  final String? scoreGrade;
  final String? picNotes;
  
  EmployeeJobDeskActivity({
    required this.userId,
    required this.userName,
    required this.role,
    required this.branchId,
    required this.branchName,
    required this.date,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    this.verifiedTasks = 0,
    this.rejectedTasks = 0,
    required this.completionRate,
    this.verificationRate = 0.0,
    required this.submissions,
    this.isAllSubmitted = false,
    this.isAllVerified = false,
    this.lastActivity,
    this.dailyScore,
    this.scoreGrade,
    this.picNotes,
  });
  
  /// Helper getters
  bool get hasSubmittedToday => completedTasks > 0;
  bool get needsVerification => completedTasks > verifiedTasks;
  bool get isPendingVerification => needsVerification;
  
  /// Status label
  String get statusLabel {
    if (pendingTasks == totalTasks) return 'Belum Mulai';
    if (isAllVerified) return 'Terverifikasi';
    if (isAllSubmitted) return 'Menunggu Verifikasi';
    if (completedTasks > 0) return 'Sedang Dikerjakan';
    return 'Pending';
  }
  
  /// Status color indicator
  ActivityStatus get status {
    if (pendingTasks == totalTasks) return ActivityStatus.notStarted;
    if (isAllVerified) return ActivityStatus.verified;
    if (isAllSubmitted) return ActivityStatus.pendingVerification;
    if (completedTasks > 0) return ActivityStatus.inProgress;
    return ActivityStatus.pending;
  }
}

/// ============================================================
/// 📋 TASK SUBMISSION DETAIL (Detail per Task)
/// ============================================================

class TaskSubmissionDetail {
  final String submissionId;
  final String taskItemId;
  final String taskName;
  final JobDeskTaskType taskType;
  final JobDeskStatus status;
  
  // Submission data
  final int? actualValue;
  final String? targetUnit;
  final int? targetValue;
  final String? proofLink;
  final List<String>? proofPhotos;
  final String? notes;
  
  // Timestamps
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  
  // PIC Verification data
  final String? verifiedBy;
  final int? score;
  final String? rejectionReason;
  final String? picComment;
  
  TaskSubmissionDetail({
    required this.submissionId,
    required this.taskItemId,
    required this.taskName,
    required this.taskType,
    required this.status,
    this.actualValue,
    this.targetUnit,
    this.targetValue,
    this.proofLink,
    this.proofPhotos,
    this.notes,
    this.submittedAt,
    this.verifiedAt,
    this.verifiedBy,
    this.score,
    this.rejectionReason,
    this.picComment,
  });
  
  bool get isPending => status == JobDeskStatus.pending;
  bool get isCompleted => status == JobDeskStatus.completed;
  bool get isVerified => status == JobDeskStatus.verified;
  bool get isRejected => status == JobDeskStatus.rejected;
  
  /// Achievement percentage for counter tasks
  double? get achievementPercentage {
    if (targetValue == null || actualValue == null) return null;
    if (targetValue == 0) return 0;
    return (actualValue! / targetValue!) * 100;
  }
  
  /// Achievement status
  AchievementStatus get achievementStatus {
    final pct = achievementPercentage;
    if (pct == null) return AchievementStatus.notApplicable;
    if (pct >= 100) return AchievementStatus.exceeded;
    if (pct >= 80) return AchievementStatus.good;
    if (pct >= 50) return AchievementStatus.average;
    return AchievementStatus.belowTarget;
  }
}

/// ============================================================
/// 🏢 BRANCH ACTIVITY SUMMARY (Ringkasan per Cabang)
/// ============================================================

class BranchJobDeskSummary {
  final String branchId;
  final String branchName;
  final String branchCode;
  final String? managerName;
  
  // Employee stats
  final int totalEmployees;
  final int activeEmployees;
  final int inactiveEmployees;
  
  // Completion stats
  final int totalTasksToday;
  final int completedTasks;
  final int pendingTasks;
  final int verifiedTasks;
  final double branchCompletionRate;
  final double branchVerificationRate;
  
  // Employee activities
  final List<EmployeeJobDeskActivity> employeeActivities;
  
  // Top/Bottom performers
  final List<EmployeeJobDeskActivity> topPerformers;
  final List<EmployeeJobDeskActivity> needsAttention;
  
  BranchJobDeskSummary({
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    this.managerName,
    required this.totalEmployees,
    required this.activeEmployees,
    this.inactiveEmployees = 0,
    required this.totalTasksToday,
    required this.completedTasks,
    required this.pendingTasks,
    this.verifiedTasks = 0,
    required this.branchCompletionRate,
    this.branchVerificationRate = 0.0,
    required this.employeeActivities,
    this.topPerformers = const [],
    this.needsAttention = const [],
  });
  
  /// Overall branch health
  BranchHealth get health {
    if (branchCompletionRate >= 90) return BranchHealth.excellent;
    if (branchCompletionRate >= 70) return BranchHealth.good;
    if (branchCompletionRate >= 50) return BranchHealth.average;
    return BranchHealth.poor;
  }
  
  /// Employees needing verification
  int get pendingVerificationCount {
    return employeeActivities.where((e) => e.needsVerification).length;
  }
}

/// ============================================================
/// 📈 DAILY ACTIVITY REPORT (Laporan Harian)
/// ============================================================

class DailyJobDeskReport {
  final DateTime date;
  final String generatedBy;
  final DateTime generatedAt;
  
  // Overall stats
  final int totalBranches;
  final int totalEmployees;
  final int totalTasks;
  final int completedTasks;
  final int verifiedTasks;
  final double overallCompletionRate;
  final double overallVerificationRate;
  
  // Branch summaries
  final List<BranchJobDeskSummary> branchSummaries;
  
  // Role breakdown
  final Map<String, RoleActivityStats> roleStats;
  
  // Alerts/Issues
  final List<ActivityAlert> alerts;
  
  DailyJobDeskReport({
    required this.date,
    required this.generatedBy,
    required this.generatedAt,
    required this.totalBranches,
    required this.totalEmployees,
    required this.totalTasks,
    required this.completedTasks,
    required this.verifiedTasks,
    required this.overallCompletionRate,
    required this.overallVerificationRate,
    required this.branchSummaries,
    required this.roleStats,
    this.alerts = const [],
  });
}

/// ============================================================
/// 📊 ROLE ACTIVITY STATS (Statistik per Role)
/// ============================================================

class RoleActivityStats {
  final String roleName;
  final int employeeCount;
  final int totalTasks;
  final int completedTasks;
  final int verifiedTasks;
  final double completionRate;
  final double avgScore;
  
  RoleActivityStats({
    required this.roleName,
    required this.employeeCount,
    required this.totalTasks,
    required this.completedTasks,
    this.verifiedTasks = 0,
    required this.completionRate,
    this.avgScore = 0.0,
  });
}

/// ============================================================
/// ⚠️ ACTIVITY ALERT (Peringatan Aktivitas)
/// ============================================================

class ActivityAlert {
  final String id;
  final AlertType type;
  final String title;
  final String description;
  final String? employeeId;
  final String? employeeName;
  final String? branchId;
  final String? branchName;
  final DateTime createdAt;
  final bool isResolved;
  
  ActivityAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.employeeId,
    this.employeeName,
    this.branchId,
    this.branchName,
    required this.createdAt,
    this.isResolved = false,
  });
}

/// ============================================================
/// 🎯 FILTER OPTIONS (Opsi Filter)
/// ============================================================

class JobDeskActivityFilter {
  String? branchId;
  String? role;
  ActivityStatus? status;
  DateTime? date;
  bool? needsVerification;
  String? searchQuery;
  
  JobDeskActivityFilter({
    this.branchId,
    this.role,
    this.status,
    this.date,
    this.needsVerification,
    this.searchQuery,
  });
  
  JobDeskActivityFilter copyWith({
    String? branchId,
    String? role,
    ActivityStatus? status,
    DateTime? date,
    bool? needsVerification,
    String? searchQuery,
  }) {
    return JobDeskActivityFilter(
      branchId: branchId ?? this.branchId,
      role: role ?? this.role,
      status: status ?? this.status,
      date: date ?? this.date,
      needsVerification: needsVerification ?? this.needsVerification,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// ============================================================
/// 🔤 ENUMS
/// ============================================================

enum ActivityStatus {
  notStarted,
  pending,
  inProgress,
  pendingVerification,
  verified,
  rejected,
}

enum AchievementStatus {
  notApplicable,
  exceeded,      // >= 100%
  good,          // >= 80%
  average,       // >= 50%
  belowTarget,   // < 50%
}

enum BranchHealth {
  excellent,     // >= 90%
  good,          // >= 70%
  average,       // >= 50%
  poor,          // < 50%
}

enum AlertType {
  noActivity,           // No submission today
  lowCompletion,        // < 50% completion
  pendingVerification,  // Needs PIC verification
  rejectedSubmission,   // Submission rejected
  lateSubmission,       // Submitted after cutoff
  excellentPerformance, // 100% completion
}
