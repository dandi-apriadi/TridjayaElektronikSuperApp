/// ============================================================
/// 📝 WORK REPORT MODELS
/// Laporan Kerja Harian (IDG - Input Data Giat)
/// ============================================================

enum WorkReportStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
}

class WorkReport {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String branchId;
  final String branchName;
  final String role;
  
  // Content
  final String content;
  final String? achievements;
  final String? challenges;
  final String? nextPlan;
  
  // Photos
  final List<String>? photoUrls;
  
  // Status
  final WorkReportStatus status;
  final String? reviewedBy;
  final String? reviewerName;
  final String? rejectionReason;
  
  // Timestamps
  final DateTime reportDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? reviewedAt;
  
  WorkReport({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.branchId,
    required this.branchName,
    required this.role,
    required this.content,
    this.achievements,
    this.challenges,
    this.nextPlan,
    this.photoUrls,
    required this.status,
    this.reviewedBy,
    this.reviewerName,
    this.rejectionReason,
    required this.reportDate,
    required this.createdAt,
    this.updatedAt,
    this.reviewedAt,
  });
  
  factory WorkReport.fromJson(Map<String, dynamic> json) {
    return WorkReport(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      role: json['role'],
      content: json['content'],
      achievements: json['achievements'],
      challenges: json['challenges'],
      nextPlan: json['next_plan'],
      photoUrls: json['photo_urls'] != null 
          ? List<String>.from(json['photo_urls']) 
          : null,
      status: WorkReportStatus.values.byName(json['status']),
      reviewedBy: json['reviewed_by'],
      reviewerName: json['reviewer_name'],
      rejectionReason: json['rejection_reason'],
      reportDate: DateTime.parse(json['report_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      reviewedAt: json['reviewed_at'] != null 
          ? DateTime.parse(json['reviewed_at']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'branch_id': branchId,
      'branch_name': branchName,
      'role': role,
      'content': content,
      'achievements': achievements,
      'challenges': challenges,
      'next_plan': nextPlan,
      'photo_urls': photoUrls,
      'status': status.name,
      'reviewed_by': reviewedBy,
      'reviewer_name': reviewerName,
      'rejection_reason': rejectionReason,
      'report_date': reportDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }
  
  String get statusLabel {
    switch (status) {
      case WorkReportStatus.draft:
        return 'Draft';
      case WorkReportStatus.submitted:
        return 'Menunggu Review';
      case WorkReportStatus.underReview:
        return 'Sedang Direview';
      case WorkReportStatus.approved:
        return 'Disetujui';
      case WorkReportStatus.rejected:
        return 'Ditolak';
    }
  }
  
  String get statusColor {
    switch (status) {
      case WorkReportStatus.draft:
        return 'grey';
      case WorkReportStatus.submitted:
      case WorkReportStatus.underReview:
        return 'orange';
      case WorkReportStatus.approved:
        return 'green';
      case WorkReportStatus.rejected:
        return 'red';
    }
  }
}

/// ============================================================
/// 📊 WORK REPORT SUMMARY (Untuk Dashboard)
/// ============================================================

class WorkReportSummary {
  final int totalReports;
  final int approvedCount;
  final int pendingCount;
  final int rejectedCount;
  final double approvalRate;
  final int todaySubmitted;
  final int yesterdaySubmitted;
  final List<WorkReport> recentReports;
  
  WorkReportSummary({
    required this.totalReports,
    required this.approvedCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.approvalRate,
    required this.todaySubmitted,
    required this.yesterdaySubmitted,
    required this.recentReports,
  });
}

/// ============================================================
/// 👥 PENDING REVIEW ITEM (Untuk Kepala Cabang/PIC)
/// ============================================================

class PendingReviewItem {
  final String reportId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String branchName;
  final String role;
  final String content;
  final int photoCount;
  final DateTime submittedAt;
  final DateTime reportDate;
  
  PendingReviewItem({
    required this.reportId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.branchName,
    required this.role,
    required this.content,
    required this.photoCount,
    required this.submittedAt,
    required this.reportDate,
  });
}
