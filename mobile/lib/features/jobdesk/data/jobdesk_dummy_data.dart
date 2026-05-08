/// ============================================================
/// 📋 JOB DESK SYSTEM - DUMMY DATA
/// ============================================================
/// Data dummy untuk testing UI sebelum backend ready
/// ============================================================

import '../models/jobdesk_models.dart';

class JobDeskDummyData {
  
  /// ============================================================
  /// 🎯 PRE-DEFINED TEMPLATES
  /// ============================================================
  
  static final supportOnlineTemplate = JobDeskTemplate(
    id: 'tpl_support_online_001',
    role: 'support_online',
    name: 'Job Desk Support Online Harian',
    description: 'Tugas-tugas harian untuk tim Support Online',
    isActive: true,
    tasks: [
      JobDeskTaskItem(
        id: 'task_001',
        taskName: 'Update data pelamar',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 1,
        helpText: 'Update data pelamar yang masuk hari ini',
      ),
      JobDeskTaskItem(
        id: 'task_002',
        taskName: 'Broadcast minimal 200 orang',
        description: 'Kirim broadcast ke semua kontak',
        type: JobDeskTaskType.counter,
        requiresProof: true,
        proofType: JobDeskProofType.photo,
        targetValue: 200,
        targetUnit: 'orang',
        isMandatory: true,
        sortOrder: 2,
        helpText: 'Screenshot hasil broadcast sebagai bukti',
      ),
      JobDeskTaskItem(
        id: 'task_003',
        taskName: 'Mendapatkan 5 prospek per cabang per hari',
        type: JobDeskTaskType.counter,
        targetValue: 5,
        targetUnit: 'prospek',
        isMandatory: true,
        sortOrder: 3,
      ),
      JobDeskTaskItem(
        id: 'task_004',
        taskName: 'Mengurus alur sosmed yang ada',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 4,
      ),
      JobDeskTaskItem(
        id: 'task_005',
        taskName: 'Kenalan 5 orang per hari',
        type: JobDeskTaskType.counter,
        targetValue: 5,
        targetUnit: 'orang',
        isMandatory: true,
        sortOrder: 5,
      ),
      JobDeskTaskItem(
        id: 'task_006',
        taskName: 'TAMBAH KONTAK 5',
        description: 'Tambah minimal 5 kontak baru',
        type: JobDeskTaskType.counter,
        targetValue: 5,
        targetUnit: 'kontak',
        isMandatory: true,
        isHighlighted: true,
        sortOrder: 6,
        helpText: 'Pastikan kontak aktif dan valid',
      ),
      JobDeskTaskItem(
        id: 'task_007',
        taskName: 'IDG LKH harian',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 7,
      ),
      JobDeskTaskItem(
        id: 'task_008',
        taskName: 'Inisiatif/kegiatan tambahan',
        description: 'Tugas tambahan diluar job desk',
        type: JobDeskTaskType.text,
        isMandatory: false,
        sortOrder: 8,
        helpText: 'Ceritakan kegiatan tambahan yang dilakukan',
      ),
      JobDeskTaskItem(
        id: 'task_009',
        taskName: 'Share postingan ke lebih dari 100 grup',
        type: JobDeskTaskType.counter,
        targetValue: 100,
        targetUnit: 'grup',
        isMandatory: true,
        sortOrder: 9,
      ),
      JobDeskTaskItem(
        id: 'task_010',
        taskName: 'SS WA ke Ko Iwan atau team pusat',
        description: 'SS bukti kalian care/peduli untuk kemajuan bersama ke pimpinan',
        type: JobDeskTaskType.photo,
        requiresProof: true,
        proofType: JobDeskProofType.screenshot,
        isMandatory: true,
        sortOrder: 10,
      ),
      JobDeskTaskItem(
        id: 'task_011',
        taskName: 'WA Bomber sehari 3x share',
        type: JobDeskTaskType.counter,
        targetValue: 3,
        targetUnit: 'share',
        isMandatory: true,
        sortOrder: 11,
      ),
      JobDeskTaskItem(
        id: 'task_012',
        taskName: 'Upload video konten di TikTok setiap hari',
        type: JobDeskTaskType.link,
        requiresProof: true,
        proofType: JobDeskProofType.link,
        isMandatory: true,
        sortOrder: 12,
        helpText: 'Paste link video TikTok yang diupload',
      ),
      JobDeskTaskItem(
        id: 'task_013',
        taskName: 'Live TikTok minimal sejam sehari',
        type: JobDeskTaskType.counter,
        targetValue: 1,
        targetUnit: 'jam',
        isMandatory: true,
        sortOrder: 13,
      ),
      JobDeskTaskItem(
        id: 'task_014',
        taskName: 'Ucapan ulang tahun ke konsumen',
        description: 'Mengucapkan selamat ulang tahun ke semua konsumen sesuai data ulang tahun setiap hari',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 14,
      ),
    ],
  );
  
  static final salesTemplate = JobDeskTemplate(
    id: 'tpl_sales_001',
    role: 'sales',
    name: 'Job Desk Sales Harian',
    tasks: [
      JobDeskTaskItem(
        id: 'sales_001',
        taskName: 'Follow-up 10 prospek hari ini',
        type: JobDeskTaskType.counter,
        targetValue: 10,
        targetUnit: 'prospek',
        isMandatory: true,
        sortOrder: 1,
      ),
      JobDeskTaskItem(
        id: 'sales_002',
        taskName: 'Kunjungan ke 3 calon customer',
        type: JobDeskTaskType.counter,
        requiresProof: true,
        proofType: JobDeskProofType.photo,
        targetValue: 3,
        targetUnit: 'kunjungan',
        isMandatory: true,
        sortOrder: 2,
      ),
      JobDeskTaskItem(
        id: 'sales_003',
        taskName: 'Input data prospek ke sistem',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 3,
      ),
      JobDeskTaskItem(
        id: 'sales_004',
        taskName: 'Update pipeline penjualan',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 4,
      ),
      JobDeskTaskItem(
        id: 'sales_005',
        taskName: 'Laporan harian sales',
        type: JobDeskTaskType.document,
        requiresProof: true,
        proofType: JobDeskProofType.document,
        isMandatory: true,
        sortOrder: 5,
      ),
    ],
  );
  
  static final driverTemplate = JobDeskTemplate(
    id: 'tpl_driver_001',
    role: 'driver',
    name: 'Job Desk Driver Harian',
    tasks: [
      JobDeskTaskItem(
        id: 'driver_001',
        taskName: 'Check kendaraan pagi',
        type: JobDeskTaskType.photo,
        requiresProof: true,
        proofType: JobDeskProofType.photo,
        isMandatory: true,
        sortOrder: 1,
      ),
      JobDeskTaskItem(
        id: 'driver_002',
        taskName: 'Check kendaraan sore',
        type: JobDeskTaskType.photo,
        requiresProof: true,
        proofType: JobDeskProofType.photo,
        isMandatory: true,
        sortOrder: 2,
      ),
      JobDeskTaskItem(
        id: 'driver_003',
        taskName: 'Deliver 5 pesanan hari ini',
        type: JobDeskTaskType.counter,
        targetValue: 5,
        targetUnit: 'pesanan',
        isMandatory: true,
        sortOrder: 3,
      ),
      JobDeskTaskItem(
        id: 'driver_004',
        taskName: 'Update status pengiriman real-time',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 4,
      ),
      JobDeskTaskItem(
        id: 'driver_005',
        taskName: 'Laporan pengiriman harian',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 5,
      ),
    ],
  );
  
  static final adminTemplate = JobDeskTemplate(
    id: 'tpl_admin_001',
    role: 'admin',
    name: 'Job Desk Admin Harian',
    tasks: [
      JobDeskTaskItem(
        id: 'admin_001',
        taskName: 'Stok check pagi',
        type: JobDeskTaskType.photo,
        requiresProof: true,
        proofType: JobDeskProofType.photo,
        isMandatory: true,
        sortOrder: 1,
      ),
      JobDeskTaskItem(
        id: 'admin_002',
        taskName: 'Input transaksi harian',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 2,
      ),
      JobDeskTaskItem(
        id: 'admin_003',
        taskName: 'Rekonsiliasi kasir',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 3,
      ),
      JobDeskTaskItem(
        id: 'admin_004',
        taskName: 'Laporan harian admin',
        type: JobDeskTaskType.checkbox,
        isMandatory: true,
        sortOrder: 4,
      ),
    ],
  );
  
  /// ============================================================
  /// 📊 DUMMY TEMPLATES LIST
  /// ============================================================
  
  static List<JobDeskTemplate> get allTemplates => [
    supportOnlineTemplate,
    salesTemplate,
    driverTemplate,
    adminTemplate,
  ];
  
  static JobDeskTemplate getTemplateByRole(String role) {
    switch (role) {
      case 'support_online':
        return supportOnlineTemplate;
      case 'sales':
        return salesTemplate;
      case 'driver':
        return driverTemplate;
      case 'admin':
        return adminTemplate;
      default:
        return supportOnlineTemplate;
    }
  }
  
  /// ============================================================
  /// 📝 DUMMY SUBMISSIONS (Untuk testing history)
  /// ============================================================
  
  static List<JobDeskSubmission> getDummySubmissionsForToday(JobDeskTemplate template) {
    return template.tasks.map((task) {
      // Random status untuk demo
      final isCompleted = task.sortOrder % 3 != 0; // 2/3 completed
      
      return JobDeskSubmission(
        id: 'sub_${task.id}_${DateTime.now().millisecondsSinceEpoch}',
        assignmentId: 'assign_001',
        taskItemId: task.id,
        submissionDate: DateTime.now(),
        status: isCompleted ? JobDeskStatus.completed : JobDeskStatus.pending,
        actualValue: task.type == JobDeskTaskType.counter && isCompleted
            ? task.targetValue
            : null,
        notes: isCompleted && task.type == JobDeskTaskType.text
            ? 'Sudah selesai dengan baik'
            : null,
        taskItem: task,
      );
    }).toList();
  }
  
  /// ============================================================
  /// 👤 DUMMY EMPLOYEE SUMMARIES (Untuk monitoring)
  /// ============================================================
  
  static List<JobDeskEmployeeSummary> getDummyEmployeeSummaries() {
    return [
      JobDeskEmployeeSummary(
        userId: 'emp_001',
        userName: 'Ahmad Santoso',
        role: 'Support Online',
        branchName: 'Cabang Pusat',
        totalTasks: 14,
        completedToday: 12,
        pendingToday: 2,
        completionRate: 85.7,
        streakDays: 5,
        lastSubmission: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      JobDeskEmployeeSummary(
        userId: 'emp_002',
        userName: 'Budi Wijaya',
        role: 'Sales',
        branchName: 'Cabang Pusat',
        totalTasks: 5,
        completedToday: 4,
        pendingToday: 1,
        completionRate: 80.0,
        streakDays: 3,
        lastSubmission: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      JobDeskEmployeeSummary(
        userId: 'emp_003',
        userName: 'Citra Dewi',
        role: 'Support Online',
        branchName: 'Cabang Selatan',
        totalTasks: 14,
        completedToday: 14,
        pendingToday: 0,
        completionRate: 100.0,
        streakDays: 12,
        lastSubmission: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      JobDeskEmployeeSummary(
        userId: 'emp_004',
        userName: 'Dedi Kurniawan',
        role: 'Driver',
        branchName: 'Cabang Pusat',
        totalTasks: 5,
        completedToday: 3,
        pendingToday: 2,
        completionRate: 60.0,
        streakDays: 1,
        lastSubmission: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }
  
  /// ============================================================
  /// ✅ DUMMY VERIFICATION QUEUE (Untuk Kepala Cabang)
  /// ============================================================
  
  static List<JobDeskVerificationQueueItem> getDummyVerificationQueue() {
    return [
      JobDeskVerificationQueueItem(
        submissionId: 'sub_001',
        userId: 'emp_001',
        userName: 'Ahmad Santoso',
        userAvatar: 'A',
        submissionDate: DateTime.now(),
        submittedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        taskName: 'Broadcast minimal 200 orang',
        taskType: JobDeskTaskType.counter,
        actualValue: 215,
        notes: 'Alhamdulillah target tercapai',
        totalProofs: 2,
      ),
      JobDeskVerificationQueueItem(
        submissionId: 'sub_002',
        userId: 'emp_002',
        userName: 'Budi Wijaya',
        userAvatar: 'B',
        submissionDate: DateTime.now(),
        submittedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        taskName: 'Kunjungan ke 3 calon customer',
        taskType: JobDeskTaskType.photo,
        actualValue: 3,
        totalProofs: 4,
      ),
      JobDeskVerificationQueueItem(
        submissionId: 'sub_003',
        userId: 'emp_003',
        userName: 'Citra Dewi',
        userAvatar: 'C',
        submissionDate: DateTime.now(),
        submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
        taskName: 'Upload video konten di TikTok',
        taskType: JobDeskTaskType.link,
        proofLink: 'https://tiktok.com/@citra/video/123456',
        totalProofs: 1,
      ),
    ];
  }
}
