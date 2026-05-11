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

  factory JobDeskTemplate.fromJson(Map<String, dynamic> json) {
    return JobDeskTemplate(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      isActive: json['is_active'] ?? true,
      tasks: (json['tasks'] as List? ?? [])
          .map((item) => JobDeskTaskItem.fromJson(item))
          .toList(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      createdBy: json['created_by'],
    );
  }

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

  factory JobDeskTaskItem.fromJson(Map<String, dynamic> json) {
    return JobDeskTaskItem(
      id: json['id'] ?? '',
      taskName: json['task_name'] ?? '',
      description: json['description'],
      type: JobDeskTaskType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'checkbox'),
        orElse: () => JobDeskTaskType.checkbox,
      ),
      requiresProof: json['requires_proof'] ?? false,
      proofType: json['proof_type'] != null
        ? JobDeskProofType.values.firstWhere(
            (e) => e.name == json['proof_type'],
            orElse: () => JobDeskProofType.none,
          )
        : null,
      targetValue: json['target_value'],
      targetUnit: json['target_unit'],
      isMandatory: json['is_mandatory'] ?? true,
      sortOrder: json['sort_order'] ?? 0,
      isHighlighted: json['is_highlighted'] ?? false,
      helpText: json['help_text'],
    );
  }

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
/// 👤 JOB DESK ASSIGNMENT (Daily task assigned to employee)
/// ============================================================

class JobDeskAssignment {
  final String id;
  final String userId;
  final String? templateId;
  final String? assignedBy;
  final DateTime? assignedAt;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool? isActive;
  final JobDeskTemplate? template;

  // Backend fields (daily task data)
  final String? title;
  final String? description;
  final String? status;           // assigned, submitted, approved, rejected
  final String? priority;         // low, normal, high, urgent
  final DateTime? assignedDate;
  final DateTime? dueDate;
  final String? submittedAt;
  final String? submittedNotes;
  final String? reviewerName;
  final String? reviewedAt;
  final String? reviewNotes;
  final String? rejectionReason;
  final bool hasAttachments;
  final String? employeeName;
  final String? divisionName;
  final String? branchName;
  final String? branchId;
  final String? templateTitle;

  JobDeskAssignment({
    required this.id,
    required this.userId,
    this.templateId,
    this.assignedBy,
    this.assignedAt,
    this.validFrom,
    this.validUntil,
    this.isActive,
    this.template,
    this.title,
    this.description,
    this.status,
    this.priority,
    this.assignedDate,
    this.dueDate,
    this.submittedAt,
    this.submittedNotes,
    this.reviewerName,
    this.reviewedAt,
    this.reviewNotes,
    this.rejectionReason,
    this.hasAttachments = false,
    this.employeeName,
    this.divisionName,
    this.branchName,
    this.branchId,
    this.templateTitle,
  });

  factory JobDeskAssignment.fromJson(Map<String, dynamic> json) {
    return JobDeskAssignment(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      templateId: json['template_id'],
      assignedBy: json['assigned_by'],
      assignedAt: json['assigned_at'] != null
          ? DateTime.parse(json['assigned_at'])
          : null,
      validFrom: json['valid_from'] != null
          ? DateTime.parse(json['valid_from'])
          : null,
      validUntil: json['valid_until'] != null
          ? DateTime.parse(json['valid_until'])
          : json['due_date'] != null
              ? DateTime.parse(json['due_date'])
              : null,
      isActive: json['is_active'],
      template: json['template'] != null
          ? JobDeskTemplate.fromJson(json['template'])
          : null,
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      assignedDate: json['assigned_date'] != null
          ? DateTime.parse(json['assigned_date'].toString())
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'].toString())
          : null,
      submittedAt: json['submitted_at']?.toString(),
      submittedNotes: json['submitted_notes'],
      reviewerName: json['reviewer_name'],
      reviewedAt: json['reviewed_at']?.toString(),
      reviewNotes: json['review_notes'],
      rejectionReason: json['rejection_reason'],
      hasAttachments: (json['has_attachments'] as int?) == 1,
      employeeName: json['employee_name'],
      divisionName: json['division_name'],
      branchName: json['branch_name'],
      branchId: json['branch_id'],
      templateTitle: json['template_title'],
    );
  }

  // UI helpers
  bool get isPending => status == 'assigned';
  bool get isSubmitted => status == 'submitted';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status != 'assigned' && status != null;
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

  factory JobDeskSubmission.fromJson(Map<String, dynamic> json) {
    return JobDeskSubmission(
      id: json['id'] ?? '',
      assignmentId: json['assignment_id'] ?? '',
      taskItemId: json['task_item_id'] ?? '',
      submissionDate: DateTime.parse(json['submission_date'] ?? DateTime.now().toIso8601String()),
      status: JobDeskStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'pending'),
        orElse: () => JobDeskStatus.pending,
      ),
      actualValue: json['actual_value'],
      notes: json['notes'],
      proofPhotos: (json['proof_photos'] as List?)?.map((e) => e.toString()).toList(),
      proofDocuments: (json['proof_documents'] as List?)?.map((e) => e.toString()).toList(),
      proofLink: json['proof_link'],
      submittedAt: json['submitted_at'] != null ? DateTime.parse(json['submitted_at']) : null,
      verifiedBy: json['verified_by'],
      verifiedAt: json['verified_at'] != null ? DateTime.parse(json['verified_at']) : null,
      rejectionReason: json['rejection_reason'],
    );
  }

  bool get isPending => status == JobDeskStatus.pending;
  bool get isCompleted => status == JobDeskStatus.completed;
  bool get isVerified => status == JobDeskStatus.verified;
  bool get isRejected => status == JobDeskStatus.rejected;

  // Compatibility getters for UI
  DateTime? get reviewedAt => verifiedAt;
  String? get reviewerName => verifiedBy;
  String? get proofPhotoUrl => (proofPhotos != null && proofPhotos!.isNotEmpty) ? proofPhotos!.first : null;
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

/// ============================================================
/// 📸 JOB DESK PROOF (Individual Proof Model)
/// ============================================================

class JobDeskProof {
  final String id;
  final String url;
  final String? type;
  final DateTime uploadedAt;

  JobDeskProof({
    required this.id,
    required this.url,
    this.type,
    required this.uploadedAt,
  });

  factory JobDeskProof.fromJson(Map<String, dynamic> json) {
    return JobDeskProof(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      type: json['type'],
      uploadedAt: DateTime.parse(json['uploaded_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

/// ============================================================
/// 📊 JOB DESK STATS (Summary stats for owner)
/// ============================================================

class JobDeskStats {
  final int totalEmployees;
  final int completedAll;
  final double avgCompletion;
  final int needAttention;

  JobDeskStats({
    required this.totalEmployees,
    required this.completedAll,
    required this.avgCompletion,
    required this.needAttention,
  });

  factory JobDeskStats.fromJson(Map<String, dynamic> json) {
    return JobDeskStats(
      totalEmployees: json['total_employees'] ?? 0,
      completedAll: json['completed_all'] ?? 0,
      avgCompletion: (json['avg_completion'] ?? 0).toDouble(),
      needAttention: json['need_attention'] ?? 0,
    );
  }
}
