import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../models/owner_models.dart';
import '../providers/owner_provider.dart';

class BranchDetailScreen extends ConsumerStatefulWidget {
  final String branchId;
  const BranchDetailScreen({super.key, required this.branchId});

  @override
  ConsumerState<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends ConsumerState<BranchDetailScreen> {
  int _selectedTimeRange = 0;
  final List<String> _timeRanges = ['7 Hari', '30 Hari', '3 Bulan', '1 Tahun'];

  @override
  Widget build(BuildContext context) {
    final branchDetailAsync = ref.watch(ownerBranchDetailProvider(widget.branchId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: branchDetailAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, _) => _buildErrorState(error.toString()),
        data: (detail) => _buildContent(detail),
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.ownerColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: const Text('Memuat...', style: TextStyle(color: Colors.white)),
        ),
        const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.ownerColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
        ),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text('Gagal memuat detail cabang', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text(error, style: AppTextStyles.caption, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(ownerBranchDetailProvider(widget.branchId)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ownerColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BranchDetail detail) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(ownerBranchDetailProvider(widget.branchId));
      },
      color: AppColors.ownerColor,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.ownerColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.ownerGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.store_rounded, color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text('Cabang ${detail.code}',
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(detail.name, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(detail.address, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildTimeFilter(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetricsRow(detail),
                      const SizedBox(height: 20),
                      _buildManagerSection(detail),
                      const SizedBox(height: 20),
                      _buildRecentActivitySection(detail.recentActivity),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _timeRanges.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isSelected = _selectedTimeRange == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeRange = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ownerColor : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_timeRanges[i],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricsRow(BranchDetail detail) {
    final revStr = detail.totalRevenue >= 1000000
        ? 'Rp ${(detail.totalRevenue / 1000000).toStringAsFixed(1)}Jt'
        : 'Rp ${detail.totalRevenue.toInt()}';

    return Column(
      children: [
        Row(children: [
          Expanded(child: GradientStatCard(
            title: 'Pendapatan',
            value: revStr,
            icon: Icons.attach_money_rounded,
            gradient: AppColors.ownerGradient,
          )),
          const SizedBox(width: 12),
          Expanded(child: StatCard(
            title: 'Karyawan',
            value: '${detail.totalEmployees}',
            icon: Icons.people_outline_rounded,
            color: AppColors.info,
          )),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: StatCard(
            title: 'Pending Approval',
            value: '${detail.pendingApprovals}',
            subtitle: 'Perlu ditinjau',
            icon: Icons.pending_actions_rounded,
            color: AppColors.warning,
          )),
          const SizedBox(width: 12),
          Expanded(child: StatCard(
            title: 'Kehadiran',
            value: '${detail.attendanceRate.toStringAsFixed(0)}%',
            subtitle: 'Rate kehadiran',
            icon: Icons.check_circle_outline_rounded,
            color: detail.attendanceRate >= 80 ? AppColors.success : AppColors.error,
          )),
        ]),
      ],
    );
  }

  Widget _buildManagerSection(BranchDetail detail) {
    if (detail.managerName == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Kepala Cabang'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.sm,
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.ownerColor.withOpacity(0.1),
              child: Text(
                detail.managerName!.isNotEmpty ? detail.managerName![0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ownerColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.managerName!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                Text('Kepala Cabang', style: AppTextStyles.caption),
              ],
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Aktif',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection(List<ActivityItem> activities) {
    if (activities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Aktivitas Terbaru'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Belum ada aktivitas terbaru')),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Aktivitas Terbaru'),
        const SizedBox(height: 12),
        ...activities.take(5).map((a) => _buildActivityItem(a)),
      ],
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    final icon = _getActivityIcon(activity.iconType);
    final color = _getActivityColor(activity.iconType);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.userName, style: AppTextStyles.bodyMedium),
            Text(activity.details, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        )),
        Text(
          _formatTimestamp(activity.timestamp),
          style: AppTextStyles.caption.copyWith(fontSize: 11),
        ),
      ]),
    );
  }

  IconData _getActivityIcon(String iconType) {
    switch (iconType) {
      case 'login':
        return Icons.login_rounded;
      case 'report':
        return Icons.description_rounded;
      case 'attendance':
        return Icons.access_time_rounded;
      case 'inventory':
        return Icons.inventory_2_rounded;
      case 'approval':
        return Icons.check_circle_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  Color _getActivityColor(String iconType) {
    switch (iconType) {
      case 'login':
        return AppColors.info;
      case 'report':
        return AppColors.success;
      case 'attendance':
        return AppColors.primary;
      case 'inventory':
        return AppColors.warning;
      case 'approval':
        return AppColors.success;
      default:
        return AppColors.textHint;
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}j lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}h lalu';
      } else {
        return '${dt.day}/${dt.month}';
      }
    } catch (_) {
      return timestamp;
    }
  }
}
