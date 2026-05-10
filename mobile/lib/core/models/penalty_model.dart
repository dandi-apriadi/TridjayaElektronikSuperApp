import 'package:flutter/material.dart';

/// ============================================================
/// ⚠️ PENALTY / VIOLATION MODEL
/// Model untuk denda dan pelanggaran karyawan
/// ============================================================

enum ViolationType {
  lateSubmission,      // Terlambat submit task
  incompleteTask,    // Task tidak selesai
  noProof,           // Tidak ada bukti
  fakeProof,         // Bukti palsu
  absent,            // Tidak masuk kerja
  lateArrival,       // Terlambat datang
  earlyDeparture,    // Pulang cepat
  policyViolation,   // Pelanggaran kebijakan
  attitudeIssue,     // Masalah sikap
}

extension ViolationTypeExtension on ViolationType {
  String get label {
    switch (this) {
      case ViolationType.lateSubmission:
        return 'Terlambat Submit';
      case ViolationType.incompleteTask:
        return 'Task Tidak Selesai';
      case ViolationType.noProof:
        return 'Tidak Ada Bukti';
      case ViolationType.fakeProof:
        return 'Bukti Palsu';
      case ViolationType.absent:
        return 'Tidak Masuk';
      case ViolationType.lateArrival:
        return 'Terlambat Datang';
      case ViolationType.earlyDeparture:
        return 'Pulang Cepat';
      case ViolationType.policyViolation:
        return 'Pelanggaran Kebijakan';
      case ViolationType.attitudeIssue:
        return 'Masalah Sikap';
    }
  }

  String get description {
    switch (this) {
      case ViolationType.lateSubmission:
        return 'Submit task melebihi deadline yang ditentukan';
      case ViolationType.incompleteTask:
        return 'Task tidak diselesaikan sesuai target';
      case ViolationType.noProof:
        return 'Tidak menyertakan bukti penyelesaian task';
      case ViolationType.fakeProof:
        return 'Menggunakan bukti palsu atau screenshot editan';
      case ViolationType.absent:
        return 'Tidak masuk kerja tanpa izin';
      case ViolationType.lateArrival:
        return 'Datang terlambat melebihi toleransi';
      case ViolationType.earlyDeparture:
        return 'Pulang sebelum waktu yang ditentukan';
      case ViolationType.policyViolation:
        return 'Melanggar kebijakan perusahaan';
      case ViolationType.attitudeIssue:
        return 'Sikap tidak profesional';
    }
  }

  Color get color {
    switch (this) {
      case ViolationType.lateSubmission:
      case ViolationType.incompleteTask:
        return Colors.orange;
      case ViolationType.noProof:
      case ViolationType.fakeProof:
        return Colors.red;
      case ViolationType.absent:
        return Colors.red.shade700;
      case ViolationType.lateArrival:
      case ViolationType.earlyDeparture:
        return Colors.amber;
      case ViolationType.policyViolation:
      case ViolationType.attitudeIssue:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case ViolationType.lateSubmission:
        return Icons.timer_off;
      case ViolationType.incompleteTask:
        return Icons.incomplete_circle;
      case ViolationType.noProof:
        return Icons.hide_image;
      case ViolationType.fakeProof:
        return Icons.warning_amber;
      case ViolationType.absent:
        return Icons.person_off;
      case ViolationType.lateArrival:
        return Icons.access_time_filled;
      case ViolationType.earlyDeparture:
        return Icons.exit_to_app;
      case ViolationType.policyViolation:
        return Icons.gavel;
      case ViolationType.attitudeIssue:
        return Icons.sentiment_dissatisfied;
    }
  }

  int get severity {
    switch (this) {
      case ViolationType.lateSubmission:
      case ViolationType.incompleteTask:
        return 1; // Ringan
      case ViolationType.noProof:
      case ViolationType.lateArrival:
      case ViolationType.earlyDeparture:
        return 2; // Sedang
      case ViolationType.fakeProof:
      case ViolationType.policyViolation:
        return 3; // Berat
      case ViolationType.absent:
      case ViolationType.attitudeIssue:
        return 4; // Sangat berat
    }
  }
}

enum PenaltyStatus {
  pending,    // Menunggu verifikasi
  confirmed,  // Sudah dikonfirmasi
  disputed,   // Sedang dipermasalahkan
  waived,     // Dibebaskan
  paid,       // Sudah dibayar
}

extension PenaltyStatusExtension on PenaltyStatus {
  String get label {
    switch (this) {
      case PenaltyStatus.pending:
        return 'Menunggu';
      case PenaltyStatus.confirmed:
        return 'Dikonfirmasi';
      case PenaltyStatus.disputed:
        return 'Dipermasalahkan';
      case PenaltyStatus.waived:
        return 'Dibebaskan';
      case PenaltyStatus.paid:
        return 'Lunas';
    }
  }

  Color get color {
    switch (this) {
      case PenaltyStatus.pending:
        return Colors.orange;
      case PenaltyStatus.confirmed:
        return Colors.red;
      case PenaltyStatus.disputed:
        return Colors.blue;
      case PenaltyStatus.waived:
        return Colors.green;
      case PenaltyStatus.paid:
        return Colors.grey;
    }
  }
}

class Violation {
  final String id;
  final ViolationType type;
  final String description;
  final DateTime date;
  final String? taskId;
  final String? taskName;
  final String? notes;

  Violation({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    this.taskId,
    this.taskName,
    this.notes,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Penalty {
  final String id;
  final String userId;
  final String userName;
  final Violation violation;
  final double amount;
  final PenaltyStatus status;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String? verifiedBy;
  final String? notes;

  Penalty({
    required this.id,
    required this.userId,
    required this.userName,
    required this.violation,
    required this.amount,
    this.status = PenaltyStatus.pending,
    required this.createdAt,
    this.paidAt,
    this.verifiedBy,
    this.notes,
  });

  String get formattedAmount {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  bool get isPaid => status == PenaltyStatus.paid || status == PenaltyStatus.waived;
  bool get isPending => status == PenaltyStatus.pending;
}

class MonthlyPenaltySummary {
  final String month;
  final int year;
  final List<Penalty> penalties;
  final double totalAmount;
  final int paidCount;
  final int pendingCount;

  MonthlyPenaltySummary({
    required this.month,
    required this.year,
    required this.penalties,
    required this.totalAmount,
    required this.paidCount,
    required this.pendingCount,
  });

  double get paidAmount {
    return penalties
        .where((p) => p.status == PenaltyStatus.paid)
        .fold(0, (sum, p) => sum + p.amount);
  }

  double get pendingAmount {
    return penalties
        .where((p) => p.status == PenaltyStatus.pending || p.status == PenaltyStatus.confirmed)
        .fold(0, (sum, p) => sum + p.amount);
  }

  double get waivedAmount {
    return penalties
        .where((p) => p.status == PenaltyStatus.waived)
        .fold(0, (sum, p) => sum + p.amount);
  }

  int get violationCount => penalties.length;

  String get formattedAmount {
    return 'Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}

class PenaltyEstimation {
  final ViolationType type;
  final double estimatedAmount;
  final String calculationBasis;
  final List<String> factors;

  PenaltyEstimation({
    required this.type,
    required this.estimatedAmount,
    required this.calculationBasis,
    required this.factors,
  });

  String get formattedAmount {
    return 'Rp ${estimatedAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
