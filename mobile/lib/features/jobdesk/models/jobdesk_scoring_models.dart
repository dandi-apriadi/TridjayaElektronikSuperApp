/// ============================================================
/// ⭐ JOB DESK SCORING & VERIFICATION SYSTEM
/// ============================================================
/// Model untuk sistem penilaian PIC dengan cutoff 09:00 WITA
/// ============================================================

import 'package:flutter/material.dart';
import 'jobdesk_models.dart';

/// ============================================================
/// 📊 DAILY RECAP (Rekap Harian Jam 09:00)
/// ============================================================

class JobDeskDailyRecap {
  final String id;
  final DateTime date;
  final String branchId;
  final List<JobDeskEmployeeScore> employeeScores;
  final DateTime generatedAt;
  final bool isFinal;             // true setelah 09:00
  final String? generatedBy;
  
  JobDeskDailyRecap({
    required this.id,
    required this.date,
    required this.branchId,
    required this.employeeScores,
    required this.generatedAt,
    this.isFinal = false,
    this.generatedBy,
  });
  
  double get branchAverage {
    if (employeeScores.isEmpty) return 0;
    return employeeScores.fold(0.0, (sum, e) => sum + e.totalScore) / employeeScores.length;
  }
  
  List<JobDeskEmployeeScore> get rankedScores {
    final sorted = List<JobDeskEmployeeScore>.from(employeeScores);
    sorted.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return sorted.asMap().entries.map<JobDeskEmployeeScore>((e) {
      final score = e.value;
      return JobDeskEmployeeScore(
        userId: score.userId,
        userName: score.userName,
        role: score.role,
        totalScore: score.totalScore,
        taskScores: score.taskScores,
        overallComment: score.overallComment,
        isVerified: score.isVerified,
        verifiedBy: score.verifiedBy,
        verifiedAt: score.verifiedAt,
        rank: e.key + 1,
        grade: score.grade,
      );
    }).toList();
  }
}

class JobDeskEmployeeScore {
  final String userId;
  final String userName;
  final String? userAvatar;
  final String role;
  final int totalScore;           // 0-100
  final Map<String, int> taskScores; // task_id -> score
  final String? overallComment;
  final bool isVerified;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final int rank;                 // Peringkat hari itu
  final String? grade;            // A, B, C, D
  final int completionRate;       // 0-100
  final bool hasPhotoProof;
  
  JobDeskEmployeeScore({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.role,
    required this.totalScore,
    required this.taskScores,
    this.overallComment,
    this.isVerified = false,
    this.verifiedBy,
    this.verifiedAt,
    this.rank = 0,
    this.grade,
    this.completionRate = 0,
    this.hasPhotoProof = false,
  });
  
  String calculateGrade() {
    if (totalScore >= 90) return 'A';
    if (totalScore >= 80) return 'B';
    if (totalScore >= 70) return 'C';
    if (totalScore >= 60) return 'D';
    return 'E';
  }
}

/// ============================================================
/// 🎯 VERIFICATION PRIORITY (Prioritas Pengecekan PIC)
/// ============================================================

enum VerificationPriority {
  urgent,      // Merah - Deadline dekat atau completion rendah
  high,        // Orange - Perlu perhatian khusus
  normal,      // Kuning - Standard queue
  low,         // Hijau - Sudah lengkap, tinggal verifikasi
}

class JobDeskVerificationQueueItem {
  final String submissionId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String role;
  final String branchName;
  final String taskName;
  final DateTime submittedAt;
  final int completionRate;       // 0-100
  final VerificationPriority priority;
  final int pendingTasks;         // Task lain yang belum dicek
  final bool hasPhoto;
  final List<String>? photoUrls;
  final String? notes;
  final int autoScore;            // Score sementara dari sistem
  final String? taskDescription;
  final int? targetValue;         // Target yang harus dicapai
  final int? actualValue;         // Nilai aktual dari karyawan
  
  JobDeskVerificationQueueItem({
    required this.submissionId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.role,
    required this.branchName,
    required this.taskName,
    required this.submittedAt,
    required this.completionRate,
    required this.priority,
    required this.pendingTasks,
    required this.hasPhoto,
    this.photoUrls,
    this.notes,
    required this.autoScore,
    this.taskDescription,
    this.targetValue,
    this.actualValue,
  });
  
  Color get priorityColor {
    switch (priority) {
      case VerificationPriority.urgent:
        return const Color(0xFFE53935); // Red
      case VerificationPriority.high:
        return const Color(0xFFFF9800); // Orange
      case VerificationPriority.normal:
        return const Color(0xFFFFC107); // Yellow
      case VerificationPriority.low:
        return const Color(0xFF4CAF50); // Green
    }
  }
  
  String get priorityLabel {
    switch (priority) {
      case VerificationPriority.urgent:
        return 'URGENT';
      case VerificationPriority.high:
        return 'HIGH';
      case VerificationPriority.normal:
        return 'NORMAL';
      case VerificationPriority.low:
        return 'LOW';
    }
  }
}

/// ============================================================
/// ⏰ CUTOFF TIME CONFIGURATION
/// ============================================================

class JobDeskCutoffConfig {
  final String id;
  final String? branchId;         // null = default untuk semua
  final TimeOfDay cutoffTime;       // Default 09:00
  final TimeOfDay dayStartTime;     // Default 09:00 (setelah cutoff)
  final bool allowLateSubmission;   // Bisa override? (PIC only)
  final int lateSubmissionGraceMinutes; // Toleransi keterlambatan
  final bool isActive;
  final String timezone;            // 'WITA', 'WIB', 'WIT'
  
  JobDeskCutoffConfig({
    required this.id,
    this.branchId,
    required this.cutoffTime,
    required this.dayStartTime,
    this.allowLateSubmission = false,
    this.lateSubmissionGraceMinutes = 0,
    this.isActive = true,
    this.timezone = 'WITA',
  });
  
  static JobDeskCutoffConfig get defaultConfig => JobDeskCutoffConfig(
    id: 'default',
    cutoffTime: const TimeOfDay(hour: 9, minute: 0),
    dayStartTime: const TimeOfDay(hour: 9, minute: 0),
    timezone: 'WITA',
  );
  
  DateTime getCutoffDateTime(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      cutoffTime.hour,
      cutoffTime.minute,
    );
  }
  
  bool isBeforeCutoff(DateTime now, DateTime date) {
    final cutoff = getCutoffDateTime(date);
    return now.isBefore(cutoff);
  }
  
  Duration getTimeRemaining(DateTime now, DateTime date) {
    final cutoff = getCutoffDateTime(date);
    if (now.isAfter(cutoff)) return Duration.zero;
    return cutoff.difference(now);
  }
}

/// ============================================================
/// 🔒 SUBMISSION LOCK STATUS
/// ============================================================

class JobDeskLockStatus {
  final DateTime date;
  final bool isLocked;              // true = sudah lewat 09:00
  final TimeOfDay? unlockTime;      // Kapan hari itu dibuka
  final TimeOfDay? lockTime;        // Jam berapa dikunci
  final bool canSubmit;             // Apakah karyawan bisa submit
  final bool canEdit;               // Apakah PIC masih bisa edit
  final String? lockedBy;           // 'system' atau 'manual'
  final String? reason;             // Alasan lock/unlock
  final bool isEmergencyUnlock;     // PIC override
  
  JobDeskLockStatus({
    required this.date,
    required this.isLocked,
    this.unlockTime,
    this.lockTime,
    required this.canSubmit,
    required this.canEdit,
    this.lockedBy,
    this.reason,
    this.isEmergencyUnlock = false,
  });
  
  String get statusLabel {
    if (isEmergencyUnlock) return 'Unlocked (PIC)';
    if (isLocked) return 'Locked';
    return 'Open';
  }
  
  Color get statusColor {
    if (isEmergencyUnlock) return const Color(0xFFFF9800); // Orange
    if (isLocked) return const Color(0xFFE53935); // Red
    return const Color(0xFF4CAF50); // Green
  }
}

/// ============================================================
/// 📝 EDIT HISTORY (Tracking perubahan nilai)
/// ============================================================

class JobDeskScoreEditHistory {
  final String id;
  final String scoreId;
  final String submissionId;
  final String editedBy;
  final String editedByName;
  final DateTime editedAt;
  final int oldScore;
  final int newScore;
  final String reason;              // Wajib diisi
  final String? oldComment;
  final String? newComment;
  final bool notifiedEmployee;      // Apakah karyawan diberitahu
  
  JobDeskScoreEditHistory({
    required this.id,
    required this.scoreId,
    required this.submissionId,
    required this.editedBy,
    required this.editedByName,
    required this.editedAt,
    required this.oldScore,
    required this.newScore,
    required this.reason,
    this.oldComment,
    this.newComment,
    this.notifiedEmployee = false,
  });
}

/// ============================================================
/// 📸 PHOTO REVIEW SESSION
/// ============================================================

class PhotoReviewSession {
  final String submissionId;
  final String userId;
  final String taskName;
  final List<String> photoUrls;
  int currentPhotoIndex;
  int? score;                       // Score yang diberikan
  String? comment;
  final Map<int, PhotoAnnotation> annotations; // index -> annotation
  final DateTime startedAt;
  DateTime? completedAt;
  
  PhotoReviewSession({
    required this.submissionId,
    required this.userId,
    required this.taskName,
    required this.photoUrls,
    this.currentPhotoIndex = 0,
    this.score,
    this.comment,
    this.annotations = const {},
    required this.startedAt,
    this.completedAt,
  });
  
  bool get isComplete => score != null && completedAt != null;
  bool get hasNext => currentPhotoIndex < photoUrls.length - 1;
  bool get hasPrevious => currentPhotoIndex > 0;
  
  String get currentPhotoUrl => photoUrls[currentPhotoIndex];
  int get totalPhotos => photoUrls.length;
}

class PhotoAnnotation {
  final double x;                   // 0-1 (normalized)
  final double y;                   // 0-1 (normalized)
  final String text;
  final Color color;
  final DateTime createdAt;
  
  PhotoAnnotation({
    required this.x,
    required this.y,
    required this.text,
    required this.color,
    required this.createdAt,
  });
}

/// ============================================================
/// 🔔 NOTIFICATION TYPES (Untuk karyawan)
/// ============================================================

enum JobDeskNotificationType {
  cutoffWarning,      // Peringatan 1 jam sebelum 09:00
  cutoffLock,         // Notifikasi hari dikunci
  dayUnlocked,        // Hari baru dibuka
  scoreUpdated,       // Nilai diubah PIC
  revisionNeeded,     // Perlu revisi
  verificationComplete, // Sudah diverifikasi
}

class JobDeskNotification {
  final String id;
  final String userId;
  final JobDeskNotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedSubmissionId;
  final String? relatedDate;
  
  JobDeskNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.relatedSubmissionId,
    this.relatedDate,
  });
}
