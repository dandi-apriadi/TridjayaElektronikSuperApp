import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/models/leave_request_model.dart';
import '../../core/models/user_model.dart';
import '../../core/network/dio_client.dart';

/// ============================================================
/// 📝 LEAVE REQUEST PROVIDER (REAL API)
/// State management untuk pengajuan dan persetujuan OFF/Sakit
/// ============================================================

// Provider untuk my leave requests dari API
final myLeaveRequestsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/leave-requests/my');
    return (response.data as List).map((e) => _parseLeaveRequest(e)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat pengajuan cuti saya');
  }
});

// Provider untuk all leave requests (untuk approval)
final allLeaveRequestsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.dio.get('/api/leave-requests');
    return (response.data as List).map((e) => _parseLeaveRequest(e)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  } on DioException catch (e) {
    throw Exception(e.response?.data?['message'] ?? 'Gagal memuat pengajuan cuti');
  }
});

// Provider untuk pending approvals
final pendingApprovalsProvider = FutureProvider<List<LeaveRequest>>((ref) async {
  final all = await ref.watch(allLeaveRequestsProvider.future);
  return all.where((r) => r.status == LeaveStatus.pending).toList();
});

// Provider untuk menghitung jumlah pending approvals
final pendingApprovalsCountProvider = FutureProvider<int>((ref) async {
  final pending = await ref.watch(pendingApprovalsProvider.future);
  return pending.length;
});

// Helper function to parse leave request from API response
LeaveRequest _parseLeaveRequest(dynamic json) {
  final data = json as Map<String, dynamic>;
  return LeaveRequest(
    id: data['id'] ?? '',
    employeeId: data['user_id'] ?? '',
    employeeName: data['user_name'] ?? 'User',
    employeePhoto: null,
    type: _parseLeaveType(data['type']),
    status: _parseLeaveStatus(data['status']),
    startDate: DateTime.parse(data['start_date']),
    endDate: DateTime.parse(data['end_date']),
    reason: data['reason'],
    attachmentUrl: null,
    createdAt: DateTime.parse(data['created_at']),
    approvedBy: data['approved_by'],
    approverName: data['approver_name'],
    approvedAt: data['approved_at'] != null ? DateTime.parse(data['approved_at']) : null,
    rejectionReason: data['rejection_reason'],
    updatedAt: DateTime.parse(data['updated_at'] ?? data['created_at']),
  );
}

LeaveType _parseLeaveType(String? type) {
  switch (type?.toLowerCase()) {
    case 'annual':
    case 'cuti':
      return LeaveType.cuti;
    case 'sick':
    case 'sakit':
      return LeaveType.sakit;
    case 'permission':
    case 'izin':
      return LeaveType.izin;
    case 'emergency':
    case 'unpaid':
    case 'off':
    default:
      return LeaveType.off;
  }
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

// ===================== MUTATION PROVIDERS =====================

// Submit Leave Request Notifier
class SubmitLeaveRequestNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  SubmitLeaveRequestNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> submitRequest({
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/leave-requests',
        data: {
          'type': _leaveTypeToString(type),
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
          'reason': reason,
        },
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal mengajukan cuti',
        StackTrace.current,
      );
    }
  }
}

final submitLeaveRequestProvider = StateNotifierProvider<SubmitLeaveRequestNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return SubmitLeaveRequestNotifier(dio.dio);
});

// Approve Leave Request Notifier
class ApproveLeaveRequestNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  ApproveLeaveRequestNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> approveRequest(String requestId) async {
    state = const AsyncValue.loading();
    try {
      await dio.post('/api/leave-requests/$requestId/approve', data: {});
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal menyetujui pengajuan',
        StackTrace.current,
      );
    }
  }
}

final approveLeaveRequestProvider = StateNotifierProvider<ApproveLeaveRequestNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return ApproveLeaveRequestNotifier(dio.dio);
});

// Reject Leave Request Notifier
class RejectLeaveRequestNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio dio;

  RejectLeaveRequestNotifier(this.dio) : super(const AsyncValue.data(null));

  Future<void> rejectRequest(String requestId, String reason) async {
    state = const AsyncValue.loading();
    try {
      await dio.post(
        '/api/leave-requests/$requestId/reject',
        data: {'reason': reason},
      );
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.response?.data?['message'] ?? 'Gagal menolak pengajuan',
        StackTrace.current,
      );
    }
  }
}

final rejectLeaveRequestProvider = StateNotifierProvider<RejectLeaveRequestNotifier, AsyncValue<void>>((ref) {
  final dio = ref.watch(dioClientProvider);
  return RejectLeaveRequestNotifier(dio.dio);
});

String _leaveTypeToString(LeaveType type) {
  switch (type) {
    case LeaveType.cuti:
      return 'cuti';
    case LeaveType.sakit:
      return 'sakit';
    case LeaveType.izin:
      return 'izin';
    case LeaveType.off:
      return 'off';
  }
}
