import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/owner_repository.dart';
import '../models/api_response_models.dart';

/// ===========================================
/// OWNER DASHBOARD STATE
/// ===========================================
class OwnerDashboardState {
  final bool isLoading;
  final DashboardMetrics? metrics;
  final List<SalesRanking>? salesRanking;
  final List<BranchListItem>? branches;
  final String? error;

  const OwnerDashboardState({
    this.isLoading = false,
    this.metrics,
    this.salesRanking,
    this.branches,
    this.error,
  });

  OwnerDashboardState copyWith({
    bool? isLoading,
    DashboardMetrics? metrics,
    List<SalesRanking>? salesRanking,
    List<BranchListItem>? branches,
    String? error,
  }) {
    return OwnerDashboardState(
      isLoading: isLoading ?? this.isLoading,
      metrics: metrics ?? this.metrics,
      salesRanking: salesRanking ?? this.salesRanking,
      branches: branches ?? this.branches,
      error: error ?? this.error,
    );
  }
}

/// ===========================================
/// OWNER NOTIFIER
/// ===========================================
class OwnerNotifier extends StateNotifier<OwnerDashboardState> {
  final OwnerRepository _ownerRepository;

  OwnerNotifier(this._ownerRepository) : super(const OwnerDashboardState());

  /// Load all dashboard data
  Future<void> loadDashboard({DateTime? startDate, DateTime? endDate}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final metrics = await _ownerRepository.getDashboardMetrics(
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        isLoading: false,
        metrics: metrics,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load sales ranking
  Future<void> loadSalesRanking({DateTime? startDate, DateTime? endDate}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ranking = await _ownerRepository.getSalesRanking(
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        isLoading: false,
        salesRanking: ranking,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load all branches
  Future<void> loadBranches() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final branches = await _ownerRepository.getAllBranches();

      state = state.copyWith(
        isLoading: false,
        branches: branches,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get branch detail
  Future<BranchDetail?> getBranchDetail(String branchId) async {
    try {
      return await _ownerRepository.getBranchDetail(branchId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboard(),
      loadSalesRanking(),
      loadBranches(),
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
final ownerNotifierProvider = StateNotifierProvider<OwnerNotifier, OwnerDashboardState>((ref) {
  final ownerRepository = ref.watch(ownerRepositoryProvider);
  return OwnerNotifier(ownerRepository);
});

// Convenience providers
final ownerLoadingProvider = Provider<bool>((ref) {
  return ref.watch(ownerNotifierProvider).isLoading;
});

final ownerMetricsProvider = Provider<DashboardMetrics?>((ref) {
  return ref.watch(ownerNotifierProvider).metrics;
});

final ownerSalesRankingProvider = Provider<List<SalesRanking>?>((ref) {
  return ref.watch(ownerNotifierProvider).salesRanking;
});

final ownerBranchesProvider = Provider<List<BranchListItem>?>((ref) {
  return ref.watch(ownerNotifierProvider).branches;
});

final ownerErrorProvider = Provider<String?>((ref) {
  return ref.watch(ownerNotifierProvider).error;
});
