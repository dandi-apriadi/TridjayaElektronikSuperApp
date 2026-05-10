import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

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
    final branches = ['Semua', ...DummyDataProvider.branches.map((b) => b.name)];
    final totalLowStock = DummyDataProvider.inventories.fold(0, (s, i) => s + i.lowStockCount);
    final totalDailySales = DummyDataProvider.salesData.fold(0, (s, d) => s + d.dailySales);
    final totalRevenue = DummyDataProvider.salesData.fold(0.0, (s, d) => s + d.dailyRevenue);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        color: AppColors.ownerColor,
        child: CustomScrollView(
          slivers: [
            _buildHeader(user?.username ?? 'Owner'),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildBranchFilter(branches),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroMetrics(totalDailySales, totalRevenue, totalLowStock),
                        const SizedBox(height: 20),
                        _buildAttendanceCard(),
                        const SizedBox(height: 20),
                        _buildRevenueChart(),
                        const SizedBox(height: 20),
                        _buildLowStockSection(),
                        const SizedBox(height: 20),
                        _buildPerformanceSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                        // Logo Tridjaya Elektronik
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('📬 Tidak ada notifikasi baru')),
                            );
                          },
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

  Widget _buildHeroMetrics(int sales, double revenue, int lowStock) {
    final revStr = revenue >= 1000000
        ? 'Rp ${(revenue / 1000000).toStringAsFixed(1)}Jt'
        : 'Rp ${revenue.toInt()}';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      SectionHeader(
        title: 'Hari Ini',
        actionLabel: 'Detail Cabang',
        onAction: () {
          final selectedBranchId = _selectedBranchIndex == 0
              ? DummyDataProvider.branches.first.id
              : DummyDataProvider.branches[_selectedBranchIndex - 1].id;
          context.push('/owner/branches/$selectedBranchId');
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
            title: 'Penjualan', value: '$sales unit',
            icon: Icons.shopping_bag_outlined, color: AppColors.success,
          )),
        ]
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: StatCard(
            title: 'Karyawan Hadir', value: '24',
            subtitle: 'dari 28 total',
            icon: Icons.people_outline_rounded, color: AppColors.info,
          )),
          const SizedBox(width: 12),
          Expanded(child: StatCard(
            title: 'Stok Rendah', value: '$lowStock item',
            subtitle: 'Perlu restock',
            icon: Icons.warning_amber_outlined, color: AppColors.error,
            onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⚠️ $lowStock item stok rendah - Segera lakukan restock!'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.error,
              ),
            );
          },
        )),
      ]),
    ]);
  }

  Widget _buildAttendanceCard() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Kehadiran Hari Ini',
        actionLabel: 'Detail',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📋 Detail Kehadiran: Hadir 24, Terlambat 3, Absen 1, Izin 0'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      DonutChartCard(
        title: 'Status Kehadiran Semua Cabang',
        centerLabel: 'Total',
        centerValue: '28',
        data: const [
          ChartPieData(label: 'Hadir', value: 24, color: AppColors.success),
          ChartPieData(label: 'Terlambat', value: 3, color: AppColors.warning),
          ChartPieData(label: 'Absen', value: 1, color: AppColors.error),
          ChartPieData(label: 'Izin', value: 0, color: AppColors.textHint),
        ],
      ),
    ]);
  }

  Widget _buildRevenueChart() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Pendapatan 7 Hari Terakhir',
        actionLabel: 'Laporan',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📈 Laporan Penjualan 7 Hari: Total 131 unit, Rp 2.342.500.000'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      LineChartCard(
        title: 'Tren Penjualan',
        subtitle: 'Unit terjual per hari',
        unit: ' unit',
        xLabels: const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
        series: [
          ChartLineData(label: 'Semua Cabang', values: const [12, 18, 14, 22, 19, 25, 21], color: AppColors.ownerColor),
          ChartLineData(label: 'Cabang Pusat', values: const [5, 7, 6, 9, 8, 11, 9], color: AppColors.success),
        ],
      ),
    ]);
  }

  Widget _vDivider() => Container(width: 1, height: 40, color: AppColors.divider);

  Widget _buildLowStockSection() {
    final alerts = [
      ('Aki GS NS40', 'Cabang Selatan', 5),
      ('TV Samsung 43"', 'Cabang Pusat', 3),
      ('HP Xiaomi Note 13', 'Cabang Timur', 2),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Alert Stok Rendah',
        actionLabel: 'Semua',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠️ Semua Alert Stok Rendah: ${alerts.length} item memerlukan perhatian'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Lihat',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('📦 Menampilkan semua item stok rendah...')),
                  );
                },
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm,
        ),
        child: Column(
          children: alerts.asMap().entries.map((e) {
            final i = e.key;
            final a = e.value;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.$1, style: AppTextStyles.bodyMedium),
                    Text(a.$2, style: AppTextStyles.caption),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(8)),
                    child: Text('${a.$3} unit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error)),
                  ),
                ]),
              ),
              if (i < alerts.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
            ]);
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _buildPerformanceSection() {
    final sales = DummyDataProvider.employees.where((e) => e.role == 'Sales').toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    final nonSales = DummyDataProvider.employees.where((e) => e.role != 'Sales').toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(
        title: 'Top Performer',
        actionLabel: 'Semua',
        onAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('👥 Membuka detail semua Top Performer...'),
              duration: Duration(seconds: 1),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            context.go('/owner/performance');
          });
        },
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: Column(children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.ownerColor,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.ownerColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: AppTextStyles.bodyMedium,
              tabs: const [Tab(text: 'Sales'), Tab(text: 'Non-Sales')],
            ),
          ),
          SizedBox(
            height: 240,
            child: TabBarView(controller: _tabController, children: [
              _rankList(sales.take(4).toList()),
              _rankList(nonSales.take(4).toList()),
            ]),
          ),
        ]),
      ),
    ]);
  }

  Widget _rankList(List<DummyEmployee> emps) {
    final medals = ['🥇', '🥈', '🥉', ''];
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: emps.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 60),
      itemBuilder: (_, i) {
        final e = emps[i];
        final branch = e.branchId == 'b1' ? 'Pusat' : e.branchId == 'b2' ? 'Selatan' : 'Timur';
        final scoreColor = e.score >= 85 ? AppColors.success : e.score >= 70 ? AppColors.warning : AppColors.error;
        return ListTile(
          dense: true,
          leading: Container(width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(medals[i].isNotEmpty ? medals[i] : '${i + 1}',
                style: TextStyle(fontSize: medals[i].isNotEmpty ? 18 : 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)))),
          title: Text(e.name, style: AppTextStyles.bodyMedium),
          subtitle: Text('${e.role} • $branch', style: AppTextStyles.caption),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: scoreColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.score}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scoreColor)),
          ),
        );
      },
    );
  }
}
