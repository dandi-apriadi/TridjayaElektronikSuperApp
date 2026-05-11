import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../models/owner_models.dart';
import '../providers/owner_provider.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedBranchIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final dashboardAsync = ref.watch(ownerDashboardProvider);
    final branchesAsync = ref.watch(ownerBranchesProvider);
    final salesRankingAsync = ref.watch(salesRankingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(ownerDashboardProvider);
          ref.invalidate(ownerBranchesProvider);
          ref.invalidate(salesRankingProvider);
        },
        color: AppColors.ownerColor,
        child: CustomScrollView(
          slivers: [
            _buildHeader(user?.username ?? 'Owner'),
            SliverToBoxAdapter(
              child: dashboardAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => _buildErrorWidget(error.toString()),
                data: (metrics) {
                  final branchNames = branchesAsync.when(
                    data: (branches) => ['Semua', ...branches.map((b) => b.name)],
                    loading: () => ['Semua'],
                    error: (_, __) => ['Semua'],
                  );

                  return Column(
                    children: [
                      _buildBranchFilter(branchNames),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroMetrics(metrics),
                            const SizedBox(height: 20),
                            _buildAttendanceCard(metrics),
                            const SizedBox(height: 20),
                            _buildBranchPerformanceSection(metrics.branchPerformance),
                            const SizedBox(height: 20),
                            _buildRecentActivitySection(metrics.recentActivity),
                            const SizedBox(height: 20),
                            _buildPerformanceSection(salesRankingAsync),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/ai-chat'),
        backgroundColor: AppColors.ownerColor,
        label: const Text('Tanya AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        elevation: 8,
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat data',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(ownerDashboardProvider);
              ref.invalidate(ownerBranchesProvider);
              ref.invalidate(salesRankingProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ownerColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String username) {
    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dateStr = '${days[now.weekday]}, ${now.day} ${months[now.month]} ${now.year}';

    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.ownerColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.ownerGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -30, right: -30,
                child: Container(width: 160, height: 160,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
              Positioned(bottom: 20, right: 60,
                child: Container(width: 60, height: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(children: [
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
                          ),
                          child: Center(
                            child: Text('TE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ownerColor,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () => context.push('/notifications'),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text('Halo, $username 👋',
                          style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(dateStr, style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchFilter(List<String> branches) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: branches.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isSelected = _selectedBranchIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedBranchIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ownerColor : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? AppShadows.colored(AppColors.ownerColor) : null,
                ),
                child: Text(branches[i],
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroMetrics(DashboardMetrics metrics) {
    final revStr = metrics.totalRevenue >= 1000000
        ? 'Rp ${(metrics.totalRevenue / 1000000).toStringAsFixed(1)}Jt'
        : 'Rp ${metrics.totalRevenue.toInt()}';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      SectionHeader(
        title: 'Ringkasan',
        actionLabel: 'Detail Cabang',
        onAction: () {
          final branchesAsync = ref.read(ownerBranchesProvider);
          branchesAsync.whenData((branches) {
            if (branches.isNotEmpty) {
              final selectedBranchId = _selectedBranchIndex == 0
                  ? branches.first.id
                  : branches[_selectedBranchIndex - 1].id;
              context.push('/owner/branches/$selectedBranchId');
            }
          });
        },
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: GradientStatCard(
            title: 'Pendapatan', value: revStr,
            icon: Icons.trending_up_rounded, gradient: AppColors.ownerGradient,
          )),
          const SizedBox(width: 12),
          Expanded(child: StatCard(
            title: 'Total Karyawan', value: '${metrics.totalOrders}',
            icon: Icons.people_outline_rounded, color: AppColors.success,
          )),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: StatCard(
            title: 'Pending Approval', value: '${metrics.pendingApprovals}',
            subtitle: 'Perlu ditinjau',
            icon: Icons.pending_actions_rounded, color: AppColors.warning,
          )),
          const SizedBox(width: 12),
          Expanded(child: StatCard(
            title: 'Cabang Aktif', value: '${metrics.branchPerformance.length}',
            subtitle: 'Semua cabang',
            icon: Icons.store_rounded, color: AppColors.info,
          )),
        ],
      ),
    ]);
  }

  Widget _buildAttendanceCard(DashboardMetrics metrics) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Performa Cabang',
        actionLabel: 'Detail',
        onAction: () => context.push('/owner/performance'),
      ),
      const SizedBox(height: 12),
      if (metrics.branchPerformance.isNotEmpty)
        DonutChartCard(
          title: 'Pencapaian Target per Cabang',
          centerLabel: 'Cabang',
          centerValue: '${metrics.branchPerformance.length}',
          data: metrics.branchPerformance.map((b) {
            final color = b.achievementPercentage >= 80
                ? AppColors.success
                : b.achievementPercentage >= 50
                    ? AppColors.warning
                    : AppColors.error;
            return ChartPieData(
              label: b.name,
              value: b.achievementPercentage > 0 ? b.achievementPercentage : 1,
              color: color,
            );
          }).toList(),
        )
      else
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text('Belum ada data performa cabang'),
          ),
        ),
    ]);
  }

  Widget _buildBranchPerformanceSection(List<BranchMetrics> branches) {
    if (branches.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Revenue per Cabang'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          children: branches.asMap().entries.map((entry) {
            final i = entry.key;
            final b = entry.value;
            final revStr = b.revenue >= 1000000
                ? 'Rp ${(b.revenue / 1000000).toStringAsFixed(1)}Jt'
                : 'Rp ${b.revenue.toInt()}';
            final achieveColor = b.achievementPercentage >= 80
                ? AppColors.success
                : b.achievementPercentage >= 50
                    ? AppColors.warning
                    : AppColors.error;

            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.ownerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(b.code,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ownerColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(b.name, style: AppTextStyles.bodyMedium),
                    Text('${b.orders} karyawan', style: AppTextStyles.caption),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(revStr, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: achieveColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${b.achievementPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: achieveColor),
                      ),
                    ),
                  ]),
                ]),
              ),
              if (i < branches.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
            ]);
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _buildRecentActivitySection(List<ActivityItem> activities) {
    if (activities.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Aktivitas Terbaru'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          children: activities.take(5).toList().asMap().entries.map((entry) {
            final i = entry.key;
            final a = entry.value;
            final icon = _getActivityIcon(a.iconType);
            final color = _getActivityColor(a.iconType);

            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.userName, style: AppTextStyles.bodyMedium),
                    Text(a.details, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  Text(
                    _formatTimestamp(a.timestamp),
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
                ]),
              ),
              if (i < activities.length - 1 && i < 4) const Divider(height: 1, indent: 16, endIndent: 16),
            ]);
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _buildPerformanceSection(AsyncValue<List<SalesRanking>> salesRankingAsync) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Top Performer',
        actionLabel: 'Semua',
        onAction: () => context.push('/owner/performance'),
      ),
      const SizedBox(height: 12),
      salesRankingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text('Gagal memuat ranking: $error', style: AppTextStyles.caption),
        ),
        data: (rankings) {
          if (rankings.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text('Belum ada data ranking')),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              children: rankings.take(5).toList().asMap().entries.map((entry) {
                final i = entry.key;
                final r = entry.value;
                final medals = ['🥇', '🥈', '🥉', '', ''];
                final scoreColor = r.achievementPercentage >= 100
                    ? AppColors.success
                    : r.achievementPercentage >= 80
                        ? AppColors.warning
                        : AppColors.error;

                return Column(children: [
                  ListTile(
                    dense: true,
                    leading: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          i < 3 ? medals[i] : '${r.rank}',
                          style: TextStyle(
                            fontSize: i < 3 ? 18 : 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    title: Text(r.fullName, style: AppTextStyles.bodyMedium),
                    subtitle: Text('Sales • ${r.branchName}', style: AppTextStyles.caption),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${r.achievementPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scoreColor),
                      ),
                    ),
                  ),
                  if (i < rankings.length - 1 && i < 4) const Divider(height: 1, indent: 60),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    ]);
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
        return '${diff.inMinutes} menit lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} jam lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} hari lalu';
      } else {
        return '${dt.day}/${dt.month}/${dt.year}';
      }
    } catch (_) {
      return timestamp;
    }
  }
}
