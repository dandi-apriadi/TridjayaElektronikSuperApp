import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/models/leave_request_model.dart';
import '../../core/models/user_model.dart';
import '../../core/network/dio_client.dart';

/// ============================================================
/// 📝 LEAVE REQUEST PROVIDER (REAL API)
/// State management untuk pengajuan dan persetujuan OFF/Sakit
/// Connected to: GET/POST /api/leave-requests
/// ============================================================

// Provider untuk daftar semua leave requests
final leaveRequestsProvider = StateNotifierProvider<LeaveRequestNotifier, List<LeaveRequest>>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return LeaveRequestNotifier(dio);
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
  final Dio _dio;
  bool _initialized = false;

  LeaveRequestNotifier(this._dio) : super([]) {
    _loadFromApi();
  }

  /// Load leave requests from API
  Future<void> _loadFromApi() async {
    try {
      final response = await _dio.get('/api/leave-requests/my');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        state = data.map((json) => _parseLeaveRequest(json)).toList();
        _initialized = true;
      }
    } on DioException catch (e) {
      debugPrint('Error loading leave requests: ${e.message}');
      // Keep empty state on error, don't crash
    }
  }

  /// Refresh data from API
  Future<void> refresh() async {
    await _loadFromApi();
  }

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
      final response = await _dio.post(
        '/api/leave-requests',
        data: {
          'start_date': '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
          'end_date': '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
          'reason': reason ?? '${type.displayName}: Pengajuan ${type.displayName}',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse the response and add to state
        final newRequest = _parseLeaveRequest(response.data);
        state = [newRequest, ...state];
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Error submitting leave request: ${e.message}');
      final errorMsg = e.response?.data?['error'] ?? 'Gagal mengajukan cuti';
      debugPrint('Server error: $errorMsg');
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
      final response = await _dio.post(
        '/api/leave-requests/$requestId/approve',
        data: {'notes': 'Disetujui oleh $approverName'},
      );

      if (response.statusCode == 200) {
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
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Error approving leave request: ${e.message}');
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
      final response = await _dio.post(
        '/api/leave-requests/$requestId/reject',
        data: {'notes': rejectionReason},
      );

      if (response.statusCode == 200) {
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
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Error rejecting leave request: ${e.message}');
      return false;
    }
  }

  /// Cancel pengajuan oleh employee (hanya bisa cancel jika masih pending)
  Future<bool> cancelRequest(String requestId) async {
    try {
      final request = state.firstWhere((r) => r.id == requestId);
      if (request.status != LeaveStatus.pending) {
        debugPrint('Cannot cancel: status is not pending');
        return false;
      }

      // Use reject endpoint to cancel
      final response = await _dio.post(
        '/api/leave-requests/$requestId/reject',
        data: {'notes': 'Dibatalkan oleh karyawan'},
      );

      if (response.statusCode == 200) {
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
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Error cancelling leave request: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Error: $e');
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

// ============================================
// HELPER: Parse API response to LeaveRequest model
// ============================================

LeaveRequest _parseLeaveRequest(dynamic json) {
  final data = json as Map<String, dynamic>;

  return LeaveRequest(
    id: data['id'] ?? '',
    employeeId: data['user_id'] ?? '',
    employeeName: data['user_name'] ?? 'User',
    employeePhoto: null,
    type: _parseLeaveType(data['reason']),
    status: _parseLeaveStatus(data['status']),
    startDate: _parseDate(data['start_date']),
    endDate: _parseDate(data['end_date']),
    reason: data['reason'],
    attachmentUrl: null,
    createdAt: _parseDate(data['created_at']),
    approvedBy: data['approved_by'],
    approverName: data['approver_name'],
    approvedAt: data['approved_at'] != null ? DateTime.tryParse(data['approved_at']) : null,
    rejectionReason: data['rejection_reason'],
    updatedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at']) : null,
  );
}

DateTime _parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return DateTime.now();
  return DateTime.tryParse(dateStr) ?? DateTime.now();
}

LeaveType _parseLeaveType(String? reason) {
  if (reason == null) return LeaveType.off;
  final lower = reason.toLowerCase();
  if (lower.contains('sakit') || lower.contains('sick') || lower.contains('demam')) {
    return LeaveType.sakit;
  } else if (lower.contains('izin') || lower.contains('permission')) {
    return LeaveType.izin;
  } else if (lower.contains('cuti') || lower.contains('annual')) {
    return LeaveType.cuti;
  }
  return LeaveType.off;
}

LeaveStatus _parseLeaveStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'approved':
      return LeaveStatus.approved;
    case 'rejected':
      return LeaveStatus.rejected;
    case 'cancelled':
      return LeaveStatus.cancelled;
    case 'pending':
    default:
      return LeaveStatus.pending;
  }
}
