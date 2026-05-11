import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../models/owner_models.dart';
import '../providers/owner_provider.dart';

class PerformanceScreen extends ConsumerStatefulWidget {
  const PerformanceScreen({super.key});

  @override
  ConsumerState<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends ConsumerState<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Bulanan';
  String _selectedBranch = 'Semua';
  final List<String> _periods = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final salesRankingAsync = ref.watch(salesRankingProvider);
    final branchesAsync = ref.watch(ownerBranchesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.ownerColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Performa Karyawan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: AppColors.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.ownerColor,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.ownerColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppTextStyles.bodyMedium,
                  tabs: const [Tab(text: 'Sales Ranking'), Tab(text: 'Cabang')],
                ),
              ),
            ),
          ),
        ],
        body: Column(children: [
          _buildFilters(branchesAsync),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSalesRankingTab(salesRankingAsync),
                _buildBranchTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildFilters(AsyncValue<List<Branch>> branchesAsync) {
    final branches = branchesAsync.when(
      data: (list) => ['Semua', ...list.map((b) => b.name)],
      loading: () => ['Semua'],
      error: (_, __) => ['Semua'],
    );

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedPeriod,
            decoration: InputDecoration(
              labelText: 'Periode',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
            items: _periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() => _selectedPeriod = v!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedBranch,
            decoration: InputDecoration(
              labelText: 'Cabang',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
            items: branches.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) => setState(() => _selectedBranch = v!),
          ),
        ),
      ]),
    );
  }

  Widget _buildSalesRankingTab(AsyncValue<List<SalesRanking>> salesRankingAsync) {
    return salesRankingAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Gagal memuat data: $error', style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.invalidate(salesRankingProvider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
      data: (rankings) {
        if (rankings.isEmpty) {
          return const Center(child: Text('Belum ada data ranking sales'));
        }

        // Filter by branch if selected
        final filteredRankings = _selectedBranch == 'Semua'
            ? rankings
            : rankings.where((r) => r.branchName == _selectedBranch).toList();

        final avg = filteredRankings.isEmpty
            ? 0.0
            : filteredRankings.fold(0.0, (s, r) => s + r.achievementPercentage) / filteredRankings.length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Expanded(child: StatCard(
                title: 'Top Performer',
                value: filteredRankings.isNotEmpty ? filteredRankings.first.fullName.split(' ').first : '-',
                icon: Icons.emoji_events_rounded,
                color: const Color(0xFFFFD700),
              )),
              const SizedBox(width: 12),
              Expanded(child: StatCard(
                title: 'Rata-rata',
                value: '${avg.toStringAsFixed(1)}%',
                icon: Icons.analytics_outlined,
                color: AppColors.ownerColor,
              )),
            ]),
            const SizedBox(height: 16),
            if (filteredRankings.length >= 3)
              BarChartCard(
                title: 'Achievement Top 5',
                subtitle: 'Persentase pencapaian target',
                height: 180,
                data: filteredRankings.take(5).map((r) => ChartBarData(
                  label: r.fullName.split(' ').first,
                  value: r.achievementPercentage,
                  color: r.achievementPercentage >= 100
                      ? AppColors.success
                      : r.achievementPercentage >= 80
                          ? AppColors.warning
                          : AppColors.error,
                )).toList(),
              ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Ranking Sales'),
            const SizedBox(height: 8),
            ...filteredRankings.asMap().entries.map((entry) {
              final index = entry.key;
              final ranking = entry.value;
              return _buildRankCard(ranking, index + 1);
            }),
          ],
        );
      },
    );
  }

  Widget _buildBranchTab() {
    final dashboardAsync = ref.watch(ownerDashboardProvider);

    return dashboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('Gagal memuat data: $error', style: AppTextStyles.caption),
      ),
      data: (metrics) {
        final branches = metrics.branchPerformance;
        if (branches.isEmpty) {
          return const Center(child: Text('Belum ada data cabang'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: [
              Expanded(child: StatCard(
                title: 'Total Cabang',
                value: '${branches.length}',
                icon: Icons.store_rounded,
                color: AppColors.ownerColor,
              )),
              const SizedBox(width: 12),
              Expanded(child: StatCard(
                title: 'Rata-rata Achievement',
                value: '${(branches.fold(0.0, (s, b) => s + b.achievementPercentage) / branches.length).toStringAsFixed(1)}%',
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              )),
            ]),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Performa per Cabang'),
            const SizedBox(height: 8),
            ...branches.asMap().entries.map((entry) {
              final index = entry.key;
              final branch = entry.value;
              return _buildBranchCard(branch, index + 1);
            }),
          ],
        );
      },
    );
  }

  Widget _buildRankCard(SalesRanking ranking, int rank) {
    final scoreColor = ranking.achievementPercentage >= 100
        ? AppColors.success
        : ranking.achievementPercentage >= 80
            ? AppColors.warning
            : AppColors.error;

    final trendIcon = ranking.performanceLevel == 'excellent'
        ? Icons.trending_up
        : ranking.performanceLevel == 'good'
            ? Icons.trending_flat
            : Icons.trending_down;

    final trendColor = ranking.performanceLevel == 'excellent'
        ? AppColors.success
        : ranking.performanceLevel == 'good'
            ? AppColors.warning
            : AppColors.error;

    final medalColor = rank == 1
        ? const Color(0xFFFFD700)
        : rank == 2
            ? const Color(0xFFC0C0C0)
            : rank == 3
                ? const Color(0xFFCD7F32)
                : AppColors.surfaceVariant;

    final medalTextColor = rank <= 3 ? Colors.white : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.sm,
        border: Border.all(
          color: rank <= 3 ? AppColors.ownerColor.withOpacity(0.15) : AppColors.divider,
        ),
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: medalColor, shape: BoxShape.circle),
          child: Center(child: Text('$rank',
              style: TextStyle(fontWeight: FontWeight.w800, color: medalTextColor, fontSize: 14))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ranking.fullName, style: AppTextStyles.bodyMedium),
          Text('Sales • ${ranking.branchName}', style: AppTextStyles.caption),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(children: [
            Icon(trendIcon, size: 14, color: trendColor),
            const SizedBox(width: 4),
            Text('${ranking.achievementPercentage.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: scoreColor)),
          ]),
          const SizedBox(height: 2),
          Text('${ranking.totalOrders} orders',
              style: AppTextStyles.caption.copyWith(fontSize: 11)),
        ]),
      ]),
    );
  }

  Widget _buildBranchCard(BranchMetrics branch, int rank) {
    final achieveColor = branch.achievementPercentage >= 80
        ? AppColors.success
        : branch.achievementPercentage >= 50
            ? AppColors.warning
            : AppColors.error;

    final revStr = branch.revenue >= 1000000
        ? 'Rp ${(branch.revenue / 1000000).toStringAsFixed(1)}Jt'
        : 'Rp ${branch.revenue.toInt()}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.sm,
      ),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: rank <= 3 ? AppColors.ownerColor.withOpacity(0.1) : AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('$rank',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: rank <= 3 ? AppColors.ownerColor : AppColors.textSecondary,
                fontSize: 14,
              ))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(branch.name, style: AppTextStyles.bodyMedium),
          Text('${branch.orders} karyawan • $revStr', style: AppTextStyles.caption),
        ])),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 46, height: 46,
              child: CircularProgressIndicator(
                value: branch.achievementPercentage / 100,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(achieveColor),
                strokeWidth: 4,
              ),
            ),
            Text('${branch.achievementPercentage.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: achieveColor)),
          ],
        ),
      ]),
    );
  }
}
