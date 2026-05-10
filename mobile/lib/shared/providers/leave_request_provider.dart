import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/leave_request_model.dart';
import '../../core/models/user_model.dart';
import '../../core/models/user_model.dart';

/// ============================================================
/// 📝 LEAVE REQUEST PROVIDER
/// State management untuk pengajuan dan persetujuan OFF/Sakit
/// ============================================================

// Provider untuk daftar semua leave requests
final leaveRequestsProvider = StateNotifierProvider<LeaveRequestNotifier, List<LeaveRequest>>((ref) {
  return LeaveRequestNotifier();
});

// Provider untuk leave requests milik user saat ini
final myLeaveRequestsProvider = Provider.family<List<LeaveRequest>, String>((ref, userId) {
  final allRequests = ref.watch(leaveRequestsProvider);
  return allRequests.where((r) => r.employeeId == userId).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

// Provider untuk pending approvals (untuk Kepala Cabang/PIC)
final pendingApprovalsProvider = Provider<List<LeaveRequest>>((ref) {
  final allRequests = ref.watch(leaveRequestsProvider);
  return allRequests.where((r) => r.status == LeaveStatus.pending).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

// Provider untuk cek apakah ada leave aktif hari ini
final hasActiveLeaveTodayProvider = Provider.family<bool, String>((ref, userId) {
  final requests = ref.watch(leaveRequestsProvider);
  return hasActiveLeaveToday(requests, userId);
});

// Provider untuk mendapatkan leave aktif hari ini
final activeLeaveTodayProvider = Provider.family<LeaveRequest?, String>((ref, userId) {
  final requests = ref.watch(leaveRequestsProvider);
  return getActiveLeaveToday(requests, userId);
});

// Provider untuk menghitung jumlah pending approvals
final pendingApprovalsCountProvider = Provider<int>((ref) {
  final pending = ref.watch(pendingApprovalsProvider);
  return pending.length;
});

class LeaveRequestNotifier extends StateNotifier<List<LeaveRequest>> {
  LeaveRequestNotifier() : super(getDummyLeaveRequests());

  /// Submit pengajuan OFF/Sakit baru
  Future<bool> submitRequest({
    required String employeeId,
    required String employeeName,
    required String? employeePhoto,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
    String? attachmentUrl,
  }) async {
    try {
      // Validasi: cek apakah sudah ada pengajuan untuk tanggal yang sama
      final existingRequest = state.any((r) {
        if (r.employeeId != employeeId) return false;
        if (r.status == LeaveStatus.cancelled || r.status == LeaveStatus.rejected) return false;
        
        // Cek overlap tanggal
        return (startDate.isBefore(r.endDate.add(const Duration(days: 1))) && 
                endDate.isAfter(r.startDate.subtract(const Duration(days: 1))));
      });

      if (existingRequest) {
        throw Exception('Sudah ada pengajuan untuk periode tanggal ini');
      }

      final newRequest = LeaveRequest(
        id: 'lr${DateTime.now().millisecondsSinceEpoch}',
        employeeId: employeeId,
        employeeName: employeeName,
        employeePhoto: employeePhoto,
        type: type,
        status: LeaveStatus.pending,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        attachmentUrl: attachmentUrl,
        createdAt: DateTime.now(),
      );

      state = [newRequest, ...state];
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Approve pengajuan (Kepala Cabang/PIC)
  Future<bool> approveRequest({
    required String requestId,
    required String approverId,
    required String approverName,
  }) async {
    try {
      state = state.map((request) {
        if (request.id == requestId) {
          return request.copyWith(
            status: LeaveStatus.approved,
            approvedBy: approverId,
            approverName: approverName,
            approvedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
        return request;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reject pengajuan (Kepala Cabang/PIC)
  Future<bool> rejectRequest({
    required String requestId,
    required String approverId,
    required String approverName,
    required String rejectionReason,
  }) async {
    try {
      state = state.map((request) {
        if (request.id == requestId) {
          return request.copyWith(
            status: LeaveStatus.rejected,
            approvedBy: approverId,
            approverName: approverName,
            approvedAt: DateTime.now(),
            rejectionReason: rejectionReason,
            updatedAt: DateTime.now(),
          );
        }
        return request;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cancel pengajuan oleh employee (hanya bisa cancel jika masih pending)
  Future<bool> cancelRequest(String requestId) async {
    try {
      final request = state.firstWhere((r) => r.id == requestId);
      if (request.status != LeaveStatus.pending) {
        throw Exception('Hanya pengajuan dengan status menunggu yang bisa dibatalkan');
      }

      state = state.map((r) {
        if (r.id == requestId) {
          return r.copyWith(
            status: LeaveStatus.cancelled,
            updatedAt: DateTime.now(),
          );
        }
        return r;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update attachment URL
  Future<bool> updateAttachment(String requestId, String attachmentUrl) async {
    try {
      state = state.map((request) {
        if (request.id == requestId) {
          return request.copyWith(
            attachmentUrl: attachmentUrl,
            updatedAt: DateTime.now(),
          );
        }
        return request;
      }).toList();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Extension untuk cek role yang bisa approve
extension UserRoleLeaveApproval on UserRole {
  bool get canApproveLeave {
    switch (this) {
      case UserRole.kepalaCabang:
      case UserRole.owner:
      case UserRole.superAdmin:
        return true;
      default:
        return false;
    }
  }
}
