/// ============================================================
/// 📊 JOB DESK SCORING DUMMY DATA
/// ============================================================
/// Data dummy untuk testing PIC verification & scoring
/// ============================================================

import 'package:flutter/material.dart';
import '../models/jobdesk_scoring_models.dart';
import '../models/jobdesk_models.dart' hide JobDeskVerificationQueueItem;

class JobDeskScoringDummyData {
  
  /// ============================================================
  /// 🎯 VERIFICATION QUEUE (Untuk PIC Dashboard)
  /// ============================================================
  
  static List<JobDeskVerificationQueueItem> getVerificationQueue() {
    return [
      // URGENT - Completion rendah, deadline dekat
      JobDeskVerificationQueueItem(
        submissionId: 'sub_001',
        userId: 'emp_004',
        userName: 'Dedi Kurniawan',
        userAvatar: 'D',
        role: 'Driver',
        branchName: 'Cabang Pusat',
        taskName: 'Check kendaraan pagi',
        submittedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        completionRate: 40, // Rendah
        priority: VerificationPriority.urgent,
        pendingTasks: 3,
        hasPhoto: true,
        photoUrls: ['https://example.com/photo1.jpg'],
        notes: 'Sudah check tadi pagi pak',
        autoScore: 50,
        taskDescription: 'Foto kendaraan sebelum berangkat',
      ),
      
      // HIGH - Completion menengah
      JobDeskVerificationQueueItem(
        submissionId: 'sub_002',
        userId: 'emp_002',
        userName: 'Budi Wijaya',
        userAvatar: 'B',
        role: 'Sales',
        branchName: 'Cabang Pusat',
        taskName: 'Kunjungan customer',
        submittedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        completionRate: 60,
        priority: VerificationPriority.high,
        pendingTasks: 2,
        hasPhoto: true,
        photoUrls: ['https://example.com/visit1.jpg', 'https://example.com/visit2.jpg'],
        notes: '3 kunjungan hari ini',
        autoScore: 75,
        targetValue: 3,
        actualValue: 3,
        taskDescription: 'Foto saat kunjungan ke customer',
      ),
      
      // NORMAL - Standard
      JobDeskVerificationQueueItem(
        submissionId: 'sub_003',
        userId: 'emp_001',
        userName: 'Ahmad Santoso',
        userAvatar: 'A',
        role: 'Support Online',
        branchName: 'Cabang Pusat',
        taskName: 'Broadcast minimal 200 orang',
        submittedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        completionRate: 85,
        priority: VerificationPriority.normal,
        pendingTasks: 2,
        hasPhoto: true,
        photoUrls: ['https://example.com/broadcast.jpg'],
        notes: 'Alhamdulillah target tercapai 215 orang',
        autoScore: 90,
        targetValue: 200,
        actualValue: 215,
        taskDescription: 'Screenshot hasil broadcast',
      ),
      
      // LOW - Sudah lengkap
      JobDeskVerificationQueueItem(
        submissionId: 'sub_004',
        userId: 'emp_003',
        userName: 'Citra Dewi',
        userAvatar: 'C',
        role: 'Support Online',
        branchName: 'Cabang Selatan',
        taskName: 'Upload video TikTok',
        submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
        completionRate: 100,
        priority: VerificationPriority.low,
        pendingTasks: 0,
        hasPhoto: false,
        photoUrls: null,
        notes: 'Link: https://tiktok.com/@citra/video/123',
        autoScore: 100,
        taskDescription: 'Paste link video TikTok',
      ),
      
      // Another URGENT
      JobDeskVerificationQueueItem(
        submissionId: 'sub_005',
        userId: 'emp_005',
        userName: 'Eka Putri',
        userAvatar: 'E',
        role: 'Admin',
        branchName: 'Cabang Selatan',
        taskName: 'Stok check pagi',
        submittedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        completionRate: 25,
        priority: VerificationPriority.urgent,
        pendingTasks: 4,
        hasPhoto: true,
        photoUrls: ['https://example.com/stok.jpg'],
        notes: 'Stok lengkap',
        autoScore: 40,
        taskDescription: 'Foto stok barang pagi hari',
      ),
    ];
  }
  
  /// ============================================================
  /// 📊 DAILY RECAP (Setelah 09:00 WITA)
  /// ============================================================
  
  static JobDeskDailyRecap getDailyRecap(DateTime date) {
    final scores = [
      JobDeskEmployeeScore(
        userId: 'emp_003',
        userName: 'Citra Dewi',
        userAvatar: 'C',
        role: 'Support Online',
        totalScore: 96,
        taskScores: {
          'task_001': 100,
          'task_002': 100,
          'task_003': 100,
          'task_004': 100,
          'task_005': 90,
          'task_006': 100,
          'task_007': 100,
          'task_008': 100,
          'task_009': 100,
          'task_010': 100,
          'task_011': 100,
          'task_012': 100,
          'task_013': 90,
          'task_014': 100,
        },
        overallComment: 'Excellent performance, tingkatkan konsistensi live TikTok',
        isVerified: true,
        verifiedBy: 'Pak Iwan (PIC)',
        verifiedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        rank: 1,
        grade: 'A',
        completionRate: 100,
        hasPhotoProof: true,
      ),
      
      JobDeskEmployeeScore(
        userId: 'emp_001',
        userName: 'Ahmad Santoso',
        userAvatar: 'A',
        role: 'Support Online',
        totalScore: 88,
        taskScores: {
          'task_001': 90,
          'task_002': 95,
          'task_003': 85,
          'task_004': 90,
          'task_005': 80,
          'task_006': 85,
          'task_007': 90,
          'task_008': 100,
          'task_009': 90,
          'task_010': 85,
          'task_011': 90,
          'task_012': 85,
          'task_013': 80,
          'task_014': 90,
        },
        overallComment: 'Good job, perbaiki SS WA yang kurang jelas',
        isVerified: true,
        verifiedBy: 'Pak Iwan (PIC)',
        verifiedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        rank: 2,
        grade: 'B',
        completionRate: 90,
        hasPhotoProof: true,
      ),
      
      JobDeskEmployeeScore(
        userId: 'emp_002',
        userName: 'Budi Wijaya',
        userAvatar: 'B',
        role: 'Sales',
        totalScore: 82,
        taskScores: {
          'sales_001': 85,
          'sales_002': 80,
          'sales_003': 85,
          'sales_004': 80,
          'sales_005': 85,
        },
        overallComment: 'Kunjungan kurang dokumentasi foto',
        isVerified: true,
        verifiedBy: 'Pak Iwan (PIC)',
        verifiedAt: DateTime.now().subtract(const Duration(minutes: 50)),
        rank: 3,
        grade: 'B',
        completionRate: 80,
        hasPhotoProof: true,
      ),
      
      JobDeskEmployeeScore(
        userId: 'emp_004',
        userName: 'Dedi Kurniawan',
        userAvatar: 'D',
        role: 'Driver',
        totalScore: 68,
        taskScores: {
          'driver_001': 70,
          'driver_002': 0, // Tidak submit
          'driver_003': 85,
          'driver_004': 80,
          'driver_005': 85,
        },
        overallComment: 'PERLU PERHATIAN: Check sore tidak disubmit',
        isVerified: true,
        verifiedBy: 'Pak Iwan (PIC)',
        verifiedAt: DateTime.now().subtract(const Duration(minutes: 20)),
        rank: 4,
        grade: 'C',
        completionRate: 60,
        hasPhotoProof: true,
      ),
      
      JobDeskEmployeeScore(
        userId: 'emp_005',
        userName: 'Eka Putri',
        userAvatar: 'E',
        role: 'Admin',
        totalScore: 55,
        taskScores: {
          'admin_001': 60,
          'admin_002': 50,
          'admin_003': 60,
          'admin_004': 50,
        },
        overallComment: 'Sangat perlu perbaikan, ada kendala apa?',
        isVerified: true,
        verifiedBy: 'Pak Iwan (PIC)',
        verifiedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        rank: 5,
        grade: 'D',
        completionRate: 50,
        hasPhotoProof: false,
      ),
    ];
    
    return JobDeskDailyRecap(
      id: 'recap_${date.year}${date.month}${date.day}',
      date: date,
      branchId: 'branch_001',
      employeeScores: scores,
      generatedAt: DateTime.now(),
      isFinal: true,
      generatedBy: 'System (09:00 WITA)',
    );
  }
  
  /// ============================================================
  /// ⏰ CUTOFF CONFIG
  /// ============================================================
  
  static JobDeskCutoffConfig getDefaultConfig() {
    return JobDeskCutoffConfig.defaultConfig;
  }
  
  static List<JobDeskCutoffConfig> getBranchConfigs() {
    return [
      JobDeskCutoffConfig.defaultConfig,
      JobDeskCutoffConfig(
        id: 'branch_002',
        branchId: 'branch_002',
        cutoffTime: const TimeOfDay(hour: 8, minute: 30),
        dayStartTime: const TimeOfDay(hour: 8, minute: 30),
        timezone: 'WIB', // Cabang di Kalimantan
        allowLateSubmission: true,
        lateSubmissionGraceMinutes: 30,
      ),
    ];
  }
  
  /// ============================================================
  /// 🔒 LOCK STATUS EXAMPLES
  /// ============================================================
  
  static JobDeskLockStatus getLockedStatus(DateTime date) {
    return JobDeskLockStatus(
      date: date,
      isLocked: true,
      lockTime: const TimeOfDay(hour: 9, minute: 0),
      unlockTime: const TimeOfDay(hour: 9, minute: 0),
      canSubmit: false,
      canEdit: true, // PIC masih bisa edit
      lockedBy: 'system',
      reason: 'Cutoff time reached (09:00 WITA)',
      isEmergencyUnlock: false,
    );
  }
  
  static JobDeskLockStatus getUnlockedStatus(DateTime date) {
    return JobDeskLockStatus(
      date: date,
      isLocked: false,
      unlockTime: const TimeOfDay(hour: 9, minute: 0),
      lockTime: null,
      canSubmit: true,
      canEdit: false,
      lockedBy: null,
      reason: 'Day is open for submissions',
      isEmergencyUnlock: false,
    );
  }
  
  static JobDeskLockStatus getEmergencyUnlockedStatus(DateTime date) {
    return JobDeskLockStatus(
      date: date,
      isLocked: false,
      unlockTime: const TimeOfDay(hour: 10, minute: 30),
      lockTime: const TimeOfDay(hour: 9, minute: 0),
      canSubmit: true,
      canEdit: true,
      lockedBy: 'pak_iwan',
      reason: 'Override untuk karyawan yang sakit pagi ini',
      isEmergencyUnlock: true,
    );
  }
  
  /// ============================================================
  /// 📝 EDIT HISTORY EXAMPLES
  /// ============================================================
  
  static List<JobDeskScoreEditHistory> getEditHistory() {
    return [
      JobDeskScoreEditHistory(
        id: 'edit_001',
        scoreId: 'score_001',
        submissionId: 'sub_001',
        editedBy: 'pak_iwan',
        editedByName: 'Pak Iwan (PIC)',
        editedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        oldScore: 70,
        newScore: 88,
        reason: 'Re-evaluasi: Ternyata broadcast sudah melebihi target',
        oldComment: 'Target belum tercapai',
        newComment: 'Good job, target tercapai 215/200',
        notifiedEmployee: true,
      ),
      
      JobDeskScoreEditHistory(
        id: 'edit_002',
        scoreId: 'score_002',
        submissionId: 'sub_002',
        editedBy: 'pak_iwan',
        editedByName: 'Pak Iwan (PIC)',
        editedAt: DateTime.now().subtract(const Duration(hours: 2)),
        oldScore: 90,
        newScore: 82,
        reason: 'Dokumentasi foto kurang lengkap, hanya ada 2 dari 3 kunjungan',
        oldComment: 'Kunjungan lengkap',
        newComment: 'Kunjungan kurang dokumentasi foto',
        notifiedEmployee: true,
      ),
      
      JobDeskScoreEditHistory(
        id: 'edit_003',
        scoreId: 'score_003',
        submissionId: 'sub_003',
        editedBy: 'ibu_maria',
        editedByName: 'Ibu Maria (Owner)',
        editedAt: DateTime.now().subtract(const Duration(hours: 5)),
        oldScore: 65,
        newScore: 82,
        reason: 'Koreksi kesalahan input PIC',
        oldComment: null,
        newComment: 'Dikoreksi oleh Owner',
        notifiedEmployee: true,
      ),
    ];
  }
  
  /// ============================================================
  /// 📸 PHOTO REVIEW SESSION
  /// ============================================================
  
  static PhotoReviewSession getPhotoReviewSession() {
    return PhotoReviewSession(
      submissionId: 'sub_001',
      userId: 'emp_001',
      taskName: 'Broadcast minimal 200 orang',
      photoUrls: [
        'https://example.com/broadcast1.jpg',
        'https://example.com/broadcast2.jpg',
        'https://example.com/broadcast3.jpg',
      ],
      currentPhotoIndex: 0,
      score: null,
      comment: null,
      annotations: {
        0: PhotoAnnotation(
          x: 0.3,
          y: 0.5,
          text: '215 terkirim',
          color: Colors.green,
          createdAt: DateTime.now(),
        ),
      },
      startedAt: DateTime.now(),
      completedAt: null,
    );
  }
  
  /// ============================================================
  /// 🔔 NOTIFICATIONS
  /// ============================================================
  
  static List<JobDeskNotification> getNotifications() {
    return [
      JobDeskNotification(
        id: 'notif_001',
        userId: 'emp_001',
        type: JobDeskNotificationType.cutoffWarning,
        title: '⏰ Perhatian! 1 jam lagi cutoff',
        message: 'Job desk hari ini akan dikunci pukul 09:00 WITA. Segera selesaikan tugas yang tersisa!',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
        relatedDate: DateTime.now().toIso8601String(),
      ),
      
      JobDeskNotification(
        id: 'notif_002',
        userId: 'emp_001',
        type: JobDeskNotificationType.scoreUpdated,
        title: '📝 Nilai diperbarui',
        message: 'PIC Pak Iwan mengubah nilai Anda dari 70 menjadi 88. Alasan: Re-evaluasi target tercapai',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        relatedSubmissionId: 'sub_001',
      ),
      
      JobDeskNotification(
        id: 'notif_003',
        userId: 'emp_001',
        type: JobDeskNotificationType.dayUnlocked,
        title: '✅ Hari baru dibuka!',
        message: 'Job desk untuk hari ini sudah bisa diisi. Semangat bekerja! 💪',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        relatedDate: DateTime.now().toIso8601String(),
      ),
      
      JobDeskNotification(
        id: 'notif_004',
        userId: 'emp_004',
        type: JobDeskNotificationType.revisionNeeded,
        title: '⚠️ Perlu revisi',
        message: 'Task "Check kendaraan sore" memerlukan revisi. Mohon upload foto yang lebih jelas.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        isRead: false,
        relatedSubmissionId: 'sub_001',
      ),
    ];
  }
}
