/// Model untuk Work Report
class WorkReport {
  final String id;
  final String userId;
  final String branchId;
  final String reportDate;
  final String content;
  final String? achievements;
  final String? challenges;
  final List<String> photos;
  final String status;
  final String submittedAt;
  final String? reviewedBy;
  final String? reviewedAt;
  final String? rejectionReason;
  final String? employeeName;
  final String? reviewerName;

  WorkReport({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.reportDate,
    required this.content,
    this.achievements,
    this.challenges,
    required this.photos,
    required this.status,
    required this.submittedAt,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    this.employeeName,
    this.reviewerName,
  });

  factory WorkReport.fromJson(Map<String, dynamic> json) {
    return WorkReport(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      branchId: json['branch_id'] ?? '',
      reportDate: json['report_date'] ?? '',
      content: json['content'] ?? '',
      achievements: json['achievements'],
      challenges: json['challenges'],
      photos: (json['photos'] as List?)?.map((p) => p.toString()).toList() ?? [],
      status: json['status'] ?? 'submitted',
      submittedAt: json['submitted_at'] ?? '',
      reviewedBy: json['reviewed_by'],
      reviewedAt: json['reviewed_at'],
      rejectionReason: json['rejection_reason'],
      employeeName: json['employee_name'],
      reviewerName: json['reviewer_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'branch_id': branchId,
      'report_date': reportDate,
      'content': content,
      'achievements': achievements,
      'challenges': challenges,
      'photos': photos,
      'status': status,
      'submitted_at': submittedAt,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt,
      'rejection_reason': rejectionReason,
      'employee_name': employeeName,
      'reviewer_name': reviewerName,
    };
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Menunggu Review';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }

  bool get canEdit => status == 'submitted';
  bool get canDelete => status == 'submitted';
}

/// Model untuk Work Report Stats
class WorkReportStats {
  final int totalReports;
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;
  final int thisMonthCount;

  WorkReportStats({
    required this.totalReports,
    required this.pendingCount,
    required this.approvedCount,
    required this.rejectedCount,
    required this.thisMonthCount,
  });

  factory WorkReportStats.fromJson(Map<String, dynamic> json) {
    return WorkReportStats(
      totalReports: json['total_reports'] ?? 0,
      pendingCount: json['pending_count'] ?? 0,
      approvedCount: json['approved_count'] ?? 0,
      rejectedCount: json['rejected_count'] ?? 0,
      thisMonthCount: json['this_month_count'] ?? 0,
    );
  }
}
