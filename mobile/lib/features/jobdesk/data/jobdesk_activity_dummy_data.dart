/// ============================================================
/// 📊 JOB DESK ACTIVITY DUMMY DATA
/// ============================================================
/// 
/// Data dummy untuk testing UI pelaporan job desk
/// Owner: lihat semua cabang
/// Kepala Cabang: lihat cabang sendiri saja
/// PIC: lihat semua untuk penilaian
/// 
/// Author: TE SuperApp Team
/// Created: May 2026
/// 
/// ============================================================

import '../models/jobdesk_models.dart';
import '../models/jobdesk_activity_models.dart';

class JobDeskActivityDummyData {
  
  /// ============================================================
  /// 🏢 BRANCHES
  /// ============================================================
  
  static final List<Map<String, dynamic>> branches = [
    {
      'id': 'branch_001',
      'name': 'Cabang Pusat',
      'code': 'PST',
      'managerName': 'Andi Wijaya',
    },
    {
      'id': 'branch_002',
      'name': 'Cabang Selatan',
      'code': 'SLT',
      'managerName': 'Budi Santoso',
    },
    {
      'id': 'branch_003',
      'name': 'Cabang Utara',
      'code': 'UTR',
      'managerName': 'Citra Dewi',
    },
    {
      'id': 'branch_004',
      'name': 'Cabang Barat',
      'code': 'BRT',
      'managerName': 'Dedi Kurniawan',
    },
  ];
  
  /// ============================================================
  /// 👤 EMPLOYEE ACTIVITIES - CABANG PUSAT (branch_001)
  /// ============================================================
  
  static List<EmployeeJobDeskActivity> getCabangPusatActivities() {
    final today = DateTime.now();
    return [
      // Support Online - Excellent
      EmployeeJobDeskActivity(
        userId: 'user_s01',
        userName: 'Rina Susanti',
        role: 'Support Online',
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        date: today,
        totalTasks: 4,
        completedTasks: 4,
        pendingTasks: 0,
        verifiedTasks: 4,
        rejectedTasks: 0,
        completionRate: 100.0,
        verificationRate: 100.0,
        isAllSubmitted: true,
        isAllVerified: true,
        lastActivity: today.subtract(Duration(hours: 2)),
        dailyScore: 95,
        scoreGrade: 'A',
        picNotes: 'Sangat baik, semua target tercapai',
        submissions: _generateExcellentSubmissions(),
      ),
      
      // Sales - Good performance
      EmployeeJobDeskActivity(
        userId: 'user_s02',
        userName: 'Ahmad Fauzi',
        role: 'Sales',
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        date: today,
        totalTasks: 5,
        completedTasks: 4,
        pendingTasks: 1,
        verifiedTasks: 3,
        rejectedTasks: 0,
        completionRate: 80.0,
        verificationRate: 75.0,
        isAllSubmitted: false,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 4)),
        dailyScore: 82,
        scoreGrade: 'B',
        picNotes: 'Perlu follow up 1 task pending',
        submissions: _generateGoodSubmissions(),
      ),
      
      // Support Online - Needs attention
      EmployeeJobDeskActivity(
        userId: 'user_s03',
        userName: 'Maya Anggraini',
        role: 'Support Online',
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        date: today,
        totalTasks: 4,
        completedTasks: 2,
        pendingTasks: 2,
        verifiedTasks: 1,
        rejectedTasks: 0,
        completionRate: 50.0,
        verificationRate: 50.0,
        isAllSubmitted: false,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 6)),
        dailyScore: 65,
        scoreGrade: 'C',
        picNotes: 'Perlu dorongan untuk menyelesaikan task',
        submissions: _generateAverageSubmissions(),
      ),
      
      // Driver - No submission yet
      EmployeeJobDeskActivity(
        userId: 'user_d01',
        userName: 'Bambang Supriadi',
        role: 'Driver',
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        date: today,
        totalTasks: 3,
        completedTasks: 0,
        pendingTasks: 3,
        verifiedTasks: 0,
        rejectedTasks: 0,
        completionRate: 0.0,
        verificationRate: 0.0,
        isAllSubmitted: false,
        isAllVerified: false,
        lastActivity: null,
        dailyScore: null,
        scoreGrade: null,
        picNotes: 'Belum ada aktivitas hari ini',
        submissions: [],
      ),
    ];
  }
  
  /// ============================================================
  /// 👤 EMPLOYEE ACTIVITIES - CABANG SELATAN (branch_002)
  /// ============================================================
  
  static List<EmployeeJobDeskActivity> getCabangSelatanActivities() {
    final today = DateTime.now();
    return [
      // Support Online - Pending verification
      EmployeeJobDeskActivity(
        userId: 'user_s04',
        userName: 'Dewi Lestari',
        role: 'Support Online',
        branchId: 'branch_002',
        branchName: 'Cabang Selatan',
        date: today,
        totalTasks: 4,
        completedTasks: 4,
        pendingTasks: 0,
        verifiedTasks: 0,
        rejectedTasks: 0,
        completionRate: 100.0,
        verificationRate: 0.0,
        isAllSubmitted: true,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 1)),
        dailyScore: null,
        scoreGrade: null,
        picNotes: 'Menunggu verifikasi PIC',
        submissions: _generatePendingVerificationSubmissions(),
      ),
      
      // Admin - Partial completion
      EmployeeJobDeskActivity(
        userId: 'user_a01',
        userName: 'Eko Prasetyo',
        role: 'Admin',
        branchId: 'branch_002',
        branchName: 'Cabang Selatan',
        date: today,
        totalTasks: 4,
        completedTasks: 3,
        pendingTasks: 1,
        verifiedTasks: 2,
        rejectedTasks: 1,
        completionRate: 75.0,
        verificationRate: 50.0,
        isAllSubmitted: false,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 3)),
        dailyScore: 70,
        scoreGrade: 'C',
        picNotes: '1 submission perlu perbaikan',
        submissions: _generateMixedSubmissions(),
      ),
      
      // Sales - Excellent
      EmployeeJobDeskActivity(
        userId: 'user_s05',
        userName: 'Fitriani',
        role: 'Sales',
        branchId: 'branch_002',
        branchName: 'Cabang Selatan',
        date: today,
        totalTasks: 5,
        completedTasks: 5,
        pendingTasks: 0,
        verifiedTasks: 5,
        rejectedTasks: 0,
        completionRate: 100.0,
        verificationRate: 100.0,
        isAllSubmitted: true,
        isAllVerified: true,
        lastActivity: today.subtract(Duration(minutes: 30)),
        dailyScore: 98,
        scoreGrade: 'A',
        picNotes: 'Performa luar biasa!',
        submissions: _generateExcellentSubmissions(),
      ),
    ];
  }
  
  /// ============================================================
  /// 👤 EMPLOYEE ACTIVITIES - CABANG UTARA (branch_003)
  /// ============================================================
  
  static List<EmployeeJobDeskActivity> getCabangUtaraActivities() {
    final today = DateTime.now();
    return [
      EmployeeJobDeskActivity(
        userId: 'user_s06',
        userName: 'Guntur Prakoso',
        role: 'Support Online',
        branchId: 'branch_003',
        branchName: 'Cabang Utara',
        date: today,
        totalTasks: 4,
        completedTasks: 3,
        pendingTasks: 1,
        verifiedTasks: 3,
        rejectedTasks: 0,
        completionRate: 75.0,
        verificationRate: 100.0,
        isAllSubmitted: false,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 5)),
        dailyScore: 78,
        scoreGrade: 'B',
        picNotes: null,
        submissions: _generateGoodSubmissions(),
      ),
      
      EmployeeJobDeskActivity(
        userId: 'user_d02',
        userName: 'Hendra Wijaya',
        role: 'Driver',
        branchId: 'branch_003',
        branchName: 'Cabang Utara',
        date: today,
        totalTasks: 3,
        completedTasks: 3,
        pendingTasks: 0,
        verifiedTasks: 2,
        rejectedTasks: 0,
        completionRate: 100.0,
        verificationRate: 66.7,
        isAllSubmitted: true,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 2)),
        dailyScore: 85,
        scoreGrade: 'B',
        picNotes: '1 submission pending verification',
        submissions: _generatePendingVerificationSubmissions(),
      ),
    ];
  }
  
  /// ============================================================
  /// 👤 EMPLOYEE ACTIVITIES - CABANG BARAT (branch_004)
  /// ============================================================
  
  static List<EmployeeJobDeskActivity> getCabangBaratActivities() {
    final today = DateTime.now();
    return [
      EmployeeJobDeskActivity(
        userId: 'user_s07',
        userName: 'Indah Permata',
        role: 'Support Online',
        branchId: 'branch_004',
        branchName: 'Cabang Barat',
        date: today,
        totalTasks: 4,
        completedTasks: 1,
        pendingTasks: 3,
        verifiedTasks: 1,
        rejectedTasks: 0,
        completionRate: 25.0,
        verificationRate: 100.0,
        isAllSubmitted: false,
        isAllVerified: false,
        lastActivity: today.subtract(Duration(hours: 8)),
        dailyScore: 55,
        scoreGrade: 'D',
        picNotes: 'Perlu perhatian khusus',
        submissions: _generateBelowTargetSubmissions(),
      ),
    ];
  }
  
  /// ============================================================
  /// 📊 BRANCH SUMMARIES
  /// ============================================================
  
  static BranchJobDeskSummary getCabangPusatSummary() {
    final activities = getCabangPusatActivities();
    return BranchJobDeskSummary(
      branchId: 'branch_001',
      branchName: 'Cabang Pusat',
      branchCode: 'PST',
      managerName: 'Andi Wijaya',
      totalEmployees: 4,
      activeEmployees: 3,
      inactiveEmployees: 1,
      totalTasksToday: 16,
      completedTasks: 10,
      pendingTasks: 6,
      verifiedTasks: 8,
      branchCompletionRate: 62.5,
      branchVerificationRate: 80.0,
      employeeActivities: activities,
      topPerformers: activities.where((a) => a.completionRate >= 80).toList(),
      needsAttention: activities.where((a) => a.completionRate < 50).toList(),
    );
  }
  
  static BranchJobDeskSummary getCabangSelatanSummary() {
    final activities = getCabangSelatanActivities();
    return BranchJobDeskSummary(
      branchId: 'branch_002',
      branchName: 'Cabang Selatan',
      branchCode: 'SLT',
      managerName: 'Budi Santoso',
      totalEmployees: 3,
      activeEmployees: 3,
      inactiveEmployees: 0,
      totalTasksToday: 13,
      completedTasks: 12,
      pendingTasks: 1,
      verifiedTasks: 7,
      branchCompletionRate: 92.3,
      branchVerificationRate: 58.3,
      employeeActivities: activities,
      topPerformers: activities.where((a) => a.completionRate >= 80).toList(),
      needsAttention: activities.where((a) => a.completionRate < 50).toList(),
    );
  }
  
  static BranchJobDeskSummary getCabangUtaraSummary() {
    final activities = getCabangUtaraActivities();
    return BranchJobDeskSummary(
      branchId: 'branch_003',
      branchName: 'Cabang Utara',
      branchCode: 'UTR',
      managerName: 'Citra Dewi',
      totalEmployees: 2,
      activeEmployees: 2,
      inactiveEmployees: 0,
      totalTasksToday: 7,
      completedTasks: 6,
      pendingTasks: 1,
      verifiedTasks: 5,
      branchCompletionRate: 85.7,
      branchVerificationRate: 83.3,
      employeeActivities: activities,
      topPerformers: activities.where((a) => a.completionRate >= 80).toList(),
      needsAttention: [],
    );
  }
  
  static BranchJobDeskSummary getCabangBaratSummary() {
    final activities = getCabangBaratActivities();
    return BranchJobDeskSummary(
      branchId: 'branch_004',
      branchName: 'Cabang Barat',
      branchCode: 'BRT',
      managerName: 'Dedi Kurniawan',
      totalEmployees: 1,
      activeEmployees: 1,
      inactiveEmployees: 0,
      totalTasksToday: 4,
      completedTasks: 1,
      pendingTasks: 3,
      verifiedTasks: 1,
      branchCompletionRate: 25.0,
      branchVerificationRate: 100.0,
      employeeActivities: activities,
      topPerformers: [],
      needsAttention: activities,
    );
  }
  
  /// ============================================================
  /// 🎯 ALL ACTIVITIES (For Owner & PIC)
  /// ============================================================
  
  static List<EmployeeJobDeskActivity> getAllActivities() {
    return [
      ...getCabangPusatActivities(),
      ...getCabangSelatanActivities(),
      ...getCabangUtaraActivities(),
      ...getCabangBaratActivities(),
    ];
  }
  
  static List<BranchJobDeskSummary> getAllBranchSummaries() {
    return [
      getCabangPusatSummary(),
      getCabangSelatanSummary(),
      getCabangUtaraSummary(),
      getCabangBaratSummary(),
    ];
  }
  
  /// ============================================================
  /// 📈 DAILY REPORT
  /// ============================================================
  
  static DailyJobDeskReport getDailyReport(String generatedBy) {
    final allActivities = getAllActivities();
    final branchSummaries = getAllBranchSummaries();
    
    final totalTasks = allActivities.fold(0, (sum, a) => sum + a.totalTasks);
    final completedTasks = allActivities.fold(0, (sum, a) => sum + a.completedTasks);
    final verifiedTasks = allActivities.fold(0, (sum, a) => sum + a.verifiedTasks);
    
    return DailyJobDeskReport(
      date: DateTime.now(),
      generatedBy: generatedBy,
      generatedAt: DateTime.now(),
      totalBranches: 4,
      totalEmployees: 10,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      verifiedTasks: verifiedTasks,
      overallCompletionRate: totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0,
      overallVerificationRate: completedTasks > 0 ? (verifiedTasks / completedTasks) * 100 : 0,
      branchSummaries: branchSummaries,
      roleStats: _generateRoleStats(allActivities),
      alerts: _generateAlerts(allActivities),
    );
  }
  
  /// ============================================================
  /// 🔧 HELPER METHODS
  /// ============================================================
  
  static Map<String, RoleActivityStats> _generateRoleStats(List<EmployeeJobDeskActivity> activities) {
    final roles = ['Support Online', 'Sales', 'Admin', 'Driver'];
    final Map<String, RoleActivityStats> stats = {};
    
    for (final role in roles) {
      final roleActivities = activities.where((a) => a.role == role).toList();
      if (roleActivities.isNotEmpty) {
        final totalTasks = roleActivities.fold(0, (sum, a) => sum + a.totalTasks);
        final completedTasks = roleActivities.fold(0, (sum, a) => sum + a.completedTasks);
        final verifiedTasks = roleActivities.fold(0, (sum, a) => sum + a.verifiedTasks);
        final avgScore = roleActivities
            .where((a) => a.dailyScore != null)
            .fold(0, (sum, a) => sum + (a.dailyScore ?? 0)) / 
            roleActivities.where((a) => a.dailyScore != null).length;
        
        stats[role] = RoleActivityStats(
          roleName: role,
          employeeCount: roleActivities.length,
          totalTasks: totalTasks,
          completedTasks: completedTasks,
          verifiedTasks: verifiedTasks,
          completionRate: totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0,
          avgScore: avgScore.isNaN ? 0 : avgScore,
        );
      }
    }
    
    return stats;
  }
  
  static List<ActivityAlert> _generateAlerts(List<EmployeeJobDeskActivity> activities) {
    final List<ActivityAlert> alerts = [];
    final today = DateTime.now();
    
    for (final activity in activities) {
      // No activity alert
      if (activity.completedTasks == 0) {
        alerts.add(ActivityAlert(
          id: 'alert_no_${activity.userId}',
          type: AlertType.noActivity,
          title: 'Tidak Ada Aktivitas',
          description: '${activity.userName} belum submit task hari ini',
          employeeId: activity.userId,
          employeeName: activity.userName,
          branchId: activity.branchId,
          branchName: activity.branchName,
          createdAt: today,
        ));
      }
      
      // Low completion alert
      if (activity.completionRate < 50 && activity.completedTasks > 0) {
        alerts.add(ActivityAlert(
          id: 'alert_low_${activity.userId}',
          type: AlertType.lowCompletion,
          title: 'Completion Rate Rendah',
          description: '${activity.userName} hanya menyelesaikan ${activity.completionRate.toStringAsFixed(0)}% task',
          employeeId: activity.userId,
          employeeName: activity.userName,
          branchId: activity.branchId,
          branchName: activity.branchName,
          createdAt: today,
        ));
      }
      
      // Pending verification
      if (activity.needsVerification) {
        alerts.add(ActivityAlert(
          id: 'alert_verif_${activity.userId}',
          type: AlertType.pendingVerification,
          title: 'Menunggu Verifikasi',
          description: '${activity.userName} memiliki ${activity.completedTasks - activity.verifiedTasks} task yang perlu diverifikasi',
          employeeId: activity.userId,
          employeeName: activity.userName,
          branchId: activity.branchId,
          branchName: activity.branchName,
          createdAt: today,
        ));
      }
      
      // Excellent performance
      if (activity.completionRate == 100 && activity.verifiedTasks == activity.totalTasks) {
        alerts.add(ActivityAlert(
          id: 'alert_exc_${activity.userId}',
          type: AlertType.excellentPerformance,
          title: 'Performa Luar Biasa',
          description: '${activity.userName} mencapai 100% completion dengan verifikasi sempurna!',
          employeeId: activity.userId,
          employeeName: activity.userName,
          branchId: activity.branchId,
          branchName: activity.branchName,
          createdAt: today,
        ));
      }
    }
    
    return alerts;
  }
  
  /// ============================================================
  /// 📝 SUBMISSION GENERATORS
  /// ============================================================
  
  static List<TaskSubmissionDetail> _generateExcellentSubmissions() {
    return [
      TaskSubmissionDetail(
        submissionId: 'sub_001',
        taskItemId: 'task_001',
        taskName: 'Kirim 200 Undangan',
        taskType: JobDeskTaskType.counter,
        status: JobDeskStatus.verified,
        actualValue: 215,
        targetValue: 200,
        targetUnit: 'orang',
        proofPhotos: ['photo1.jpg', 'photo2.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 3)),
        verifiedAt: DateTime.now().subtract(Duration(hours: 1)),
        verifiedBy: 'PIC Cabang',
        score: 95,
        picComment: 'Melebihi target, sangat baik!',
      ),
      TaskSubmissionDetail(
        submissionId: 'sub_002',
        taskItemId: 'task_002',
        taskName: 'Upload Foto Promosi',
        taskType: JobDeskTaskType.photo,
        status: JobDeskStatus.verified,
        proofPhotos: ['promo1.jpg', 'promo2.jpg', 'promo3.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 4)),
        verifiedAt: DateTime.now().subtract(Duration(hours: 2)),
        verifiedBy: 'PIC Cabang',
        score: 90,
        picComment: 'Foto berkualitas baik',
      ),
    ];
  }
  
  static List<TaskSubmissionDetail> _generateGoodSubmissions() {
    return [
      TaskSubmissionDetail(
        submissionId: 'sub_003',
        taskItemId: 'task_003',
        taskName: 'Kirim 200 Undangan',
        taskType: JobDeskTaskType.counter,
        status: JobDeskStatus.verified,
        actualValue: 180,
        targetValue: 200,
        targetUnit: 'orang',
        proofPhotos: ['photo1.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 5)),
        verifiedAt: DateTime.now().subtract(Duration(hours: 3)),
        verifiedBy: 'PIC Cabang',
        score: 85,
        picComment: 'Bagus, hampir mencapai target',
      ),
      TaskSubmissionDetail(
        submissionId: 'sub_004',
        taskItemId: 'task_004',
        taskName: 'Input Data Pelanggan',
        taskType: JobDeskTaskType.text,
        status: JobDeskStatus.completed,
        notes: 'Data 50 pelanggan baru',
        submittedAt: DateTime.now().subtract(Duration(hours: 4)),
      ),
    ];
  }
  
  static List<TaskSubmissionDetail> _generateAverageSubmissions() {
    return [
      TaskSubmissionDetail(
        submissionId: 'sub_005',
        taskItemId: 'task_005',
        taskName: 'Kirim 200 Undangan',
        taskType: JobDeskTaskType.counter,
        status: JobDeskStatus.verified,
        actualValue: 120,
        targetValue: 200,
        targetUnit: 'orang',
        proofPhotos: ['photo1.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 6)),
        verifiedAt: DateTime.now().subtract(Duration(hours: 4)),
        verifiedBy: 'PIC Cabang',
        score: 70,
        picComment: 'Perlu meningkatkan jumlah',
      ),
    ];
  }
  
  static List<TaskSubmissionDetail> _generateBelowTargetSubmissions() {
    return [
      TaskSubmissionDetail(
        submissionId: 'sub_006',
        taskItemId: 'task_006',
        taskName: 'Kirim 200 Undangan',
        taskType: JobDeskTaskType.counter,
        status: JobDeskStatus.verified,
        actualValue: 50,
        targetValue: 200,
        targetUnit: 'orang',
        proofPhotos: ['photo1.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 8)),
        verifiedAt: DateTime.now().subtract(Duration(hours: 6)),
        verifiedBy: 'PIC Cabang',
        score: 55,
        picComment: 'Perlu perhatian, jauh dari target',
      ),
    ];
  }
  
  static List<TaskSubmissionDetail> _generatePendingVerificationSubmissions() {
    return [
      TaskSubmissionDetail(
        submissionId: 'sub_007',
        taskItemId: 'task_007',
        taskName: 'Kirim 200 Undangan',
        taskType: JobDeskTaskType.counter,
        status: JobDeskStatus.completed,
        actualValue: 220,
        targetValue: 200,
        targetUnit: 'orang',
        proofPhotos: ['photo1.jpg', 'photo2.jpg', 'photo3.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 1)),
      ),
      TaskSubmissionDetail(
        submissionId: 'sub_008',
        taskItemId: 'task_008',
        taskName: 'Upload Video Promosi',
        taskType: JobDeskTaskType.link,
        status: JobDeskStatus.completed,
        proofLink: 'https://tiktok.com/@user/video123',
        submittedAt: DateTime.now().subtract(Duration(minutes: 30)),
      ),
    ];
  }
  
  static List<TaskSubmissionDetail> _generateMixedSubmissions() {
    return [
      TaskSubmissionDetail(
        submissionId: 'sub_009',
        taskItemId: 'task_009',
        taskName: 'Kirim 200 Undangan',
        taskType: JobDeskTaskType.counter,
        status: JobDeskStatus.rejected,
        actualValue: 50,
        targetValue: 200,
        targetUnit: 'orang',
        proofPhotos: ['photo1.jpg'],
        submittedAt: DateTime.now().subtract(Duration(hours: 4)),
        rejectionReason: 'Bukti kurang jelas, perlu upload ulang',
        picComment: 'Foto blur, tidak bisa diverifikasi',
      ),
      TaskSubmissionDetail(
        submissionId: 'sub_010',
        taskItemId: 'task_010',
        taskName: 'Input Data Pelanggan',
        taskType: JobDeskTaskType.text,
        status: JobDeskStatus.verified,
        notes: 'Data lengkap',
        submittedAt: DateTime.now().subtract(Duration(hours: 3)),
        verifiedAt: DateTime.now().subtract(Duration(hours: 1)),
        verifiedBy: 'PIC Cabang',
        score: 80,
      ),
    ];
  }
}
