import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/jobdesk/presentation/providers/jobdesk_provider.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

/// Dashboard Kepala Cabang dengan data real dari backend
class KepalaCabangDashboardScreen extends ConsumerWidget {
  const KepalaCabangDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final branchName = user?.branchName ?? 'Cabang Pusat';
    
    // Ambil data dari backend
    final pendingJobdeskAsync = ref.watch(pendingJobdeskReviewProvider);
    final myAssignmentsAsync = ref.watch(myJobdeskAssignmentsProvider);
    
    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dateStr = '${days[now.weekday]}, ${now.day} ${months[now.month]} ${now.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh semua provider
          ref.invalidate(pendingJobdeskReviewProvider);
          ref.invalidate(myJobdeskAssignmentsProvider);
        },
        color: AppColors.kepalaCabangColor,
        child: CustomScrollView(
          slivers: [
            // ── Modern gradient header ──
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.kepalaCabangColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.kepalaCabangGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(top: -20, right: -40,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
                    SafeArea(child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                        Row(children: [
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.store_outlined, color: Colors.white, size: 22),
                          ),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                        ]),
                        const SizedBox(height: 8),
                        Text('Kepala Cabang', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
                        Text(branchName, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(dateStr, style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.6))),
                      ]),
                    )),
                  ]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Quick Metrics - Jobdesk
                  _buildJobdeskMetrics(context, ref, pendingJobdeskAsync, myAssignmentsAsync),
                  const SizedBox(height: 20),

                  // Pending Jobdesk untuk Review
                  _buildPendingJobdeskReview(context, ref, pendingJobdeskAsync),
                  const SizedBox(height: 20),

                  // Jobdesk Aktif Saya
                  _buildMyActiveJobdesk(context, ref, myAssignmentsAsync),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobdeskMetrics(
    BuildContext context, 
    WidgetRef ref, 
    AsyncValue<List<dynamic>> pendingAsync,
    AsyncValue<List<dynamic>> myAssignmentsAsync
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Ringkasan Jobdesk'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: pendingAsync.when(
              data: (pending) => StatCard(
                title: 'Pending Review',
                value: '${pending.length}',
                icon: Icons.rate_review_outlined,
                color: AppColors.warning,
                onTap: () => context.go('/kepala-cabang/reports'),
              ),
              loading: () => _buildLoadingCard(),
              error: (_, __) => StatCard(
                title: 'Pending Review',
                value: '-',
                icon: Icons.error_outline,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: myAssignmentsAsync.when(
              data: (assignments) {
                final activeCount = assignments.where((a) => 
                  a.status == 'assigned' || a.status == 'in_progress'
                ).length;
                return StatCard(
                  title: 'Tugas Aktif',
                  value: '$activeCount',
                  icon: Icons.task_outlined,
                  color: AppColors.info,
                  onTap: () => context.go('/kepala-cabang/tasks'),
                );
              },
              loading: () => _buildLoadingCard(),
              error: (_, __) => StatCard(
                title: 'Tugas Aktif',
                value: '-',
                icon: Icons.error_outline,
                color: Colors.grey,
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildPendingJobdeskReview(BuildContext context, WidgetRef ref, AsyncValue<List<dynamic>> pendingAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Menunggu Review',
          actionLabel: 'Semua',
          onAction: () => context.go('/kepala-cabang/reports'),
        ),
        const SizedBox(height: 12),
        pendingAsync.when(
          data: (pending) {
            if (pending.isEmpty) {
              return _buildEmptyState('Tidak ada jobdesk yang menunggu review');
            }
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.sm,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pending.length > 5 ? 5 : pending.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (_, i) {
                  final jobdesk = pending[i];
                  return _buildJobdeskReviewItem(context, jobdesk);
                },
              ),
            );
          },
          loading: () => _buildLoadingList(),
          error: (error, _) => _buildErrorState('Gagal memuat data', error.toString()),
        ),
      ],
    );
  }

  Widget _buildMyActiveJobdesk(BuildContext context, WidgetRef ref, AsyncValue<List<dynamic>> assignmentsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Jobdesk Saya',
          actionLabel: 'Semua',
          onAction: () => context.go('/kepala-cabang/tasks'),
        ),
        const SizedBox(height: 12),
        assignmentsAsync.when(
          data: (assignments) {
            final active = assignments.where((a) => 
              a.status == 'assigned' || a.status == 'in_progress'
            ).toList();
            
            if (active.isEmpty) {
              return _buildEmptyState('Tidak ada jobdesk aktif');
            }
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.sm,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: active.length > 3 ? 3 : active.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (_, i) {
                  final jobdesk = active[i];
                  return _buildJobdeskItem(context, jobdesk);
                },
              ),
            );
          },
          loading: () => _buildLoadingList(),
          error: (error, _) => _buildErrorState('Gagal memuat data', error.toString()),
        ),
      ],
    );
  }

  Widget _buildJobdeskReviewItem(BuildContext context, dynamic jobdesk) {
    final statusColor = _getStatusColor(jobdesk.status);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.assignment_turned_in_outlined, color: AppColors.warning, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobdesk.title ?? 'Tugas Jobdesk', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 2),
            Text(
              'Dari: ${jobdesk.employeeName ?? "Karyawan"}',
              style: AppTextStyles.caption,
            ),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getStatusLabel(jobdesk.status),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
          ),
        ),
      ]),
    );
  }

  Widget _buildJobdeskItem(BuildContext context, dynamic jobdesk) {
    final statusColor = _getStatusColor(jobdesk.status);
    final priorityColor = _getPriorityColor(jobdesk.priority);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(width: 4, height: 40, 
          decoration: BoxDecoration(color: priorityColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobdesk.title ?? 'Tugas Jobdesk', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 2),
            Text(
              'Deadline: ${_formatDate(jobdesk.deadline)}',
              style: AppTextStyles.caption,
            ),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _getStatusLabel(jobdesk.status),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
          ),
        ),
      ]),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildLoadingList() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(message, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String title, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700])),
                Text(message, style: TextStyle(fontSize: 12, color: Colors.red[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
      case 'approved':
        return AppColors.success;
      case 'submitted':
      case 'completed_unapproved':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      case 'in_progress':
        return AppColors.info;
      case 'assigned':
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return 'Selesai';
      case 'submitted':
      case 'completed_unapproved':
        return 'Menunggu';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'in_progress':
        return 'Dikerjakan';
      case 'assigned':
        return 'Ditugaskan';
      default:
        return status ?? 'Unknown';
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'urgent':
        return AppColors.error;
      case 'high':
        return AppColors.warning;
      case 'medium':
        return AppColors.info;
      default:
        return AppColors.success;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
