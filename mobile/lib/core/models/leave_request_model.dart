import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

/// ============================================================
/// 📝 LEAVE REQUEST MODEL
/// Model untuk pengajuan OFF/Sakit
/// ============================================================

enum LeaveType {
  @JsonValue('off')
  off,
  @JsonValue('sakit')
  sakit,
  @JsonValue('izin')
  izin,
  @JsonValue('cuti')
  cuti,
}

enum LeaveStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('cancelled')
  cancelled,
}

extension LeaveTypeExtension on LeaveType {
  String get displayName {
    switch (this) {
      case LeaveType.off:
        return 'OFF';
      case LeaveType.sakit:
        return 'Sakit';
      case LeaveType.izin:
        return 'Izin';
      case LeaveType.cuti:
        return 'Cuti';
    }
  }

  String get description {
    switch (this) {
      case LeaveType.off:
        return 'Libur hari ini';
      case LeaveType.sakit:
        return 'Tidak masuk karena sakit';
      case LeaveType.izin:
        return 'Izin tidak masuk kerja';
      case LeaveType.cuti:
        return 'Cuti tahunan';
    }
  }

  Color get color {
    switch (this) {
      case LeaveType.off:
        return Colors.blue;
      case LeaveType.sakit:
        return Colors.red;
      case LeaveType.izin:
        return Colors.orange;
      case LeaveType.cuti:
        return Colors.green;
    }
  }
}

extension LeaveStatusExtension on LeaveStatus {
  String get displayName {
    switch (this) {
      case LeaveStatus.pending:
        return 'Menunggu';
      case LeaveStatus.approved:
        return 'Disetujui';
      case LeaveStatus.rejected:
        return 'Ditolak';
      case LeaveStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Color get color {
    switch (this) {
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
      case LeaveStatus.cancelled:
        return Colors.grey;
    }
  }
}

@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    required String id,
    required String employeeId,
    required String employeeName,
    required String? employeePhoto,
    required LeaveType type,
    required LeaveStatus status,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
    String? attachmentUrl,
    String? approvedBy,
    String? approverName,
    DateTime? approvedAt,
    String? rejectionReason,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LeaveRequest;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestFromJson(json);
}

// Dummy data generator
List<LeaveRequest> getDummyLeaveRequests() {
  final now = DateTime.now();
  return [
    LeaveRequest(
      id: 'lr001',
      employeeId: 'emp001',
      employeeName: 'Budi Santoso',
      employeePhoto: null,
      type: LeaveType.sakit,
      status: LeaveStatus.approved,
      startDate: now.subtract(const Duration(days: 2)),
      endDate: now.subtract(const Duration(days: 2)),
      reason: 'Demam dan flu',
      approvedBy: 'kc001',
      approverName: 'Pak Ahmad',
      approvedAt: now.subtract(const Duration(days: 3)),
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    LeaveRequest(
      id: 'lr002',
      employeeId: 'emp002',
      employeeName: 'Ani Wijaya',
      employeePhoto: null,
      type: LeaveType.off,
      status: LeaveStatus.pending,
      startDate: now,
      endDate: now,
      reason: 'Keperluan keluarga',
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
    LeaveRequest(
      id: 'lr003',
      employeeId: 'emp003',
      employeeName: 'Dedi Kurniawan',
      employeePhoto: null,
      type: LeaveType.izin,
      status: LeaveStatus.rejected,
      startDate: now.add(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 1)),
      reason: 'Ada acara penting',
      rejectionReason: 'Jadwal padat, mohon ajukan ulang',
      approvedBy: 'kc001',
      approverName: 'Pak Ahmad',
      approvedAt: now.subtract(const Duration(hours: 1)),
      createdAt: now.subtract(const Duration(hours: 4)),
    ),
  ];
}

// Helper untuk cek apakah ada leave yang aktif hari ini
bool hasActiveLeaveToday(List<LeaveRequest> requests, String employeeId) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  return requests.any((request) {
    if (request.employeeId != employeeId) return false;
    if (request.status != LeaveStatus.approved) return false;
    
    final startDate = DateTime(request.startDate.year, request.startDate.month, request.startDate.day);
    final endDate = DateTime(request.endDate.year, request.endDate.month, request.endDate.day);
    
    return today.isAtSameMomentAs(startDate) || 
           today.isAtSameMomentAs(endDate) || 
           (today.isAfter(startDate) && today.isBefore(endDate.add(const Duration(days: 1))));
  });
}

// Helper untuk mendapatkan leave aktif hari ini
LeaveRequest? getActiveLeaveToday(List<LeaveRequest> requests, String employeeId) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  try {
    return requests.firstWhere((request) {
      if (request.employeeId != employeeId) return false;
      if (request.status != LeaveStatus.approved) return false;
      
      final startDate = DateTime(request.startDate.year, request.startDate.month, request.startDate.day);
      final endDate = DateTime(request.endDate.year, request.endDate.month, request.endDate.day);
      
      return today.isAtSameMomentAs(startDate) || 
             today.isAtSameMomentAs(endDate) || 
             (today.isAfter(startDate) && today.isBefore(endDate.add(const Duration(days: 1))));
    });
  } catch (e) {
    return null;
  }
}
