import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/kepala_cabang_repository.dart';
import '../models/api_response_models.dart';

/// ===========================================
/// KEPALA CABANG STATE
/// ===========================================
class KepalaCabangState {
  final bool isLoading;
  final BranchDashboard? dashboard;
  final List<EmployeeSummary>? employees;
  final List<JobDeskReviewItem>? pendingJobdesk;
  final List<WorkReportReviewItem>? pendingWorkReports;
  final List<AttendanceSummary>? attendanceSummary;
  final String? error;

  const KepalaCabangState({
    this.isLoading = false,
    this.dashboard,
    this.employees,
    this.pendingJobdesk,
    this.pendingWorkReports,
    this.attendanceSummary,
    this.error,
  });

  KepalaCabangState copyWith({
    bool? isLoading,
    BranchDashboard? dashboard,
    List<EmployeeSummary>? employees,
    List<JobDeskReviewItem>? pendingJobdesk,
    List<WorkReportReviewItem>? pendingWorkReports,
    List<AttendanceSummary>? attendanceSummary,
    String? error,
  }) {
    return KepalaCabangState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      employees: employees ?? this.employees,
      pendingJobdesk: pendingJobdesk ?? this.pendingJobdesk,
      pendingWorkReports: pendingWorkReports ?? this.pendingWorkReports,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
      error: error ?? this.error,
    );
  }
}

/// ===========================================
/// KEPALA CABANG NOTIFIER
/// ===========================================
class KepalaCabangNotifier extends StateNotifier<KepalaCabangState> {
  final KepalaCabangRepository _repository;

  KepalaCabangNotifier(this._repository) : super(const KepalaCabangState());

  /// Load dashboard
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final dashboard = await _repository.getBranchDashboard();

      state = state.copyWith(
        isLoading: false,
        dashboard: dashboard,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load employees
  Future<void> loadEmployees() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final employees = await _repository.getBranchEmployees();

      state = state.copyWith(
        isLoading: false,
        employees: employees,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load pending job desk
  Future<void> loadPendingJobdesk() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pending = await _repository.getPendingJobdesk();

      state = state.copyWith(
        isLoading: false,
        pendingJobdesk: pending,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load pending work reports
  Future<void> loadPendingWorkReports() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pending = await _repository.getPendingWorkReports();

      state = state.copyWith(
        isLoading: false,
        pendingWorkReports: pending,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Approve job desk
  Future<void> approveJobdesk(String jobdeskId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.approveJobdesk(jobdeskId);

      // Refresh pending list
      final pending = await _repository.getPendingJobdesk();

      state = state.copyWith(
        isLoading: false,
        pendingJobdesk: pending,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Reject job desk
  Future<void> rejectJobdesk(String jobdeskId, String reason) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.rejectJobdesk(jobdeskId, reason);

      // Refresh pending list
      final pending = await _repository.getPendingJobdesk();

      state = state.copyWith(
        isLoading: false,
        pendingJobdesk: pending,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Approve work report
  Future<void> approveWorkReport(String reportId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.approveWorkReport(reportId);

      // Refresh pending list
      final pending = await _repository.getPendingWorkReports();

      state = state.copyWith(
        isLoading: false,
        pendingWorkReports: pending,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Reject work report
  Future<void> rejectWorkReport(String reportId, String reason) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.rejectWorkReport(reportId, reason);

      // Refresh pending list
      final pending = await _repository.getPendingWorkReports();

      state = state.copyWith(
        isLoading: false,
        pendingWorkReports: pending,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load attendance summary
  Future<void> loadAttendanceSummary({DateTime? startDate, DateTime? endDate}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final summary = await _repository.getAttendanceSummary(
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        isLoading: false,
        attendanceSummary: summary,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboard(),
      loadEmployees(),
      loadPendingJobdesk(),
      loadPendingWorkReports(),
    ]);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// ===========================================
/// RIVERPOD PROVIDERS
/// ===========================================
final kepalaCabangNotifierProvider = StateNotifierProvider<KepalaCabangNotifier, KepalaCabangState>((ref) {
  final repository = ref.watch(kepalaCabangRepositoryProvider);
  return KepalaCabangNotifier(repository);
});

// Convenience providers
final kcLoadingProvider = Provider<bool>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).isLoading;
});

final kcDashboardProvider = Provider<BranchDashboard?>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).dashboard;
});

final kcEmployeesProvider = Provider<List<EmployeeSummary>?>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).employees;
});

final kcPendingJobdeskProvider = Provider<List<JobDeskReviewItem>?>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).pendingJobdesk;
});

final kcPendingWorkReportsProvider = Provider<List<WorkReportReviewItem>?>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).pendingWorkReports;
});

final kcAttendanceSummaryProvider = Provider<List<AttendanceSummary>?>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).attendanceSummary;
});

final kcErrorProvider = Provider<String?>((ref) {
  return ref.watch(kepalaCabangNotifierProvider).error;
});
