/// ============================================================
/// 📋 JOB DESK SYSTEM - DATA MODELS
/// ============================================================
/// 
/// Model-model untuk sistem job desk yang fleksibel.
/// Setiap role bisa memiliki template yang berbeda.
/// 
/// Author: TE SuperApp Team
/// Created: May 2026
/// 
/// ============================================================

import 'package:flutter/material.dart';

/// Task Type untuk jenis tugas
enum JobDeskTaskType {
  checkbox,      // Simple check/uncheck
  counter,       // Dengan target angka (200 orang, 5 kontak, etc)
  photo,         // Wajib upload foto
  document,      // Upload dokumen
  link,          // Input link (TikTok, etc)
  text,          // Input teks/catatan
}

/// Status submission
enum JobDeskStatus {
  pending,
  completed,
  verified,
  rejected,
}

/// ============================================================
/// 📝 JOB DESK TEMPLATE (Master Template per Role)
/// ============================================================
/// Template ini didefinisikan oleh Owner/Superadmin
/// dan bisa di-assign ke multiple karyawan
/// ============================================================

class JobDeskTemplate {
  final String id;
  final String role;              // 'support_online', 'sales', 'driver', 'admin'
  final String name;              // Nama template
  final String? description;
  final bool isActive;
  final List<JobDeskTaskItem> tasks;
  final DateTime? createdAt;
  final String? createdBy;        // user id
  
  JobDeskTemplate({
    required this.id,
    required this.role,
    required this.name,
    this.description,
    this.isActive = true,
    required this.tasks,
    this.createdAt,
    this.createdBy,
  });
  
  JobDeskTemplate copyWith({
    String? id,
    String? role,
    String? name,
    String? description,
    bool? isActive,
    List<JobDeskTaskItem>? tasks,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return JobDeskTemplate(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

/// ============================================================
/// ✅ JOB DESK TASK ITEM (Individual Task dalam Template)
/// ============================================================

class JobDeskTaskItem {
  final String id;
  final String taskName;          // Nama tugas
  final String? description;      // Deskripsi/detail
  final JobDeskTaskType type;     // Tipe tugas
  final bool requiresProof;       // Apakah perlu bukti?
  final JobDeskProofType? proofType; // Tipe bukti yang diperlukan
  final int? targetValue;         // Target angka (mis: 200)
  final String? targetUnit;       // Satuan (orang, kontak, grup, jam)
  final bool isMandatory;         // Wajib atau opsional
  final int sortOrder;            // Urutan tampilan
  final bool isHighlighted;       // Highlight khusus (kuning)
  final String? helpText;         // Petunjuk pengisian
  
  JobDeskTaskItem({
    required this.id,
    required this.taskName,
    this.description,
    this.type = JobDeskTaskType.checkbox,
    this.requiresProof = false,
    this.proofType,
    this.targetValue,
    this.targetUnit,
    this.isMandatory = true,
    this.sortOrder = 0,
    this.isHighlighted = false,
    this.helpText,
  });
  
  JobDeskTaskItem copyWith({
    String? id,
    String? taskName,
    String? description,
    JobDeskTaskType? type,
    bool? requiresProof,
    JobDeskProofType? proofType,
    int? targetValue,
    String? targetUnit,
    bool? isMandatory,
    int? sortOrder,
    bool? isHighlighted,
    String? helpText,
  }) {
    return JobDeskTaskItem(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      type: type ?? this.type,
      requiresProof: requiresProof ?? this.requiresProof,
      proofType: proofType ?? this.proofType,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      isMandatory: isMandatory ?? this.isMandatory,
      sortOrder: sortOrder ?? this.sortOrder,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      helpText: helpText ?? this.helpText,
    );
  }
}

/// ============================================================
/// 📸 PROOF TYPE
/// ============================================================

enum JobDeskProofType {
  photo,
  document,
  link,
  screenshot,
  none,
}

/// ============================================================
/// 👤 JOB DESK ASSIGNMENT (Template yang di-assign ke karyawan)
/// ============================================================

class JobDeskAssignment {
  final String id;
  final String userId;            // Karyawan yang di-assign
  final String templateId;        // Template yang di-assign
  final String assignedBy;        // Owner/Admin yang assign
  final DateTime assignedAt;
  final DateTime? validFrom;      // Mulai berlaku
  final DateTime? validUntil;     // Berakhir (null = ongoing)
  final bool isActive;
  final JobDeskTemplate? template; // Embedded template data
  
  JobDeskAssignment({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.assignedBy,
    required this.assignedAt,
    this.validFrom,
    this.validUntil,
    this.isActive = true,
    this.template,
  });
}

/// ============================================================
/// 📝 JOB DESK SUBMISSION (Hasil pengisian karyawan)
/// ============================================================

class JobDeskSubmission {
  final String id;
  final String assignmentId;
  final String taskItemId;      // Task mana yang di-submit
  final DateTime submissionDate;  // Tanggal pengisian
  JobDeskStatus status;
  final int? actualValue;         // Nilai aktual (untuk counter)
  final String? notes;            // Catatan karyawan
  final List<String>? proofPhotos;     // URL foto bukti
  final List<String>? proofDocuments;  // URL dokumen
  final String? proofLink;        // Link eksternal
  final DateTime? submittedAt;
  final String? verifiedBy;       // Verifier (Kepala Cabang/Admin)
  final DateTime? verifiedAt;
  final String? rejectionReason;
  
  // UI helper - not from DB
  final JobDeskTaskItem? taskItem;
  
  JobDeskSubmission({
    required this.id,
    required this.assignmentId,
    required this.taskItemId,
    required this.submissionDate,
    this.status = JobDeskStatus.pending,
    this.actualValue,
    this.notes,
    this.proofPhotos,
    this.proofDocuments,
    this.proofLink,
    this.submittedAt,
    this.verifiedBy,
    this.verifiedAt,
    this.rejectionReason,
    this.taskItem,
  });
  
  bool get isPending => status == JobDeskStatus.pending;
  bool get isCompleted => status == JobDeskStatus.completed;
  bool get isVerified => status == JobDeskStatus.verified;
  bool get isRejected => status == JobDeskStatus.rejected;
}

/// ============================================================
/// 📊 DAILY PROGRESS (Ringkasan harian)
/// ============================================================

class JobDeskDailyProgress {
  final DateTime date;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final double completionRate;
  final bool isAllVerified;
  
  JobDeskDailyProgress({
    required this.date,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.completionRate,
    this.isAllVerified = false,
  });
}

/// ============================================================
/// 📈 EMPLOYEE PROGRESS SUMMARY (Untuk monitoring)
/// ============================================================

class JobDeskEmployeeSummary {
  final String userId;
  final String userName;
  final String role;
  final String branchName;
  final int totalTasks;
  final int completedToday;
  final int pendingToday;
  final double completionRate;
  final int streakDays;           // Berapa hari berturut-turut lengkap
  final DateTime? lastSubmission;
  
  JobDeskEmployeeSummary({
    required this.userId,
    required this.userName,
    required this.role,
    required this.branchName,
    required this.totalTasks,
    required this.completedToday,
    required this.pendingToday,
    required this.completionRate,
    this.streakDays = 0,
    this.lastSubmission,
  });
}

/// ============================================================
/// 🎯 VERIFICATION QUEUE ITEM (Untuk Kepala Cabang)
/// ============================================================

class JobDeskVerificationQueueItem {
  final String submissionId;
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime submissionDate;
  final DateTime submittedAt;
  final String taskName;
  final JobDeskTaskType taskType;
  final int? actualValue;
  final String? notes;
  final List<String>? proofPhotos;
  final String? proofLink;
  final int totalProofs;
  
  JobDeskVerificationQueueItem({
    required this.submissionId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.submissionDate,
    required this.submittedAt,
    required this.taskName,
    required this.taskType,
    this.actualValue,
    this.notes,
    this.proofPhotos,
    this.proofLink,
    required this.totalProofs,
  });
}
